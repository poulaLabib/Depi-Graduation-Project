import 'package:depi_graduation_project/custom%20widgets/investor_tile.dart';
import 'package:depi_graduation_project/custom%20widgets/request_card_enrepreneur_view.dart';
import 'package:flutter/material.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  const EntrepreneurHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actionsPadding: EdgeInsets.only(right: 10),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
              size: 27,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              spacing: 30,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Investors',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Your requests',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {

                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(10),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Image.asset(
                    'assets/images/panel.png',
                    height: 22,
                    width: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black.withAlpha(50),
            thickness: 1,
            indent: 10,
            endIndent: 300,
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5.3,
                mainAxisSpacing: 7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 5),
              children: [
                InvestorTile(photoPath: 'assets/images/elsweedy.jpeg', name: 'Ahmad elsweedy', bio: 'Ahmed Elsewedy was appointed as a member of Elsewedy Electric’s Board of Directors in 2005, and currently serves as President and Chief Executive Officer of the company',),
                InvestorTile(photoPath: 'assets/images/naguib.webp', name: 'Naguib Sawiris elsweedy', bio: 'Naguib Sawiris is a scion of Egypt\'s wealthiest family. His brother Nassef is also a billionaire.'),
                InvestorTile(photoPath: 'assets/images/mohamedfarouk.jpeg', name: 'Mohamed Farouk', bio: 'Mohamed Farouk conquered the world of furniture manufacturing, in addition to being a prominent Angel and Venture Capital Investor',),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1
              ),
              padding: EdgeInsets.symmetric(horizontal: 40),
              itemCount: 1,
              itemBuilder: (context, index) {
                return RequestCardEnrepreneurView();
              },
            ),
          ),
        ],
      ),
    );
  }
}
