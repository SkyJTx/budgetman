// transaction_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TransactionCard extends StatelessWidget {
  final BudgetList budgetList;

  const TransactionCard({Key? key, required this.budgetList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine accent color based on priority (now using int)
    final Color accentColor = _getAccentColor(budgetList.priority);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle card tap if needed
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Deadline with colored background
              Container(
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        budgetList.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Deadline with icon
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(budgetList.deadline),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: accentColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Amount
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${budgetList.budget.toStringAsFixed(2)} บาท',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description
              if (budgetList.description.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        budgetList.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ไม่มีรายละเอียด',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              // Priority indicator
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Priority: ${_getPriorityText(budgetList.priority)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fade().slideX();
  }

  // Function to determine accent color based on priority (now using int)
  Color _getAccentColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.redAccent; // High priority
      case 2:
        return Colors.orangeAccent; // Medium priority
      case 3:
        return Colors.green; // Low priority
      default:
        return Colors.blueAccent; // Default color
    }
  }

  // Function to get priority text from int value
  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'สูง'; // High
      case 2:
        return 'กลาง'; // Medium
      case 3:
        return 'ต่ำ'; // Low
      default:
        return 'ไม่ระบุ'; // Not specified
    }
  }
}
