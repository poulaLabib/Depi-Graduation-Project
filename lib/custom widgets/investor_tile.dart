import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvestorTile extends StatelessWidget {
  final String name;
  final String bio;
  final String photoPath;
  const InvestorTile({required this.photoPath, required this.name, required this.bio, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      ),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(photoPath),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    AutoText(
                      maxFontSize: 14,
                      minFontSize: 12,
                      maxLines: 1,
                      name,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    Image.asset(
                      'assets/images/verified.png',
                      height: 15,
                      width: 15,
                      color: Colors.green,
                    ),
                  ],
                ),
                AutoText(
                  maxFontSize: 10,
                  minFontSize: 8,
                  maxLines: 2,
                  bio,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(
                      context,
                    ).colorScheme.onTertiary.withAlpha(100),
                  ),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary.withAlpha(20),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Real Estate',
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary.withAlpha(20),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Health Care',
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary.withAlpha(20),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Finance',
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
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
}
