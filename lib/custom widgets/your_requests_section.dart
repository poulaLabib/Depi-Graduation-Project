import 'package:depi_graduation_project/bloc/Request section/requests_section_bloc.dart';
import 'package:depi_graduation_project/bloc/Request section/requests_section_event.dart';
import 'package:depi_graduation_project/bloc/Request section/requests_section_state.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_bloc.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_event.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_textfield.dart';
import 'package:depi_graduation_project/custom%20widgets/request_card_enrepreneur_view.dart';
import 'package:depi_graduation_project/screens/request_screen_entrepreneurs_view.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YourRequestsSection extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountOfMoneyController =
      TextEditingController();
  final TextEditingController _equityInReturnController =
      TextEditingController();
  final TextEditingController _whyAreYouRaisingController =
      TextEditingController();
  YourRequestsSection({super.key});

  Future<Map<String, String?>> _getCompanyInfo(String uid) async {
    try {
      final companyExists = await CompanyFirestoreService().companyExists(uid: uid);
      if (companyExists) {
        final company = await CompanyFirestoreService().getCompany(uid: uid);
        return {'name': company.name, 'logoUrl': company.logoUrl};
      }
    } catch (e) {
      // Handle error
    }
    return {'name': null, 'logoUrl': null};
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsSectionBloc, RequestsSectionState>(
      builder: (context, state) {
        if (state is LoadingRequests) {
          return Center(child: CircularProgressIndicator());
        } else if (state is NoRequests) {
          return Center(
            child: InkWell(
              onTap: () {
                context.read<RequestsSectionBloc>().add(
                  AddRequestButtonPressed(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  'Add request',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                ),
              ),
            ),
          );
        } else if (state is DisplayRequests) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: state.requests.length,
                  itemBuilder: (context, index) {
                    final request = state.requests[index];
                    return FutureBuilder<Map<String, String?>>(
                      future: _getCompanyInfo(request.uid),
                      builder: (context, snapshot) {
                        return InkWell(
                          onTap: () {
                            context.read<RequestScreenBloc>().add(
                              LoadRequest(request: request),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestPageEntrepreneur(),
                              ),
                            );
                          },
                          child: RequestCardEnrepreneurView(
                            request: request,
                            companyName: snapshot.data?['name'],
                            companyLogoUrl: snapshot.data?['logoUrl'],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
      listener: (context, state) {
        if (state is NoRequests && state.showAddRequestDialog) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    'Add request',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          EntrepreneurProfileTextfield(
                            title: 'Description',
                            controller: _descriptionController,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                          ),
                          EntrepreneurProfileTextfield(
                            title: 'Amount of money',
                            controller: _amountOfMoneyController,
                            keyboardType: TextInputType.number,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                          ),
                          EntrepreneurProfileTextfield(
                            title: 'What do you offer in return ?',
                            controller: _equityInReturnController,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                          ),
                          EntrepreneurProfileTextfield(
                            title: 'Why are you raising ? (optional)',
                            controller: _whyAreYouRaisingController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.read<RequestsSectionBloc>().add(
                            AddRequestConfirmed(
                              description: _descriptionController.text,
                              amountOfMoney:
                                  double.tryParse(
                                    _amountOfMoneyController.text,
                                  ) ??
                                  0.0,
                              equityInReturn: _equityInReturnController.text,
                              whyAreYouRaising:
                                  _whyAreYouRaisingController.text,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
