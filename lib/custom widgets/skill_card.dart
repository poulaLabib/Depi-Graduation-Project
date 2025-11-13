import 'package:auto_text_resizer/auto_text_resizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  // states are either ('toAdd, toRemove, toView')
  final String state;
  const SkillCard({
    super.key,
    required this.text,
    this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withAlpha(state == 'toAdd' ? 150 : 40),
          width: state == 'toAdd' ? 1 : 0.3,
        ),
        color: const Color.fromARGB(255, 251, 106, 62),

        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
              child: AutoText(
                text,
                maxFontSize: 13,
                minFontSize: 13,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (state != 'toView')
            Expanded(
              flex: 1,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                  child: Icon(
                    state == 'toAdd'
                        ? CupertinoIcons.add
                        : CupertinoIcons.minus,
                    color: Colors.black.withAlpha(onTap == null ? 120 : 255),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
