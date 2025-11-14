import 'package:depi_graduation_project/bloc/Investor section/investor_section_bloc.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_event.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_state.dart';
import 'package:depi_graduation_project/custom%20widgets/investor_tile.dart';
import 'package:depi_graduation_project/data/industries.dart';
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
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Investors'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Industries:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: industries.map((industry) {
                        final isSelected = selectedIndustries.contains(industry);
                        return FilterChip(
                          label: Text(industry),
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
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Investment Capacity:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minCapacityController,
                            decoration: const InputDecoration(
                              labelText: 'Min',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: maxCapacityController,
                            decoration: const InputDecoration(
                              labelText: 'Max',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<InvestorSectionBloc>().add(ClearFilters());
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<InvestorSectionBloc>().add(
                          FilterInvestors(
                            selectedIndustries: selectedIndustries.isEmpty
                                ? null
                                : selectedIndustries,
                            minInvestmentCapacity: minCapacityController
                                        .text.isNotEmpty
                                ? int.tryParse(minCapacityController.text)
                                : null,
                            maxInvestmentCapacity: maxCapacityController
                                        .text.isNotEmpty
                                ? int.tryParse(maxCapacityController.text)
                                : null,
                          ),
                        );
                    Navigator.pop(context);
                  },
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
                child: state.filteredInvestors.isEmpty
                    ? const Center(
                        child: Text('No investors found'),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 2.8,
                          mainAxisSpacing: 3,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        itemCount: state.filteredInvestors.length,
                        itemBuilder: (context, index) {
                          final investor = state.filteredInvestors[index];
                          return InvestorTile(
                            photoUrl: investor.photoUrl.isNotEmpty
                                ? investor.photoUrl
                                : null,
                            name: investor.name,
                            bio: investor.about.isNotEmpty
                                ? investor.about
                                : 'No bio available',
                            industries: investor.preferredIndustries,
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