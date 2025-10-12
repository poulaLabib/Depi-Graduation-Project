import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestCardEnrepreneurView extends StatelessWidget {
  const RequestCardEnrepreneurView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withAlpha(50), width: 1),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/images/company2.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(color: Colors.black.withAlpha(70)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Theme.of(context).colorScheme.tertiary,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withAlpha(30),
                        child: AutoText(
                          maxFontSize: 12,
                          minFontSize: 12,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          'We built an app that helps small shops sell online in minutes. Already 1,200 shops joined in 3 months. We’re raising \$100k to scale to more cities',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black.withAlpha(50),
                      thickness: 1,
                      height: 0,
                    ),
                    Expanded(
                      
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          spacing: 2,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(40),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      'Amount asked',
                                      style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onTertiary,
                                      ),
                                    ),
                                    Text(
                                      '100000\$',
                                      style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      'Equity in return',
                                      style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onTertiary,
                                      ),
                                    ),
                                    Text(
                                      '7%',
                                      style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onTertiary,
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
                    Divider(
                      color: Colors.black.withAlpha(50),
                      thickness: 1,
                      height: 0,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withAlpha(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          spacing: 7,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 7,
                              children: [
                                Image.asset(
                                  'assets/images/money-bag.png',
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  'Fundraising request',
                                  style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onTertiary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 7,
                              children: [
                                Image.asset(
                                  'assets/images/calendar (1).png',
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  '1/10/2025',
                                  style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
