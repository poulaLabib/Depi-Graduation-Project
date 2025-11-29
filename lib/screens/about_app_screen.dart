import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'About Fikraty',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withAlpha(200),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(50),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 60,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Fikraty',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(50),
                  ),
                ),
                child: Text(
                  'Connecting Entrepreneurs with Investors',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 48),
            _buildSection(
              theme,
              'Welcome to Fikraty',
              'Fikraty is a revolutionary platform designed to bridge the gap between innovative entrepreneurs and forward-thinking investors. Our mission is to create meaningful connections that drive business growth and innovation.',
              Icons.waving_hand,
            ),
            const SizedBox(height: 32),
            _buildSection(
              theme,
              'Our Mission',
              'We believe that every great idea deserves the opportunity to flourish. Fikraty provides a seamless environment where entrepreneurs can showcase their projects and investors can discover promising opportunities.',
              Icons.rocket_launch,
            ),
            const SizedBox(height: 32),
            _buildSection(
              theme,
              'Key Features',
              '• Easy project submission and management\n• Advanced investor matching system\n• Real-time communication tools\n• Secure transaction handling\n• Comprehensive profile management\n• Notification system for updates',
              Icons.star,
            ),
            const SizedBox(height: 32),
            _buildSection(
              theme,
              'For Entrepreneurs',
              'Create detailed profiles for your companies, submit funding requests, and connect with potential investors who share your vision. Manage your projects efficiently and track your progress all in one place.',
              Icons.business,
            ),
            const SizedBox(height: 32),
            _buildSection(
              theme,
              'For Investors',
              'Discover innovative startups and investment opportunities. Browse through detailed company profiles, review funding requests, and connect with entrepreneurs who are building the future.',
              Icons.trending_up,
            ),
            const SizedBox(height: 32),
            _buildSection(
              theme,
              'Security & Privacy',
              'Your data security is our top priority. We employ industry-standard encryption and security measures to protect your information and ensure safe transactions.',
              Icons.security,
            ),
            const SizedBox(height: 32),
            _buildSection(
              theme,
              'Support',
              'Our dedicated support team is here to help you every step of the way. Whether you have questions about using the platform or need assistance with your account, we\'re just a message away.',
              Icons.support_agent,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withAlpha(20),
                    theme.colorScheme.secondary.withAlpha(20),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(50),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Version',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Build',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                      Text(
                        'Release',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(50),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.copyright,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2024 Fikraty. All rights reserved.',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withAlpha(70),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    String content,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withAlpha(200),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: theme.colorScheme.onSurface.withAlpha(180),
              letterSpacing: 0.1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
