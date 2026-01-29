import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/widgets/countdown_edit_dialog.dart';

class CountdownListScreen extends StatefulWidget {
  const CountdownListScreen({super.key});

  @override
  State<CountdownListScreen> createState() => _CountdownListScreenState();
}

class _CountdownListScreenState extends State<CountdownListScreen> {
  final CountdownStorageService _storageService = CountdownStorageService();
  List<CountdownData> _countdowns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountdowns();
  }

  Future<void> _loadCountdowns() async {
    setState(() => _isLoading = true);
    final countdowns = await _storageService.getSortedCountdowns();
    setState(() {
      _countdowns = countdowns;
      _isLoading = false;
    });
  }

  Future<void> _addCountdown() async {
    final newCountdown = await showDialog<CountdownData>(
      context: context,
      builder: (context) => const CountdownEditDialog(),
    );

    if (newCountdown != null) {
      await _storageService.saveCountdown(newCountdown);
      await _loadCountdowns();
    }
  }

  Future<void> _editCountdown(CountdownData countdown) async {
    final updatedCountdown = await showDialog<CountdownData>(
      context: context,
      builder: (context) => CountdownEditDialog(countdown: countdown),
    );

    if (updatedCountdown != null) {
      await _storageService.saveCountdown(updatedCountdown);
      await _loadCountdowns();
    }
  }

  Future<void> _handleDelete(CountdownData countdown, int index) async {
    final l10n = AppLocalizations.of(context)!;
    // Store for undo
    final deletedItem = countdown;
    
    // Remove from storage
    await _storageService.deleteCountdown(countdown.id);

    if (!mounted) return;

    // Show SnackBar with Undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.deleteSuccess),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () async {
            // Restore to storage
            await _storageService.saveCountdown(deletedItem);
            // Restore to UI
            setState(() {
              _countdowns.insert(index, deletedItem);
            });
          },
        ),
      ),
    );
  }

  Color _getEventTypeColor(ColorScheme colorScheme, String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return colorScheme.error;
      case 'assignment':
        return colorScheme.tertiary;
      case 'project':
        return colorScheme.secondary;
      case 'holiday':
        return colorScheme.primary;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return Icons.quiz_rounded;
      case 'assignment':
        return Icons.assignment_rounded;
      case 'project':
        return Icons.work_rounded;
      case 'holiday':
        return Icons.celebration_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.countdownTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.countdownTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCountdowns,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: _countdowns.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_off_outlined,
                    size: 80,
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.countdownEmpty,
                    style: MD3TypographyStyles.headlineSmall(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.addFirstCountdown,
                    style: MD3TypographyStyles.bodyMedium(context).copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _countdowns.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final countdown = _countdowns[index];
                final typeColor = _getEventTypeColor(colorScheme, countdown.type);
                final formattedDate = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(countdown.targetDate);

                return Dismissible(
                  key: Key(countdown.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delete_outline, color: colorScheme.onError),
                  ),
                  confirmDismiss: (direction) async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.confirmDelete),
                        content: Text(l10n.deleteCountdownConfirm(countdown.title)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                            ),
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    );
                    return shouldDelete ?? false;
                  },
                  onDismissed: (direction) {
                    setState(() {
                      _countdowns.removeAt(index);
                    });
                    _handleDelete(countdown, index);
                  },
                  child: MD3CardStyles.surfaceContainer(
                    context: context,
                    padding: const EdgeInsets.all(16),
                    onTap: () => _editCountdown(countdown),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getEventTypeIcon(countdown.type),
                            color: typeColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                countdown.title,
                                style: MD3TypographyStyles.titleMedium(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: MD3TypographyStyles.bodySmall(context).copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (countdown.description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  countdown.description,
                                  style: MD3TypographyStyles.bodyMedium(context).copyWith(
                                    color: colorScheme.outline,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 12),
                              // Chips
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (countdown.category != null && countdown.category!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        countdown.category!,
                                        style: MD3TypographyStyles.labelSmall(context).copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Days Left
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Text(
                              '${countdown.remainingDays}',
                              style: MD3TypographyStyles.displaySmall(context).copyWith(
                                color: typeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.days,
                              style: MD3TypographyStyles.labelMedium(context).copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCountdown,
        icon: const Icon(Icons.add),
        label: Text(l10n.addCountdown),
      ),
    );
  }
}
