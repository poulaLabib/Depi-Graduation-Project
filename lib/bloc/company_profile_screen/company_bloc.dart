import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_event.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_state.dart';
import 'package:depi_graduation_project/models/company.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:depi_graduation_project/services/supabase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyFirestoreService company;
  final AuthenticationService auth;

  CompanyBloc({required this.company, required this.auth})
      : super(LoadingCompanyProfile()) {
    on<LoadCompanyProfileData>((event, emit) async {
        // Check if company exists, if not create it
        final exists = await company.companyExists(uid: auth.currentUser!.uid);
        
        if (!exists) {
          // Create default company document
          await company.addCompany(
            name: auth.currentUser?.displayName ?? 'My Company',
            uid: auth.currentUser!.uid,
          );
        }

        // Now stream the company data
        await emit.forEach(
          company.getCompanyStream(uid: auth.currentUser!.uid),
          onData: (data) {
            return DisplayCompanyInfo(company: data);
          },
       
        );
      
    });

    on<EditCompanyButtonPressed>((event, emit) async {
        final comp = await company.getCompany(
          uid: auth.currentUser!.uid,
        );
        
        if (comp != null) {
          emit(EditCompanyInfo(company: comp));
        } else {
        }
      
    });

    on<SaveCompanyButtonPressed>((event, emit) async {
        emit(LoadingCompanyProfile());
        
        Map<String, dynamic> updatedData = {
          'name': event.name,
          'description': event.description,
          'founded': event.founded,
          'teamSize': event.teamSize,
          'industry': event.industry,
          'stage': event.stage,
          'currency': event.currency,
          'location': event.location,
          'teamMembers': event.teamMembers,
        };

        await company.updateCompany(
          uid: auth.currentUser!.uid,
          updatedData: updatedData,
        );
        
        final updatedCompany = await company.getCompany(
          uid: auth.currentUser!.uid,
        );
        
        if (updatedCompany != null) {
          emit(DisplayCompanyInfo(company: updatedCompany));
        } else {
        }
      
    });

    on<CancelCompanyButtonPressed>((event, emit) async {
        emit(LoadingCompanyProfile());
        
        final updatedCompany = await company.getCompany(
          uid: auth.currentUser!.uid,
        );
        
        if (updatedCompany != null) {
          emit(DisplayCompanyInfo(company: updatedCompany));
        } else {
        }
      
    });

    on<EditCompanyLogo>((event, emit) async {
      
        final picker = ImagePicker();
        final xFile = await picker.pickImage(source: ImageSource.gallery);

        if (xFile != null) {
          final file = File(xFile.path);
          final logoUrl = await SupabaseStorage.uploadImage(
            file,
            '${auth.currentUser!.uid}_company_logo',
          );

          if (logoUrl != null) {
            await company.updateCompanyLogoUrl(
              uid: auth.currentUser!.uid,
              newUrl: logoUrl,
            );
          }
        }
      
    });

    on<EditCompanyCertificate>((event, emit) async {
      
        final picker = ImagePicker();
        final xFile = await picker.pickImage(source: ImageSource.gallery);

        if (xFile != null) {
          final file = File(xFile.path);
          final certificateUrl = await SupabaseStorage.uploadImage(
            file,
            '${auth.currentUser!.uid}_company_certificate',
          );

          if (certificateUrl != null) {
            await company.updateCompanyCertificateUrl(
              uid: auth.currentUser!.uid,
              newUrl: certificateUrl,
            );
          }
        }
       
    });

    add(LoadCompanyProfileData());
  }
}