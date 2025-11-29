import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/data/industries.dart';
import 'package:depi_graduation_project/data/skills.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:depi_graduation_project/services/supabase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'ips_event.dart';
import 'ips_state.dart';

class IpsBloc extends Bloc<IpsEvent, IpsState> {
  final InvestorFirestoreService investorService;
  final AuthenticationService auth;

  IpsBloc({required this.investorService, required this.auth})
    : super(LoadingInvestorProfile()) {
    on<LoadInvestorData>((event, emit) async {
      await emit.forEach(
        investorService.getInvestorStream(uid: auth.currentUser!.uid),
        onData: (investor) => DisplayInvestorInfo(investor: investor),
      );
    });

    on<EditInvestorButtonPressed>((event, emit) async {
      final investor = await investorService.getInvestor(
        uid: auth.currentUser!.uid,
      );
      emit(EditInvestorInfo(investor: investor));
    });

    on<SaveInvestorButtonPressed>((event, emit) async {
      final inv = await investorService.getInvestor(uid: auth.currentUser!.uid);
      final updatedData = {
        'name': event.name,
        'investorType': event.investorType,
        'about': event.about,
        'phoneNumber': event.phoneNumber,
        'experience': event.experience,
        'skills': event.skills,
        'preferredIndustries': event.preferredIndustries,
        'investmentCapacity': event.investmentCapacity,
        'photoUrl': inv.photoUrl,
        'nationalIdUrl': inv.nationalIdUrl,
      };

      await investorService.updateInvestor(
        uid: auth.currentUser!.uid,
        updatedData: updatedData,
      );

      final updatedInvestor = await investorService.getInvestor(
        uid: auth.currentUser!.uid,
      );
      emit(DisplayInvestorInfo(investor: updatedInvestor));
    });

    on<CancelInvestorButtonPressed>((event, emit) async {
      final investor = await investorService.getInvestor(
        uid: auth.currentUser!.uid,
      );
      emit(DisplayInvestorInfo(investor: investor));
    });

    on<EditInvestorPhoto>((event, emit) async {
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
          await investorService.updateInvestor(
            uid: auth.currentUser!.uid,
            updatedData:
                event.type == 'profile'
                    ? {'photoUrl': photoUrl}
                    : {
                      'nationalIdUrl': photoUrl,
                    }, // Fixed field name to match Firestore
          );

          // Force a refresh of the investor data
          final updatedInvestor = await investorService.getInvestor(
            uid: auth.currentUser!.uid,
          );
          if (state is EditInvestorInfo) {
            emit(
              (state as EditInvestorInfo).copyWith(investor: updatedInvestor),
            );
          }
        }
      }
    });

    on<AddTempSkillButtonPressed>((event, emit) {
      if (state is! EditInvestorInfo) return;
      final current = state as EditInvestorInfo;
      final unavailable = [...current.investor.skills, ...current.tempSkills];
      final available =
          entrepreneurSkills
              .where((skill) => !unavailable.contains(skill))
              .toList();
      emit(current.copyWith(showSkills: true, availableSkills: available));
    });

    on<AddTempSkillInvestor>((event, emit) {
      if (state is! EditInvestorInfo) return;
      final current = state as EditInvestorInfo;
      final updatedTemp = [...current.tempSkills, event.skill];
      final unavailable = [...current.investor.skills, ...updatedTemp];
      final available =
          entrepreneurSkills
              .where((skill) => !unavailable.contains(skill))
              .toList();

      emit(
        current.copyWith(
          tempSkills: updatedTemp,
          availableSkills: available,
          showSkills: false,
        ),
      );
    });

    on<RemoveTempSkillInvestor>((event, emit) {
      if (state is! EditInvestorInfo) return;
      final current = state as EditInvestorInfo;
      final updatedTemp =
          current.tempSkills.where((skill) => skill != event.skill).toList();
      final updatedSaved =
          current.investor.skills
              .where((skill) => skill != event.skill)
              .toList();
      final unavailable = [...updatedSaved, ...updatedTemp];
      final available =
          entrepreneurSkills
              .where((skill) => !unavailable.contains(skill))
              .toList();

      emit(
        current.copyWith(
          tempSkills: updatedTemp,
          investor: current.investor.copyWith(skills: updatedSaved),
          availableSkills: available,
          showSkills: false,
        ),
      );
    });

    on<AddTempIndustryButtonPressed>((event, emit) {
      if (state is! EditInvestorInfo) return;
      final current = state as EditInvestorInfo;
      final unavailable = [
        ...current.investor.preferredIndustries,
        ...current.tempIndustries,
      ];
      final available =
          industries
              .where((industry) => !unavailable.contains(industry))
              .toList();

      emit(
        current.copyWith(showIndustries: true, availableIndustries: available),
      );
    });

    on<AddTempIndustryInvestor>((event, emit) {
      if (state is! EditInvestorInfo) return;
      final current = state as EditInvestorInfo;
      final updatedTemp = [...current.tempIndustries, event.industry];
      final unavailable = [
        ...current.investor.preferredIndustries,
        ...updatedTemp,
      ];
      final available =
          industries
              .where((industry) => !unavailable.contains(industry))
              .toList();

      emit(
        current.copyWith(
          tempIndustries: updatedTemp,
          availableIndustries: available,
          showIndustries: false,
        ),
      );
    });

    on<RemoveTempIndustryInvestor>((event, emit) {
      if (state is! EditInvestorInfo) return;
      final current = state as EditInvestorInfo;
      final updatedTemp =
          current.tempIndustries.where((i) => i != event.industry).toList();
      final updatedSaved =
          current.investor.preferredIndustries
              .where((i) => i != event.industry)
              .toList();
      final unavailable = [...updatedSaved, ...updatedTemp];
      final available =
          industries.where((i) => !unavailable.contains(i)).toList();

      emit(
        current.copyWith(
          tempIndustries: updatedTemp,
          investor: current.investor.copyWith(
            preferredIndustries: updatedSaved,
          ),
          availableIndustries: available,
          showIndustries: false,
        ),
      );
    });

    add(LoadInvestorData());
  }
}
