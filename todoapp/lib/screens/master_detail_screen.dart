import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/todo_provider.dart';
import '../models/task_model.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/feedback_dialog.dart';
import '../widgets/task_detail_view.dart';
import 'home_screen.dart'; // Import to use _buildXXBackground methods if reusable, or we'll inline minimal versions

class MasterDetailScreen extends StatefulWidget {
  const MasterDetailScreen({super.key});

  @override
  State<MasterDetailScreen> createState() => _MasterDetailScreenState();
}

class _MasterDetailScreenState extends State<MasterDetailScreen> {
  Task? _selectedTask;
  // Use a unique key to force refresh detail view when task changes
  Key _detailKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFeef2f3), Color(0xFFd9e4f5)], 
          ),
        ),
        child: Column(
          children: [
            _buildProfessionalHeader(),
            Expanded(
              child: Row(
                children: [
                  // Master List (Left Pane)
                  Expanded(
                    flex: isWideScreen ? 1 : 1,
                    child: _buildTaskList(isWideScreen),
                  ),
                  // Detail View (Right Pane - only visible on wide screens)
                  if (isWideScreen)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _selectedTask != null
                            ? TaskDetailView(
                                key: _detailKey,
                                task: _selectedTask,
                                onComplete: () => _handleTaskAction('complete', _selectedTask!),
                                onDelete: () => _handleTaskAction('delete', _selectedTask!),
                              )
                            : const TaskDetailView(), // Empty state
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        label: Text('New Task', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.add_task),
        backgroundColor: const Color(0xFF2193b0),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.check_box_outlined, color: Color(0xFF2193b0), size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TaskMaster',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2c3e50),
                ),
              ),
              Text(
                'Professional To-Do',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF7f8c8d),
                ),
              ),
            ],
          ),
        ],
      ).animate().slideY(begin: -0.5, end: 0).fadeIn(),
    );
  }

  Widget _buildTaskList(bool isWideScreen) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final tasks = todoProvider.tasks;
        if (tasks.isEmpty) {
          return Center(
            child: Text(
              'No tasks yet.\nStay productive!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final isSelected = _selectedTask == task;

            return Dismissible(
              key: Key('${task.title}-$index'),
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 30),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 30),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  _handleTaskAction('complete', task);
                  return false; // Don't dismiss from list, just toggle
                } else {
                  return true; // Allow dismiss for delete
                }
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _handleTaskAction('delete', task);
                }
              },
              child: Card(
                elevation: isSelected ? 4 : 1,
                shadowColor: isSelected ? const Color(0xFF2193b0).withOpacity(0.4) : null,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: isSelected ? const BorderSide(color: Color(0xFF2193b0), width: 2) : BorderSide.none,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      task.isCompleted ? Icons.check : Icons.circle_outlined,
                      color: task.isCompleted ? Colors.green : Colors.blue,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    if (isWideScreen) {
                      setState(() {
                        _selectedTask = task;
                        _detailKey = UniqueKey();
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailView(
                            task: task,
                            onClose: () => Navigator.pop(context),
                            onComplete: () {
                               Navigator.pop(context); // Close detail view first
                               _handleTaskAction('complete', task); // Then toggle and show dialog
                            },
                            onDelete: () {
                               Navigator.pop(context); // Close detail view first
                               _handleTaskAction('delete', task); // Then delete and show dialog
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideX(),
            );
          },
        );
      },
    );
  }

  void _handleTaskAction(String action, Task task) {
    if (action == 'complete') {
      final index = Provider.of<TodoProvider>(context, listen: false).tasks.indexOf(task);
      if (index != -1) {
        Provider.of<TodoProvider>(context, listen: false).toggleTask(index);
        final isNowCompleted = Provider.of<TodoProvider>(context, listen: false).tasks[index].isCompleted;
        if(isNowCompleted){
             showDialog(
              context: context,
              builder: (context) => FeedbackDialog(
                title: 'Task Completed!',
                message: 'Great job! You finished "${task.title}".',
                isSuccess: true,
                timestamp: DateTime.now(),
              ),
            );
        }
      }
    } else if (action == 'delete') {
      final index = Provider.of<TodoProvider>(context, listen: false).tasks.indexOf(task);
      if (index != -1) {
        final title = task.title; // Capture before deletion
        Provider.of<TodoProvider>(context, listen: false).deleteTask(index);
        if (_selectedTask == task) {
          setState(() {
            _selectedTask = null;
          });
        }
        showDialog(
          context: context,
          builder: (context) => FeedbackDialog(
            title: 'Task Deleted',
            message: '"$title" has been removed.',
            isSuccess: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
    // Refresh detail view if it's still open and showing this task
    setState(() {
       _detailKey = UniqueKey();
    });
  }
}
