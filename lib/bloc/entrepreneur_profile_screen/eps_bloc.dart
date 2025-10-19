import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_event.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_state.dart';
import 'package:depi_graduation_project/models/entrepreneur.dart';
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
    on<EditProfilePhoto>((event, emit) async {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        final file = File(xFile.path);
        final photoUrl = await SupabaseStorage.uploadImage(
          file,
          auth.currentUser!.uid,
        );

        if (photoUrl != null) {
          await entrepreneur.updateEntrepreneurProfilePhotoUrl(
            uid: auth.currentUser!.uid,
            newUrl: photoUrl,
          );
        }
      }
    });
    add(LoadProfileData());
  }
}
