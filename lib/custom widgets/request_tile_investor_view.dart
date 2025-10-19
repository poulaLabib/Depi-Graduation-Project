import 'dart:math' as math;
import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestTileInvestorView extends StatelessWidget {
  const RequestTileInvestorView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: const Color.fromARGB(255, 74, 74, 74),
              width: 0.7,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27),
                  bottomLeft: Radius.circular(27),
                ),
                child: CustomPaint(
                  painter: RectanglesBg(
                    color: const Color.fromARGB(255, 145, 199, 229),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth / 8,
                    height: constraints.maxHeight,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        'assets/images/company2.jpeg',
                      ),
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: const Color.fromARGB(255, 74, 74, 74),
                thickness: 1,
                width: 0,
              ),
              CustomPaint(
                painter: RectanglesBg(
                  color: const Color.fromARGB(255, 145, 199, 229),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: constraints.maxWidth / 8,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundImage: AssetImage(
                          'assets/images/profile1.jpg',
                        ),
                      ),
                      AutoText(
                        maxLines: 3,
                        maxFontSize: 11,
                        minFontSize: 11,
                        textAlign: TextAlign.center,
                        'Ahmad Salim',
                        style: GoogleFonts.robotoSlab(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: const Color.fromARGB(255, 74, 74, 74),
                thickness: 1,
                width: 0,
              ),
              SizedBox(width: constraints.maxHeight * 0.1),
              Container(
                decoration: BoxDecoration(
                  // color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all( color: const Color.fromARGB(255, 74, 74, 74), width: )
                ),
                height: 0.9 * constraints.maxHeight,
                width: constraints.maxWidth / 3,
                // padding: EdgeInsets.all(5),
                child: AutoText(
                  maxFontSize: 11,
                  minFontSize: 10,
                  maxLines: 5,
                  'Forests are large areas covered mainly by trees and other vegetation. They are often called the lungs of the Earth because they produce oxygen and absorb carbon dioxide, helping to keep our planet’s air clean and balanced.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(150),
                  ),
                ),
              ),
              SizedBox(width: constraints.maxHeight * 0.1),
              VerticalDivider(
                color: const Color.fromARGB(255, 74, 74, 74),
                thickness: 0.2,
                width: 0,
              ),
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),

                      child: Container(
                        alignment: Alignment.center,
                        height: constraints.maxHeight / 7,
                        width: constraints.maxWidth / 6,
                        color: const Color.fromARGB(255, 74, 74, 74),

                        child: Text(
                          'Fundraise',
                          style: GoogleFonts.anton(
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 3,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(27),
                              topLeft: Radius.circular(27),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: constraints.maxHeight / 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(27),
                                        bottomLeft: Radius.circular(27),
                                      ),
                                      child: CustomPaint(
                                        painter: RectanglesBg(
                                          color: const Color.fromARGB(
                                            255,
                                            145,
                                            199,
                                            229,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,

                                          child: Text(
                                            'Ask',
                                            style: GoogleFonts.anton(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                255,
                                                74,
                                                74,
                                                74,
                                              ),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: const Color.fromARGB(
                                      255,
                                      74,
                                      74,
                                      74,
                                    ),
                                    thickness: 1,
                                    width: 0,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '10000000 EGP',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                       
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(27),
                              bottomLeft: Radius.circular(27),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: constraints.maxHeight / 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '20% Equity',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: const Color.fromARGB(
                                      255,
                                      74,
                                      74,
                                      74,
                                    ),
                                    thickness: 1,
                                    width: 0,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(27),
                                        bottomRight: Radius.circular(27),
                                      ),
                                      child: CustomPaint(
                                        painter: RectanglesBg(
                                          color: const Color.fromARGB(
                                            255,
                                            145,
                                            199,
                                            229,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'In Return',
                                            style: GoogleFonts.anton(
                                              // fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                255,
                                                74,
                                                74,
                                                74,
                                              ),
                                              letterSpacing: 0.5,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RectanglesBg extends CustomPainter {
  final Color color;

  RectanglesBg({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    int rows = 4;
    int columns = 4;
    final random = math.Random();

    final rectWidth = size.width / columns;
    final rectHeight = size.height / rows;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        final paint =
            Paint()
              ..color = color.withAlpha(100 + random.nextInt(20))
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
        final rect = Rect.fromLTWH(
          x * rectWidth,
          y * rectHeight,
          rectWidth,
          rectHeight,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RectanglesBg oldDelegate) {
    return oldDelegate.color != color;
  }
}
