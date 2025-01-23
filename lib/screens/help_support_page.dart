import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportPage extends StatelessWidget {
  final List<String> questions = [
    'How do I track my order?',
    'How can I cancel my order?',
    'What payment methods do you accept?',
    'Do you offer free shipping?',
    'Where is my order?',
    'How can I return an item?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8FBF7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0D1C0D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Support',
          style: GoogleFonts.inter(
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F675F),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 17),
            child: Icon(Icons.search, color: Color(0xFF0D1C0D), size: 15),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: questions.length,
              separatorBuilder: (context, index) => Divider(
                color: Color(0xFFD9EDD8),
                height: 3,
              ),
              itemBuilder: (context, index) => _buildQuestionItem(questions[index]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Implement chat functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF18E619),
                foregroundColor: Color(0xFF126411),
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: BorderSide(color: Color(0xFF3FEA3F)),
                ),
              ),
              child: Text(
                'Chat with us',
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(String question) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        question,
        style: GoogleFonts.inter(
          fontSize: 12.8,
          fontWeight: FontWeight.w600,
          color: Color(0xFF838A83),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 13,
        color: Color(0xFF838A83),
      ),
      onTap: () {
        // Handle question tap
      },
    );
  }
}
