import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_event.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_state.dart';
// import 'package:depi_graduation_project/custom%20widgets/your_requests_section.dart';
import 'package:depi_graduation_project/custom%20widgets/investor_tile.dart';
import 'package:depi_graduation_project/custom%20widgets/investors_section.dart';
// import 'package:depi_graduation_project/custom%20widgets/investors_section.dart';
import 'package:depi_graduation_project/custom%20widgets/request_card_enrepreneur_view.dart';
import 'package:depi_graduation_project/custom%20widgets/request_tile_investor_view.dart';
import 'package:depi_graduation_project/custom%20widgets/your_requests_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  EntrepreneurHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EhsBloc, EhsState>(
      builder: (context, state) {
        if (state is LoadingHome) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DisplayHome) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _pageController.jumpToPage(state.displayedSectionIndex);
          });

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
                          onTap: () {
                            context.read<EhsBloc>().add(ShowInvestors());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            decoration: BoxDecoration(
                              color:
                                  state.displayedSectionIndex == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
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
                          onTap: () {
                            context.read<EhsBloc>().add(ShowRequests());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            decoration: BoxDecoration(
                              color:
                                  state.displayedSectionIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              'Your requests',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
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
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [InvestorsSection(), YourRequestsSection()],
                  ),
                ),
                // Expanded(
                //   child: GridView(
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 1,
                //       childAspectRatio: 5.3,
                //       mainAxisSpacing: 7,
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 5),
                //     children: [
                //       InvestorTile(photoPath: 'assets/images/elsweedy.jpeg', name: 'Ahmad elsweedy', bio: 'Ahmed Elsewedy was appointed as a member of Elsewedy Electric’s Board of Directors in 2005, and currently serves as President and Chief Executive Officer of the company',),
                //       InvestorTile(photoPath: 'assets/images/naguib.webp', name: 'Naguib Sawiris elsweedy', bio: 'Naguib Sawiris is a scion of Egypt\'s wealthiest family. His brother Nassef is also a billionaire.'),
                //       InvestorTile(photoPath: 'assets/images/mohamedfarouk.jpeg', name: 'Mohamed Farouk', bio: 'Mohamed Farouk conquered the world of furniture manufacturing, in addition to being a prominent Angel and Venture Capital Investor',),
                //     ],
                //   ),
                // ),
                // Expanded(
                //   child: GridView.builder(
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 1,
                //       childAspectRatio: 2.7,
                //       mainAxisSpacing: 5
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 7),
                //     itemCount: 4,
                //     itemBuilder: (context, index) {
                //       return RequestTileInvestorView();
                //     },
                //   ),
                // ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
      listener: (context, state) {},
    );
  }
}
