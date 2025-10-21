// import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class RequestCardEnrepreneurView extends StatelessWidget {
  final String companyname;
  final String offer;
  final String equity;
  final String date;
  final String description;
  const RequestCardEnrepreneurView({super.key, required this.companyname, required this.offer, required this.equity, required this.date, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
            width: 280,
            height: 370,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withAlpha(50), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withAlpha(50),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                
            ),
            padding:  EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          height: 130,
          width: double.infinity,
          child: Image.asset(
            'assets/images/company2.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
             SizedBox(height: 12),
             Text(
             companyname,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
                  SizedBox(height: 8),
                  Divider(
                    color: const Color.fromARGB(255, 107, 51, 51).withAlpha(50),
                    thickness: 1,
                    height: 0,
                  ),
                  SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Offer:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            Text(
              "\$$offer",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.green, 
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Equity:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            Text(
              "$equity%",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.green, 
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
           
          ],

        ),
         SizedBox(height: 8),
                  Divider(
                    color: const Color.fromARGB(255, 107, 51, 51).withAlpha(50),
                    thickness: 1,
                    height: 0,
                  ),
                  SizedBox(height: 8),
                  Text(
        "Description:",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      SizedBox(height: 4),
      Text(
        description,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        textAlign: TextAlign.left,
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
      ],
        ),
        ),
      ],
    ),
  );
  }
}
