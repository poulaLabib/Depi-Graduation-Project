import 'package:depi_graduation_project/custom%20widgets/investor_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestorsSection extends StatelessWidget {
  const InvestorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
        ),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2.8,
              mainAxisSpacing: 3,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            children: const [
              InvestorTile(
                photoPath: 'assets/images/elsweedy.jpeg',
                industries: [
                  'Health Tech',
                  'Ed Tech',
                  'Agri Tech',
                  'AI & Machine Learning',
                  'Cybersecurity',
                  'Real Estate (PropTech)',
                  'E-Commerce',
                  'SaaS (Software as a Service)',
                  'Cloud Computing',
                  'Blockchain / Web3',
                  'Biotech',
                  'Energy & CleanTech',
                  'Food & Beverages',
                  'Gaming & Esports',
                  'Media & Content Creation',
                  'Transportation & Mobility',
                  'Logistics & Supply Chain',
                  'IoT (Internet of Things)',
                ],
                name: 'Ahmad elsweedy',
                bio:
                    'Ahmed Elsewedy was appointed as a member of Elsewedy Electric\'s Board of Directors in 2005, and currently serves as President and Chief Executive Officer of the company',
              ),
              InvestorTile(
                photoPath: 'assets/images/naguib.webp',
                industries: [
                  'Health Tech',
                  'Ed Tech',
                  'Agri Tech',
                  'AI & Machine Learning',
                  'Cybersecurity',
                  'Real Estate (PropTech)',
                  'E-Commerce',
                  'SaaS (Software as a Service)',
                  'Cloud Computing',
                  'Blockchain / Web3',
                  'Biotech',
                  'Energy & CleanTech',
                  'Food & Beverages',
                  'Gaming & Esports',
                  'Media & Content Creation',
                  'Transportation & Mobility',
                  'Logistics & Supply Chain',
                  'IoT (Internet of Things)',
                ],
                name: 'Naguib Sawiris',
                bio:
                    'Naguib Sawiris is a scion of Egypt\'s wealthiest family. His brother Nassef is also a billionaire.',
              ),
              InvestorTile(
                photoPath: 'assets/images/mohamedfarouk.jpeg',
                industries: [
                  'Health Tech',
                  'Ed Tech',
                  'Agri Tech',
                  'AI & Machine Learning',
                  'Cybersecurity',
                  'Real Estate (PropTech)',
                  'E-Commerce',
                  'SaaS (Software as a Service)',
                  'Cloud Computing',
                  'Blockchain / Web3',
                  'Biotech',
                  'Energy & CleanTech',
                  'Food & Beverages',
                  'Gaming & Esports',
                  'Media & Content Creation',
                  'Transportation & Mobility',
                  'Logistics & Supply Chain',
                  'IoT (Internet of Things)',
                ],
                name: 'Mohamed Farouk',
                bio:
                    'Mohamed Farouk conquered the world of furniture manufacturing, in addition to being a prominent angel and venture capital investor.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
