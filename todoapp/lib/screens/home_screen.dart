import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/todo_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/feedback_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6dd5ed),
              Color(0xFF2193b0),
            ],
          ),
        ),
        child: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            final tasks = todoProvider.tasks;
            if (tasks.isEmpty) {
              return Center(
                child: Text(
                  'No tasks yet!\nAdd one to get started.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 80),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key('${task.title}-$index'),
                  background: _buildCompleteBackground(),
                  secondaryBackground: _buildDeleteBackground(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                       todoProvider.toggleTask(index);
                       if (todoProvider.tasks[index].isCompleted) {
                         showDialog(
                           context: context,
                           builder: (context) => FeedbackDialog(
                             title: 'Task Completed!',
                             message: 'Great job! You finished "${task.title}".',
                             isSuccess: true,
                             timestamp: todoProvider.tasks[index].completedAt,
                           ),
                         );
                       }
                       return false; 
                    } else {
                       return true;
                    }
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      final deletedTaskTitle = task.title;
                      todoProvider.deleteTask(index);
                  
                      showDialog(
                        context: context,
                        builder: (context) => FeedbackDialog(
                          title: 'Task Deleted',
                          message: '"$deletedTaskTitle" has been removed.',
                          isSuccess: false,
                          timestamp: DateTime.now(),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      onTap: () {
                         todoProvider.toggleTask(index);
                         if (todoProvider.tasks[index].isCompleted) {
                           showDialog(
                             context: context,
                             builder: (context) => FeedbackDialog(
                               title: 'Task Completed!',
                               message: 'Great job! You finished "${task.title}".',
                               isSuccess: true,
                               timestamp: todoProvider.tasks[index].completedAt,
                               ),
                           );
                         }
                      },
                      title: Text(
                        task.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : Colors.black87,
                        ),
                      ),
                      subtitle: task.createdAt != null
                          ? Text(
                              'Created: ${task.createdAt.month}/${task.createdAt.day} ${task.createdAt.hour}:${task.createdAt.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            )
                          : null,
                      leading: Tooltip(
                        message: task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                        child: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                             todoProvider.toggleTask(index);
                             if (todoProvider.tasks[index].isCompleted) {
                               showDialog(
                                 context: context,
                                 builder: (context) => FeedbackDialog(
                                   title: 'Task Completed!',
                                   message: 'Great job! You finished "${task.title}".',
                                   isSuccess: true,
                                   timestamp: todoProvider.tasks[index].completedAt,
                                 ),
                               );
                             }
                          },
                          activeColor: const Color(0xFF2193b0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          final deletedTaskTitle = task.title;
                          todoProvider.deleteTask(index);
                          
                          showDialog(
                            context: context,
                            builder: (context) => FeedbackDialog(
                              title: 'Task Deleted',
                              message: '"$deletedTaskTitle" has been removed.',
                              isSuccess: false,
                              timestamp: DateTime.now(),
                            ),
                          );
                        },
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 100).ms).slideX(),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        label: Text('Add Task', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2193b0),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildCheckBackground() {
     return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 30),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  Widget _buildCompleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.check_circle, color: Colors.white, size: 30),
    );
  }
}
