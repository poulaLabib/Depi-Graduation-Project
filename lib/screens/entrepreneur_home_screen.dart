import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_event.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_state.dart';
import 'package:depi_graduation_project/custom%20widgets/your_requests_section.dart';
import 'package:depi_graduation_project/custom%20widgets/investor_tile.dart';
import 'package:depi_graduation_project/custom%20widgets/investors_section.dart';
import 'package:depi_graduation_project/custom%20widgets/request_card_enrepreneur_view.dart';
import 'package:depi_graduation_project/custom%20widgets/request_tile_investor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              actionsPadding: EdgeInsets.only(right: 12),
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    CupertinoIcons.bell_fill,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            context.read<EhsBloc>().add(ShowInvestors());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
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
                                fontWeight: FontWeight.w500,
                                fontSize: 14.5,
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
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  state.displayedSectionIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              'My requests',
                              textAlign: TextAlign.center
                              ,
                              style: TextStyle(
                                color:
                                Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.5,
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
