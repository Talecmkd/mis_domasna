import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/pet_service.dart';

class ServiceBookingPage extends StatefulWidget {
  final PetService service;

  ServiceBookingPage({required this.service});

  @override
  _ServiceBookingPageState createState() => _ServiceBookingPageState();
}

class _ServiceBookingPageState extends State<ServiceBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _notesController = TextEditingController();
  final List<String> availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4F964F),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1C170D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTime = null; // Reset time when date changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F2E8),
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F2E8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1C170D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book ${widget.service.name}',
          style: GoogleFonts.plusJakartaSans(
            color: Color(0xFF1C170D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C170D),
                    ),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE8F2E8)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? 'Select a date'
                                : DateFormat('EEEE, MMMM d, y').format(selectedDate!),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: selectedDate == null
                                  ? Color(0xFF6C736B)
                                  : Color(0xFF1C170D),
                            ),
                          ),
                          Icon(Icons.calendar_today,
                              color: Color(0xFF4F964F), size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedDate != null) ...[
              SizedBox(height: 16),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Time',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C170D),
                      ),
                    ),
                    SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: availableTimeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = availableTimeSlots[index];
                        final isSelected = selectedTime?.format(context) == timeSlot;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedTime = TimeOfDay(
                                hour: int.parse(timeSlot.split(':')[0]),
                                minute: 0,
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFF4F964F)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xFF4F964F)
                                    : Color(0xFFE8F2E8),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              timeSlot,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xFF1C170D),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Notes',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C170D),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add any special requirements or notes...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: Color(0xFF6C736B),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFFE8F2E8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFFE8F2E8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF4F964F)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Summary',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C170D),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildSummaryRow('Service', widget.service.name),
                  SizedBox(height: 8),
                  _buildSummaryRow('Duration', widget.service.duration),
                  SizedBox(height: 8),
                  _buildSummaryRow(
                    'Price',
                    '\$${widget.service.price.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: (selectedDate != null && selectedTime != null)
                ? () {
                    // TODO: Implement booking confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Booking'),
                        content: Text(
                          'Would you like to confirm your booking for ${widget.service.name} on '
                          '${DateFormat('EEEE, MMMM d').format(selectedDate!)} at '
                          '${selectedTime!.format(context)}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Save booking to Firebase
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Return to service detail
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Booking confirmed successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1AE51A),
              disabledBackgroundColor: Color(0xFFE8F2E8),
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Confirm Booking',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C170D),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Color(0xFF6C736B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C170D),
          ),
        ),
      ],
    );
  }
} 