// lib/screens/help_support_page.dart
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HelpSupportPage extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': 'How do I place an order?',
      'answer': 'To place an order, browse our products, add items to your cart, and proceed to checkout. Follow the prompts to complete your purchase.'
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept credit/debit cards, PayPal, and other major payment methods. You can view all available options at checkout.'
    },
    {
      'question': 'How can I track my order?',
      'answer': 'Once your order is shipped, you will receive a tracking number via email. You can use this number to track your package on our website or the carrier\'s site.'
    },
    {
      'question': 'What is your return policy?',
      'answer': 'We offer a 30-day return policy for most items. Please refer to our Returns & Refunds page for more detailed information.'
    },
    {
      'question': 'How can I contact customer service?',
      'answer': 'You can reach our customer service team via email at support@petshop.com or by phone at 1-800-PET-SHOP during our business hours.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...faqList.map((faq) => _buildFAQItem(context, faq)).toList(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('Contact Support'),
              onPressed: () {
                // TODO: Implement contact support functionality
                print('Contact support button pressed');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq['question']!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(faq['answer']!),
        ),
      ],
    );
  }
}
