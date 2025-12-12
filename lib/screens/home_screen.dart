import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/deadline_provider.dart';
import '../models/deadline.dart';
import 'add_deadline_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Refresh UI every minute to update remaining times
    Future.delayed(const Duration(seconds: 1), _startTimer);
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(minutes: 1));
      if (mounted) {
        setState(() {});
        return true;
      }
      return false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Deadline Tracker' : 'Statistics'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _selectedIndex == 0 ? _buildDeadlinesTab() : const StatisticsScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Deadlines',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddDeadlineScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Deadline'),
            )
          : null,
    );
  }

  Widget _buildDeadlinesTab() {
    return Consumer<DeadlineProvider>(
      builder: (context, provider, child) {
        final deadlines = provider.deadlines;

        if (deadlines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No deadlines yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first deadline',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Due Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Remaining Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: deadlines.map((deadline) {
                  final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
                  final isOverdue = deadline.isOverdue;

                  return DataRow(
                    color: MaterialStateProperty.all(
                      isOverdue ? Colors.red.withOpacity(0.1) : null,
                    ),
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            deadline.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isOverdue ? Colors.red[700] : null,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(
                            deadline.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(dateFormat.format(deadline.dueDate)),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? Colors.red.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            deadline.remainingTimeString,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isOverdue ? Colors.red[700] : Colors.green[700],
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: Text(
                            isOverdue ? 'Overdue' : 'Active',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor:
                              isOverdue ? Colors.red[100] : Colors.blue[100],
                          side: BorderSide.none,
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, deadline, provider);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Deadline deadline,
    DeadlineProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deadline'),
        content: Text('Are you sure you want to delete "${deadline.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removeDeadline(deadline.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deadline deleted')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
