import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class FeedbackDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final DateTime? timestamp;

  const FeedbackDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isSuccess,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSuccess ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                color: isSuccess ? Colors.green : Colors.red,
                size: 60,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.green[800] : Colors.red[800],
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 10),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            if (timestamp != null) ...[
              const SizedBox(height: 15),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 10),
              Text(
                'Action Time: ${DateFormat('h:mm a, MMM d').format(timestamp!)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ).animate().fadeIn(delay: 500.ms).scale(),
          ],
        ),
      ),
    );
  }
}
