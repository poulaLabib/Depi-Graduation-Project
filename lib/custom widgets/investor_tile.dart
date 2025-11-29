import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';

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
        // color: Theme.of(context).colorScheme.primary.withAlpha(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(

        children: [
          Expanded(
            flex: 10,
            child: Container(
              // color: Colors.black.withAlpha(5),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Column(
                spacing: 2,
                children: [
                  Expanded(
                    flex: 5,

                    child: CircleAvatar(
                      backgroundImage:
                          photoUrl != null && photoUrl!.isNotEmpty
                              ? NetworkImage(photoUrl!)
                              : photoPath != null
                              ? AssetImage(photoPath!)
                              : null,
                      radius: 45,
                      child:
                          (photoUrl == null || photoUrl!.isEmpty) &&
                                  photoPath == null
                              ? Icon(Icons.person, size: 45)
                              : null,
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Center(
                      child: AutoText(
                        maxFontSize: 16,
                        maxLines: 2,
                        minFontSize: 15,
                        textAlign: TextAlign.center,
                        name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              // color: Colors.green,
              alignment: Alignment.topCenter,

              child:
                  industries.isEmpty
                      ? Center(
                        child: AutoText(
                          maxFontSize: 11,
                          minFontSize: 11,
                          maxLines: 2,
                          'No industries',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: industries.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            margin: EdgeInsets.only(right: 3),
                            
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withAlpha(100),
                                width: 1,
                              ),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withAlpha(20),

                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              industries[index],
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),

          // Divider(
          //   color: Theme.of(context).colorScheme.primary,
          //   thickness: 0.3,
          //   height: 0,
          // ),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: AutoText(
                  maxFontSize: 12,
                  minFontSize: 12,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  bio,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
