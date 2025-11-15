import 'package:depi_graduation_project/bloc/Investor section/investor_section_bloc.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_event.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_state.dart';
import 'package:depi_graduation_project/custom%20widgets/investor_tile.dart';
import 'package:depi_graduation_project/data/industries.dart';
import 'package:depi_graduation_project/screens/investor_view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvestorsSection extends StatelessWidget {
  const InvestorsSection({super.key});

  void _showFilterDialog(BuildContext context, InvestorSectionState state) {
    if (state is! DisplayInvestors) return;

    final selectedIndustries = List<String>.from(
      state.selectedIndustries ?? [],
    );
    final minCapacityController = TextEditingController(
      text: state.minInvestmentCapacity?.toString() ?? '',
    );
    final maxCapacityController = TextEditingController(
      text: state.maxInvestmentCapacity?.toString() ?? '',
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Theme.of(context).colorScheme.onSurface.withAlpha(220),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                'Filter Investors',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Industries',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: industries.map((industry) {
                          final isSelected = selectedIndustries.contains(industry);
                          return FilterChip(
                            label: Text(
                              industry,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedIndustries.add(industry);
                                } else {
                                  selectedIndustries.remove(industry);
                                }
                              });
                            },
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            selectedColor: Theme.of(context).colorScheme.primary,
                            checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline.withAlpha(100),
                                width: 1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Investment Capacity',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minCapacityController,
                              decoration: InputDecoration(
                                labelText: 'Min',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: maxCapacityController,
                              decoration: InputDecoration(
                                labelText: 'Max',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<InvestorSectionBloc>().add(ClearFilters());
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<InvestorSectionBloc>().add(
                      FilterInvestors(
                        selectedIndustries: selectedIndustries.isEmpty
                            ? null
                            : selectedIndustries,
                        minInvestmentCapacity: minCapacityController.text.isNotEmpty
                            ? int.tryParse(minCapacityController.text)
                            : null,
                        maxInvestmentCapacity: maxCapacityController.text.isNotEmpty
                            ? int.tryParse(maxCapacityController.text)
                            : null,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestorSectionBloc, InvestorSectionState>(
      builder: (context, state) {
        if (state is LoadingInvestors) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorLoadingInvestors) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<InvestorSectionBloc>().add(LoadInvestors());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is DisplayInvestors) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _showFilterDialog(context, state),
                icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
              ),
              Expanded(
                child:
                    state.filteredInvestors.isEmpty
                        ? const Center(child: Text('No investors found'))
                        : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.625,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            // vertical: 10,
                          ),
                          itemCount: state.filteredInvestors.length,
                          itemBuilder: (context, index) {
                            final investor = state.filteredInvestors[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(15),
                              splashColor: Theme.of(context).colorScheme.onSurface.withAlpha(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => InvestorViewProfileScreen(
                                          investor: investor,
                                        ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: InvestorTile(
                                      photoUrl:
                                          investor.photoUrl.isNotEmpty
                                              ? investor.photoUrl
                                              : null,
                                      name: investor.name,
                                      bio:
                                          investor.about.isNotEmpty
                                              ? investor.about
                                              : 'No bio available',
                                      industries: investor.preferredIndustries,
                                    ),
                                  ),
                                  // Divider(
                                  //   color:
                                  //       Theme.of(context).colorScheme.onSurface,
                                  //   thickness: 0.3,
                                  //   height: 0,
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
