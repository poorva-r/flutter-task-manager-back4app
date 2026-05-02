import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'login_screen.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List to store all tasks fetched from Back4App
  List<ParseObject> _tasks = [];
  bool _isLoading = false;

  // Status colors and icons
  Color _statusColor(String status) {
    switch (status) {
      case 'In Progress':
        return const Color(0xFF5B8CFF);
      case 'Done':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'In Progress':
        return Icons.timelapse_rounded;
      case 'Done':
        return Icons.check_circle_rounded;
      default:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  // Runs once when the screen is first displayed
  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Load tasks as soon as screen opens
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);

    final user = await ParseUser.currentUser() as ParseUser;
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('user_id', user)
      ..orderByDescending('createdAt');

    final response = await query.query();

    setState(() {
      _tasks = response.success && response.results != null
          ? response.results as List<ParseObject>
          : [];
      _isLoading = false;
    });
  }

  Future<void> _deleteTask(String objectId) async {
    final task = ParseObject('Task')..objectId = objectId;
    final response = await task.delete();

    if (response.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task deleted')));
      _fetchTasks(); // Refresh the list after deleting
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete task')));
    }
  }

  // Tap status chip to cycle through statuses
  Future<void> _cycleStatus(ParseObject task) async {
    final current = task.get<String>('status') ?? 'Todo';
    final next = current == 'Todo'
        ? 'In Progress'
        : current == 'In Progress'
        ? 'Done'
        : 'Todo';
    task.set('status', next);
    await task.save();
    _fetchTasks();
  }

  Future<void> _logout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    await user.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _confirmDelete(String objectId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask(objectId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORBIT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          _fetchTasks();
        },
        backgroundColor: const Color(0xFF7C5CBF),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7C5CBF)),
            )
          : _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hub_rounded,
                    size: 80,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tasks in orbit yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to launch your first task',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchTasks,
              color: const Color(0xFF7C5CBF),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _tasks.length,
                itemBuilder: (_, i) {
                  final task = _tasks[i];
                  final status = task.get<String>('status') ?? 'Todo';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13131A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _statusColor(status).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Status chip — tap to cycle
                              GestureDetector(
                                onTap: () => _cycleStatus(task),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(
                                      status,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _statusColor(
                                        status,
                                      ).withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _statusIcon(status),
                                        size: 12,
                                        color: _statusColor(status),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _statusColor(status),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Edit button
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditTaskScreen(task: task),
                                    ),
                                  );
                                  _fetchTasks();
                                },
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF5B8CFF),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Delete button
                              GestureDetector(
                                onTap: () => _confirmDelete(task.objectId!),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            task.get<String>('title') ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.get<String>('description') ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
