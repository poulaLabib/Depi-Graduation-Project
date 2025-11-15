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
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.primary,
          width: 0.2,
        ),
              color: Theme.of(context).colorScheme.secondary.withAlpha(40),

        borderRadius: BorderRadius.circular(30),
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
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (state != 'toView')
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
              
                  child: Icon(
                    state == 'toAdd'
                        ? CupertinoIcons.add
                        : CupertinoIcons.minus,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(onTap == null ? 120 : 255),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}