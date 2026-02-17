import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task_model.dart';

class TaskDetailView extends StatelessWidget {
  final Task? task;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final VoidCallback? onClose;

  const TaskDetailView({
    super.key,
    this.task,
    this.onComplete,
    this.onDelete,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'Select a task to view details',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[400],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Task Details', style: GoogleFonts.poppins(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: onClose != null
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClose)
            : null,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'complete' && onComplete != null) {
                onComplete!();
              } else if (value == 'delete' && onDelete != null) {
                onDelete!();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(
                      task!.isCompleted ? Icons.undo : Icons.check_circle_outline,
                      color: task!.isCompleted ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(task!.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    const SizedBox(width: 10),
                    Text('Delete Task'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: task!.isCompleted ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: task!.isCompleted ? Colors.green.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      task!.isCompleted ? Icons.check_circle : Icons.pending_outlined,
                      size: 16,
                      color: task!.isCompleted ? Colors.green : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task!.isCompleted ? 'Completed' : 'Pending',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: task!.isCompleted ? Colors.green[700] : Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ).animate().scale(alignment: Alignment.centerLeft),
              const SizedBox(height: 20),
              Text(
                task!.title,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 30),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 20),
              _buildTimeRow(Icons.calendar_today, 'Created', task!.createdAt),
              if (task!.completedAt != null) ...[
                const SizedBox(height: 16),
                _buildTimeRow(Icons.check_circle_outline, 'Completed', task!.completedAt!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(IconData icon, String label, DateTime time) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
            ),
            Text(
              DateFormat('MMMM d, yyyy • h:mm a').format(time),
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}
