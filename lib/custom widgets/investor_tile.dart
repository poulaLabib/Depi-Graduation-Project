import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvestorTile extends StatelessWidget {
  final String name;
  final String bio;
  final String? photoPath;
  final String? photoUrl;
  final List<String> industries;
  const InvestorTile({
    this.photoPath,
    this.photoUrl,
    required this.name,
    required this.bio,
    required this.industries,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 245).withAlpha(50),
        border: Border.all(
          color: const Color.fromARGB(255, 74, 74, 74),
          width: 0.2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
              alignment: Alignment.center,
              
              child: GridView.builder(
                itemCount: industries.length,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 1.88,
                  crossAxisSpacing: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: Colors.white.withAlpha(150),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black.withAlpha(30),
                        width: 0.5,
                      ),
                    ),
                    child: AutoText(
                      maxFontSize: 11,
                      minFontSize: 11,
                      maxLines: 2,
                      industries[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
          ),
          VerticalDivider(
            color: const Color.fromARGB(255, 74, 74, 74),
            thickness: 0.1,
            width: 0,
          ),
          Expanded(
            child: Container(
              // color: Colors.black.withAlpha(5),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Column(
                spacing: 2,
                children: [
                  Expanded(
                    flex: 5,

                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                              ? NetworkImage(photoUrl!)
                              : photoPath != null
                                  ? AssetImage(photoPath!)
                                  : null,
                          radius: 45,
                          child: (photoUrl == null || photoUrl!.isEmpty) && photoPath == null
                              ? Icon(Icons.person, size: 45)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 12,
                          child: Image.asset(
                            'assets/images/verified.png',
                            height: 14,
                            width: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Center(
                      child: AutoText(
                        maxFontSize: 13.5,
                        maxLines: 2,
                        minFontSize: 13.5,
                        textAlign: TextAlign.center,
                        name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: const Color.fromARGB(255, 74, 74, 74),
            thickness: 0.1,
            width: 0,
          ),
          Expanded(
            child: Container(
              // color: Colors.black.withAlpha(2),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: AutoText(
                  maxFontSize: 11.5,
                  minFontSize: 11.5,
                  textAlign: TextAlign.left,
                  maxLines: 4,
                  bio,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
