import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_event.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_state.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:depi_graduation_project/services/supabase_storage.dart';
import 'package:image_picker/image_picker.dart';

class IpsBloc extends Bloc<IpsEvent, IpsState> {
  final InvestorFirestoreService investor;
  final AuthenticationService auth;

  IpsBloc({required this.investor, required this.auth})
    : super(LoadingProfile()) {
    on<LoadProfileData>((event, emit) async {
      await emit.forEach(
        investor.getInvestorStream(uid: auth.currentUser!.uid),
        onData: (data) {
          return DisplayInfo(investor: data);
        },
      );
    });
    on<EditButtonPressed>((event, emit) async {
      final inv = await investor.getInvestor(uid: auth.currentUser!.uid);
      emit(EditInfo(investor: inv));
    });
    on<SaveButtonPressed>((event, emit) async {
      final inv = await investor.getInvestor(uid: auth.currentUser!.uid);
      Map<String, dynamic> updatedData = {
        'name': event.name,
        'investorType': event.investorType,
        'about': event.about,
        'phoneNumber': event.phoneNumber,
        'experience': event.experience,
        'skills': event.skills,
        'investmentCapacity': event.investmentCapacity,
        'preferredIndustries': event.preferredIndustries,
        'nationalIdUrl': inv.nationalIdUrl,
        'photoUrl': inv.photoUrl,
      };

      await investor.updateInvestor(
        uid: auth.currentUser!.uid,
        updatedData: updatedData,
      );
      final updatedInvestor = await investor.getInvestor(
        uid: auth.currentUser!.uid,
      );
      emit(DisplayInfo(investor: updatedInvestor));
    });

    on<CancelButtonPressed>((event, emit) async {
      final updatedInvestor = await investor.getInvestor(
        uid: auth.currentUser!.uid,
      );
      emit(DisplayInfo(investor: updatedInvestor));
    });
    on<EditProfilePhoto>((event, emit) async {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        final file = File(xFile.path);
        final inv = await investor.getInvestor(uid: auth.currentUser!.uid);

        final photoUrl = await SupabaseStorage.uploadImage(
          file,
          auth.currentUser!.uid,
          oldUrl: inv.photoUrl,
        );

        if (photoUrl != null) {
          await investor.updateInvestorProfilePhotoUrl(
            uid: auth.currentUser!.uid,
            newUrl: photoUrl,
          );

          final updatedInvestor = await investor.getInvestor(
            uid: auth.currentUser!.uid,
          );

          emit(EditInfo(investor: updatedInvestor));
        }
      }
    });

    on<EditNationalIdPhoto>((event, emit) async {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        final file = File(xFile.path);
        final inv = await investor.getInvestor(uid: auth.currentUser!.uid);

        final nationalIdUrl = await SupabaseStorage.uploadImage(
          file,
          auth.currentUser!.uid,
          oldUrl: inv.nationalIdUrl,
        );

        if (nationalIdUrl != null) {
          await investor.updateInvestorNationalIdUrl(
            uid: auth.currentUser!.uid,
            newUrl: nationalIdUrl,
          );

          final updatedInvestor = await investor.getInvestor(
            uid: auth.currentUser!.uid,
          );

          emit(EditInfo(investor: updatedInvestor));
        }
      }
    });

    add(LoadProfileData());
  }
}
