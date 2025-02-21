import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Introduction',
            'We value your privacy and are committed to protecting your personal information. '
                'This Privacy Policy explains how we collect, use, and share information about you when you use our app.',
          ),
          _buildSection(
            'Information We Collect',
            '1. Personal Information: Information you provide, such as your email address and account details.\n'
                '2. Usage Data: Information about how you use the app, including interactions and preferences.\n'
                '3. Device Information: Details about your device, such as model and operating system.',
          ),
          _buildSection(
            'How We Use Your Information',
            'We use the information we collect to:\n'
                '- Provide and improve our services.\n'
                '- Communicate with you about updates or issues.\n'
                '- Ensure security and prevent unauthorized access.',
          ),
          _buildSection(
            'Sharing Your Information',
            'We do not share your personal information with third parties, except as required by law or to provide services you request.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email, 'Email', 'support@yourapp.com'),
          _buildContactItem(Icons.web, 'Website', 'www.yourapp.com'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Add action to handle feedback
            },
            child: const Text('Send Feedback'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String detail) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(detail),
      onTap: () {
        // Add action to handle taps (e.g., launch email or website)
      },
    );
  }
}
