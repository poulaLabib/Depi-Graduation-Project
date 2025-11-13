import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_event.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_state.dart';
import 'package:depi_graduation_project/data/skills.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:depi_graduation_project/services/supabase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EpsBloc extends Bloc<EpsEvent, EpsState> {
  final EntrepreneurFirestoreService entrepreneur;
  final AuthenticationService auth;

  EpsBloc({required this.entrepreneur, required this.auth})
    : super(LoadingProfile()) {
    on<LoadProfileData>((event, emit) async {
      await emit.forEach(
        entrepreneur.getEntrepreneurStream(uid: auth.currentUser!.uid),
        onData: (data) {
          return DisplayInfo(entrepreneur: data);
        },
      );
    });
    on<EditButtonPressed>((event, emit) async {
      final entrep = await entrepreneur.getEntrepreneur(
        uid: auth.currentUser!.uid,
      );
      emit(EditInfo(entrepreneur: entrep));
    });
    on<SaveButtonPressed>((event, emit) async {
      final entrep = await entrepreneur.getEntrepreneur(
        uid: auth.currentUser!.uid,
      );
      Map<String, dynamic> updatedData = {
        'name': event.name,
        'about': event.about,
        'phoneNumber': event.phoneNumber,
        'experience': event.experience,
        'skills': event.skills,
        'role': event.role,
        'profilePhotoUrl': entrep.profileImageUrl,
        'idImageUrl': entrep.idImageUrl,
      };

      await entrepreneur.updateEntrepreneur(
        uid: auth.currentUser!.uid,
        updatedData: updatedData,
      );
      final updatedEntrepreneur = await entrepreneur.getEntrepreneur(
        uid: auth.currentUser!.uid,
      );
      emit(DisplayInfo(entrepreneur: updatedEntrepreneur));
    });

    on<CancelButtonPressed>((event, emit) async {
      final updatedEntrepreneur = await entrepreneur.getEntrepreneur(
        uid: auth.currentUser!.uid,
      );
      emit(DisplayInfo(entrepreneur: updatedEntrepreneur));
    });
    on<EditPhoto>((event, emit) async {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        final file = File(xFile.path);
        final photoUrl = await SupabaseStorage.uploadImage(
          file,
          auth.currentUser!.uid,
          type: event.type,
        );
        if (photoUrl != null) {
          if (event.type == 'profile') {
            await entrepreneur.updateEntrepreneurProfilePhotoUrl(
              uid: auth.currentUser!.uid,
              newUrl: photoUrl,
            );
          } else if (event.type == 'id') {
            await entrepreneur.updateEntrepreneurNationalIdUrl(
              uid: auth.currentUser!.uid,
              newUrl: photoUrl,
            );
          }
        }
      }
    });

    on<AddSkillButtonPressed>((event, emit) {
      final current = state as EditInfo;

      final unavailable = [
        ...current.entrepreneur.skills,
        ...current.tempSkills,
      ];

      final available =
          entrepreneurSkills.where((s) => !unavailable.contains(s)).toList();

      emit(current.copyWith(availableSkills: available, showSkills: true));
    });

    on<AddTempSkill>((event, emit) {
      if (state is EditInfo) {
        final current = state as EditInfo;

        final updatedTemp = [...current.tempSkills, event.skill];
        final unavailable = [...current.entrepreneur.skills, ...updatedTemp];

        final updatedAvailable =
            entrepreneurSkills
                .where((skill) => !unavailable.contains(skill))
                .toList();

        emit(
          current.copyWith(
            tempSkills: updatedTemp,
            availableSkills: updatedAvailable,
            showSkills: false,
          ),
        );
      }
    });
    on<RemoveTempSkill>((event, emit) {
      if (state is EditInfo) {
        final current = state as EditInfo;

        final updatedTemp =
            current.tempSkills.where((s) => s != event.skill).toList();
        final updatedSaved =
            current.entrepreneur.skills.where((s) => s != event.skill).toList();

        final unavailable = [...updatedSaved, ...updatedTemp];
        final updatedAvailable =
            entrepreneurSkills
                .where((skill) => !unavailable.contains(skill))
                .toList();

        emit(
          current.copyWith(
            tempSkills: updatedTemp,
            entrepreneur: current.entrepreneur.copyWith(skills: updatedSaved),
            availableSkills: updatedAvailable,
            showSkills: false,
          ),
        );
      }
    });

    add(LoadProfileData());
  }
}
