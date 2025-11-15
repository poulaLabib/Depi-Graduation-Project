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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 0,
              right: state == 'toView' ? 0 : 45,
              top: skills.isEmpty ? 14.5 : 0,
              bottom: skills.isEmpty ? 14.5 : 0,
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
                      mainAxisSpacing: 0.75,
                      crossAxisSpacing: 0.75,
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
      ),
    );
  }
}
