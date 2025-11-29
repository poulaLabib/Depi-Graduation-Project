import 'package:flutter/material.dart';

class CompanyProfileViewScreen extends StatelessWidget {
  final String companyName;
  final String description;
  final String founded;
  final String teamSize;
  final String industry;
  final String stage;
  final String location;
  final String? logoUrl;
  final bool isViewOnly;

  const CompanyProfileViewScreen({
    Key? key,
    required this.companyName,
    required this.description,
    required this.founded,
    required this.teamSize,
    required this.industry,
    required this.stage,
    required this.location,
    this.logoUrl,
    required this.isViewOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    logoUrl != null ? NetworkImage(logoUrl!) : null,
                child:
                    logoUrl == null
                        ? const Icon(
                          Icons.business,
                          size: 60,
                          color: Colors.grey,
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(context, 'Company Information', [
              _buildInfoRow(context, 'Name', companyName),
              _buildInfoRow(context, 'Industry', industry),
              _buildInfoRow(context, 'Founded', founded),
              _buildInfoRow(context, 'Team Size', '$teamSize employees'),
              _buildInfoRow(context, 'Stage', stage),
              _buildInfoRow(context, 'Location', location),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard(context, 'About', [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
