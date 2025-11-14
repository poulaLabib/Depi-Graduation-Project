import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_profile_field.dart';
import 'package:depi_graduation_project/custom%20widgets/entrepreneur_skills_field .dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvestorViewProfileScreen extends StatelessWidget {
  final Investor investor;

  const InvestorViewProfileScreen({
    required this.investor,
    super.key,
  });

  void _pokeInvestor(BuildContext context) {
    final auth = AuthenticationService();
    final notificationService = NotificationFirestoreService();
    final currentUser = auth.currentUser;

    if (currentUser == null) return;

    // Get entrepreneur name
    EntrepreneurFirestoreService()
        .getEntrepreneur(uid: currentUser.uid)
        .then((entrepreneur) {
      notificationService.addNotification(
        receiverId: investor.uid,
        senderId: currentUser.uid,
        senderName: entrepreneur.name,
        type: 'poke',
        message: '${entrepreneur.name} poked you!',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poke sent!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: double.infinity),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Back',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: Theme.of(context).colorScheme.primary,
                          size: 22,
                        ),
                      ),
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (investor.photoUrl.isNotEmpty) {
                              showDialog(
                                barrierDismissible: true,
                                barrierColor: Colors.black.withAlpha(220),
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  contentPadding: EdgeInsets.zero,
                                  content: Center(
                                    child: ClipOval(
                                      child: Image.network(
                                        investor.photoUrl,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.person,
                                          size: 200,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: ClipOval(
                            child: investor.photoUrl.isNotEmpty
                                ? Image.network(
                                    investor.photoUrl,
                                    height: 115,
                                    width: 115,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 115,
                                      width: 115,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 115,
                                    width: 115,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: AutoText(
                            maxFontSize: 20,
                            minFontSize: 20,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            investor.name,
                            style: GoogleFonts.roboto(
                              letterSpacing: -0.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      EntrepreneurProfileField(
                        title: 'About',
                        value: investor.about,
                      ),
                      EntrepreneurProfileField(
                        title: 'Phone Number',
                        value: investor.phoneNumber,
                      ),
                      EntrepreneurSkillsField(
                        title: 'Skills',
                        skills: investor.skills,
                        state: 'toView',
                      ),
                      EntrepreneurProfileField(
                        title: 'Investor Type',
                        value: investor.investorType,
                      ),
                      EntrepreneurProfileField(
                        title: 'Experience',
                        value: investor.experience,
                      ),
                      EntrepreneurProfileField(
                        title: 'Investment Capacity',
                        value: investor.investmentCapacity.toString(),
                      ),
                      EntrepreneurSkillsField(
                        title: 'Preferred Industries',
                        skills: investor.preferredIndustries,
                        state: 'toView',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _pokeInvestor(context),
                        icon: const Icon(Icons.touch_app),
                        label: const Text('Poke'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

