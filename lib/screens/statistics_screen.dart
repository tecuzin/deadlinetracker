import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/deadline_provider.dart';
import '../models/deadline.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<DeadlineProvider>(
        builder: (context, provider, child) {
          final deadlines = provider.deadlines;

          if (deadlines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No statistics yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some deadlines to see statistics',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          final stats = _calculateStatistics(deadlines);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Overview Cards
                _buildOverviewSection(context, stats),
                const SizedBox(height: 20),

                // Status Distribution
                _buildStatusDistribution(context, stats),
                const SizedBox(height: 20),

                // Time Analysis
                _buildTimeAnalysis(context, stats),
                const SizedBox(height: 20),

                // Upcoming Deadlines
                _buildUpcomingDeadlines(
                  context,
                  stats['upcomingDeadlines'] as List<Deadline>,
                ),
                const SizedBox(height: 20),

                // Recent Activity
                _buildRecentActivity(
                  context,
                  stats['recentDeadlines'] as List<Deadline>,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _calculateStatistics(List<Deadline> deadlines) {
    final now = DateTime.now();
    final activeDeadlines = deadlines.where((d) => !d.isOverdue).toList();
    final overdueDeadlines = deadlines.where((d) => d.isOverdue).toList();

    // Upcoming deadlines (within next 7 days)
    final upcomingDeadlines = activeDeadlines
        .where((d) => d.dueDate.difference(now).inDays <= 7)
        .toList();

    // Critical deadlines (within next 24 hours)
    final criticalDeadlines = activeDeadlines
        .where((d) => d.dueDate.difference(now).inHours <= 24)
        .toList();

    // Recent deadlines (created in last 7 days)
    final recentDeadlines = deadlines
        .where((d) => now.difference(d.createdAt).inDays <= 7)
        .toList();

    // Average time remaining for active deadlines
    double avgTimeRemaining = 0;
    if (activeDeadlines.isNotEmpty) {
      final totalHours = activeDeadlines
          .map((d) => d.remainingTime.inHours)
          .reduce((a, b) => a + b);
      avgTimeRemaining = totalHours / activeDeadlines.length;
    }

    return {
      'total': deadlines.length,
      'active': activeDeadlines.length,
      'overdue': overdueDeadlines.length,
      'upcoming': upcomingDeadlines.length,
      'critical': criticalDeadlines.length,
      'avgTimeRemaining': avgTimeRemaining,
      'upcomingDeadlines': upcomingDeadlines,
      'recentDeadlines': recentDeadlines,
      'activeDeadlines': activeDeadlines,
      'overdueDeadlines': overdueDeadlines,
    };
  }

  Widget _buildOverviewSection(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Total',
                stats['total'].toString(),
                Icons.list_alt,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Active',
                stats['active'].toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Overdue',
                stats['overdue'].toString(),
                Icons.warning,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Critical',
                stats['critical'].toString(),
                Icons.priority_high,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDistribution(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    final total = stats['total'] as int;
    final active = stats['active'] as int;
    final overdue = stats['overdue'] as int;

    final activePercentage = total > 0 ? (active / total * 100).round() : 0;
    final overduePercentage = total > 0 ? (overdue / total * 100).round() : 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              context,
              'Active',
              activePercentage,
              Colors.green,
              '$active deadlines',
            ),
            const SizedBox(height: 12),
            _buildProgressBar(
              context,
              'Overdue',
              overduePercentage,
              Colors.red,
              '$overdue deadlines',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    int percentage,
    Color color,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildTimeAnalysis(BuildContext context, Map<String, dynamic> stats) {
    final avgHours = (stats['avgTimeRemaining'] as double).round();
    final days = (avgHours / 24).floor();
    final hours = avgHours % 24;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Analysis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    context,
                    'Avg. Time Left',
                    days > 0 ? '${days}d ${hours}h' : '${hours}h',
                    Icons.schedule,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeCard(
                    context,
                    'Upcoming (7d)',
                    stats['upcoming'].toString(),
                    Icons.event,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlines(
    BuildContext context,
    List<Deadline> deadlines,
  ) {
    if (deadlines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upcoming,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Upcoming (Next 7 Days)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...deadlines.take(5).map((deadline) {
              final dateFormat = DateFormat('MMM dd, HH:mm');
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deadline.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(deadline.dueDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          deadline.remainingTimeString,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, List<Deadline> deadlines) {
    if (deadlines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity (Last 7 Days)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${deadlines.length} ${deadlines.length == 1 ? 'deadline' : 'deadlines'} created',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ...deadlines.take(3).map((deadline) {
              final now = DateTime.now();
              final daysAgo = now.difference(deadline.createdAt).inDays;

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        deadline.title,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      daysAgo == 0 ? 'Today' : '$daysAgo days ago',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
