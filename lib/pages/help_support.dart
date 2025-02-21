import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 39, 72, 149),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFaqItem('How do I make a payment?',
              'You can use either Pay with Stripe or pay in installments to make a payment.'),
          _buildFaqItem('What is the customer guarantee?',
              'We offer a 30-day money-back guarantee if you are not satisfied with our service.'),
          _buildFaqItem('What should I do if I encounter a problem?',
              'Check our support page for troubleshooting tips or contact our support team at support@chronotime.com.'),
          // Add more FAQ items as needed
          _buildFaqItem('How do I change my details?',
              'To reset your password, go to the profile page and click on edit or pencil icon. Fill in the required fields and click on save.'),
          const SizedBox(height: 24),
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email, 'Email', 'support@chronotime.com'),
          _buildContactItem(Icons.web, 'Website', 'www.chronotime.com'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Add feedback form or email launcher
            },
            child: const Text('Send Feedback'),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
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
