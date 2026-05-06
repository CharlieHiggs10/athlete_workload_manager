import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/activity_provider.dart';

/// Logic Summary:
/// A status card that monitors the 7-day workload.
/// Displays a red "Burnout Alert" if the workload exceeds 25,
/// otherwise displays an unobtrusive "Status: Optimal" indicator.
class BurnoutAlertCard extends ConsumerWidget {
  const BurnoutAlertCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workload = ref.watch(workloadProvider);

    if (workload > 25) {
      return Card(
        color: Colors.red.shade50,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Burnout Alert',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'High workload detected. Consider scheduling recovery activities like Naps or Ice Baths.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red.shade800,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 16),
              const SizedBox(width: 6),
              Text(
                'Status: Optimal',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
