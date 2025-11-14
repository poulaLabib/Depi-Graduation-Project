import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'skill_card.dart';

class EntrepreneurSkillsField extends StatelessWidget {
  final String title;
  final List<String> skills;
  final String state;
  final ValueChanged<String>? onRemove;
  const EntrepreneurSkillsField({
    super.key,
    required this.state,
    required this.title,
    required this.skills,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            letterSpacing: -0.1,
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 5,
            right: state == 'toView' ? 5 : 45,
            top: skills.isEmpty ? 14.5 : 5,
            bottom: skills.isEmpty ? 14.5 : 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF91C7E5).withAlpha(200),
            // color: Theme.of(context).colorScheme.surface.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withAlpha(40), width: 1),
          ),
          child:
              skills.isEmpty
                  ? SizedBox(height: 15)
                  : StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    itemCount: skills.length,

                    physics: const NeverScrollableScrollPhysics(),
                    staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    itemBuilder: (context, index) {
                      final item = skills[index];
                      return SkillCard(
                        text: item,
                        onTap:
                            state == 'toRemove' && onRemove != null
                                ? () => onRemove!(item)
                                : null,
                        state: state,
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
