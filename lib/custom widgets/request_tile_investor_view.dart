import 'dart:math' as math;
import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestTileInvestorView extends StatelessWidget {
  const RequestTileInvestorView({ super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: const Color.fromARGB(255, 74, 74, 74),
              width: 0.35,
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
                  painter: RectanglesBg(color: Colors.black),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2),
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
                thickness: 0.5,
                width: 0,
              ),
              CustomPaint(
                painter: RectanglesBg(color: Colors.black),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  alignment: Alignment.center,
                  width: constraints.maxWidth / 8,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          'assets/images/profile1.jpg',
                        ),
                      ),
                      AutoText(
                        maxLines: 3,
                        maxFontSize: 10,
                        minFontSize: 10,
                        textAlign: TextAlign.center,
                        'Ahmad Salim',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: const Color.fromARGB(255, 74, 74, 74),
                thickness: 0.5,
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
                  maxFontSize: 10.5,
                  minFontSize: 10.5,
                  maxLines: 4,
                  'Forests are large areas covered mainly by trees and other vegetation. They are often called the lungs of the Earth because they produce oxygen and absorb carbon dioxide, helping to keep our planet’s air clean and balanced.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: constraints.maxHeight * 0.1),
              // VerticalDivider(
              //   color: const Color.fromARGB(255, 74, 74, 74),
              //   thickness: 0.2,
              //   width: 0,
              // ),
              Expanded(
                child: Column(
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(5),
                    //     bottomRight: Radius.circular(5),
                    //   ),

                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     height: constraints.maxHeight / 9,
                    //     width: constraints.maxWidth / 7,
                    //     color: const Color.fromARGB(255, 74, 74, 74),

                    //     child: Text(
                    //       'Fundraise',
                    //       style: GoogleFonts.anton(
                    //         color: Colors.white,
                    //         letterSpacing: 0.5,
                    //         fontSize: 9,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 2,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(27),
                                  topLeft: Radius.circular(27),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(27),
                                            bottomLeft: Radius.circular(27),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: const Color.fromARGB(
                                              255,
                                              0,
                                              0,
                                              0,
                                            ).withAlpha(20),
                                            child: Text(
                                              'Ask',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
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
                                        thickness: 0.5,
                                        width: 0,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 3),
                                          alignment: Alignment.center,
                                          child: AutoText(
                                            maxFontSize: 10,
                                            minFontSize: 10,
                                            maxLines: 4,

                                            '\$200,000',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                70,
                                                110,
                                                149,
                                              ).withAlpha(255),
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(27),
                                  bottomRight: Radius.circular(27),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 3),

                                          alignment: Alignment.center,
                                          child: AutoText(
                                            maxFontSize: 10,
                                            minFontSize: 10,
                                            maxLines: 4,
                                            textAlign: TextAlign.center,
                                            '20% equity',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                70,
                                                110,
                                                149,
                                              ).withAlpha(255),
                                              fontWeight: FontWeight.w900,
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
                                        thickness: 0.5,
                                        width: 0,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          color: const Color.fromARGB(
                                            255,
                                            0,
                                            0,
                                            0,
                                          ).withAlpha(20),

                                          alignment: Alignment.center,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'In\nret..',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              fontSize: 10.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
    int rows = 2;
    int columns = 1;
    final random = math.Random();

    final rectWidth = size.width / columns;
    final rectHeight = size.height / rows;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        final paint =
            Paint()
              ..color = color.withAlpha(10 + random.nextInt(10))
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0);
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
