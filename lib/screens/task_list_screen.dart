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
      ..orderByAscending('isCompleted') // incomplete tasks first
      ..orderByDescending('createdAt');
    final response = await query.query();
    setState(() {
      _tasks = response.success && response.results != null
          ? response.results as List<ParseObject>
          : [];
      _isLoading = false;
    });
  }

  Future<void> _toggleComplete(ParseObject task) async {
    final current = task.get<bool>('isCompleted') ?? false;
    task.set('isCompleted', !current);
    await task.save();
    _fetchTasks();
  }

  Future<void> _deleteTask(String objectId) async {
    final task = ParseObject('Task')..objectId = objectId;
    final response = await task.delete();
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task removed from orbit')),
      );
      _fetchTasks();
    }
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
        backgroundColor: const Color(0xFF13131A),
        title: const Text('Delete Task'),
        content: const Text('Remove this task from orbit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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

  // Count completed tasks for progress bar
  int get _completedCount =>
      _tasks.where((t) => t.get<bool>('isCompleted') == true).length;

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
              child: CircularProgressIndicator(color: Color(0xFF7C5CBF)))
          : _tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hub_rounded,
                          size: 80, color: Colors.grey.shade800),
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
              : Column(
                  children: [
                    // Progress bar at top
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$_completedCount of ${_tasks.length} completed',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _tasks.isEmpty
                                    ? '0%'
                                    : '${((_completedCount / _tasks.length) * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Color(0xFF7C5CBF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _tasks.isEmpty
                                  ? 0
                                  : _completedCount / _tasks.length,
                              backgroundColor: const Color(0xFF1E1E2A),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF7C5CBF),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Task list
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _fetchTasks,
                        color: const Color(0xFF7C5CBF),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _tasks.length,
                          itemBuilder: (_, i) {
                            final task = _tasks[i];
                            final isCompleted =
                                task.get<bool>('isCompleted') ?? false;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF13131A),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCompleted
                                      ? const Color(0xFF4CAF50).withOpacity(0.3)
                                      : const Color(0xFF7C5CBF).withOpacity(0.15),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                // Checkbox on left
                                leading: GestureDetector(
                                  onTap: () => _toggleComplete(task),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted
                                          ? const Color(0xFF4CAF50)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isCompleted
                                            ? const Color(0xFF4CAF50)
                                            : Colors.grey.shade600,
                                        width: 2,
                                      ),
                                    ),
                                    child: isCompleted
                                        ? const Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                // Title and description
                                title: Text(
                                  task.get<String>('title') ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? Colors.grey.shade600
                                        : Colors.white,
                                    // Strikethrough when completed
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: Colors.grey.shade600,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    task.get<String>('description') ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isCompleted
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade500,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      decorationColor: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                // Edit and delete on right
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isCompleted)
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
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () =>
                                          _confirmDelete(task.objectId!),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}