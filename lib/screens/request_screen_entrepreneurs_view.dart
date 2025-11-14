import 'package:depi_graduation_project/bloc/request_screen/request_screen_bloc.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_event.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_state.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_field.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_textfield.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestPageEntrepreneur extends StatefulWidget {
  const RequestPageEntrepreneur({super.key});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPageEntrepreneur> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _equityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8EE),
      body: BlocConsumer<RequestScreenBloc, RequestScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingRequest) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DisplayingRequest) {
            _descriptionController.text = state.request.description;
            _amountController.text = state.request.amountOfMoney.toString();
            _equityController.text = state.request.equityInReturn;
            _reasonController.text = state.request.whyAreYouRaising;
            return _buildReadOnlyContent(context);
          } else if (state is EditingRequest) {
            return _buildEditableContent(context);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReadOnlyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: buildTopWhiteButton("Edit", () {
                context.read<RequestScreenBloc>().add(
                      EditRequestRequested(),
                    );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                EntrepreneurProfileField(
                  title: 'Description',
                  value: _descriptionController.text,
                ),
                EntrepreneurProfileField(
                  title: 'Amount of money asked',
                  value: _amountController.text,
                ),
                EntrepreneurProfileField(
                  title: 'In return',
                  value: _equityController.text,
                ),
                EntrepreneurProfileField(
                  title: 'Reason for the request',
                  value: _reasonController.text,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTabButton("Founder", const Color(0xFF91C7E5)),
                    buildTabButton("Company", const Color(0xFF91C7E5)),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    buildRoundButton(
                      "Statue",
                      Colors.green,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    buildRoundButton(
                      "Cancel",
                      Colors.red,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildTopWhiteButton("cancel", () {
                  context.read<RequestScreenBloc>().add(
                        CancelButtonPressed(),
                      );
                }),
                const SizedBox(width: 10),
                buildTopWhiteButton("save", () {
                  context.read<RequestScreenBloc>().add(
                        EditRequestConfirmed(
                          description: _descriptionController.text,
                          whyAreYouRaising: _reasonController.text,
                          amountOfMoney: _amountController.text,
                          equityInReturn: _equityController.text,
                        ),
                      );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                EntrepreneurProfileTextfield(
                  title: 'Description',
                  controller: _descriptionController,
                ),
                EntrepreneurProfileTextfield(
                  title: 'Amount of money asked',
                  controller: _amountController,
                ),
                EntrepreneurProfileTextfield(
                  title: 'In return',
                  controller: _equityController,
                ),
                EntrepreneurProfileTextfield(
                  title: 'Reason for the request',
                  controller: _reasonController,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTabButton("Founder", const Color(0xFF91C7E5)),
                    buildTabButton("Company", const Color(0xFF91C7E5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          alignment: Alignment.center,
          child: FutureBuilder(
            future: _getCompanyInfo(),
            builder: (context, snapshot) {
              final logoUrl = snapshot.data?['logoUrl'] ?? '';
              if (snapshot.hasData && logoUrl.isNotEmpty) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                );
              }
              return Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    (snapshot.data?['name'] ?? 'C')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Future<Map<String, String>> _getCompanyInfo() async {
    try {
      final state = context.read<RequestScreenBloc>().state;
      Request? request;
      if (state is DisplayingRequest) {
        request = state.request;
      } else if (state is EditingRequest) {
        request = state.request;
      }
      
      if (request != null) {
        final uid = request.uid;
        final companyExists = await CompanyFirestoreService().companyExists(uid: uid);
        if (companyExists) {
          final company = await CompanyFirestoreService().getCompany(uid: uid);
          return {'name': company.name, 'logoUrl': company.logoUrl};
        }
      }
    } catch (e) {
      // Handle error
    }
    return {'name': 'Company', 'logoUrl': ''};
  }

  Widget buildRoundButton(
    String text,
    Color bgColor, {
    Color textColor = Colors.black,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget buildTabButton(
    String text,
    Color bgColor, {
    Color textColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTopWhiteButton(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
