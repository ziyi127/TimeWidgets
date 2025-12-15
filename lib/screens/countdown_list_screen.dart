import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/widgets/countdown_edit_dialog.dart';
import 'package:time_widgets/utils/md3_button_styles.dart';

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
    final result = await showDialog<CountdownData>(
      context: context,
      builder: (context) => const CountdownEditDialog(),
    );

    if (result != null) {
      await _storageService.saveCountdown(result);
      await _loadCountdowns();
    }
  }

  Future<void> _editCountdown(CountdownData countdown) async {
    final result = await showDialog<CountdownData>(
      context: context,
      builder: (context) => CountdownEditDialog(countdown: countdown),
    );

    if (result != null) {
      await _storageService.updateCountdown(result);
      await _loadCountdowns();
    }
  }

  Future<void> _deleteCountdown(CountdownData countdown) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除倒计�?),
        content: Text('确定要删�?${countdown.title}"吗？'),
        actions: [
          MD3ButtonStyles.text(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          MD3ButtonStyles.filled(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.deleteCountdown(countdown.id);
      await _loadCountdowns();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('倒计时管�?),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _countdowns.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_note_outlined,
                        size: 64,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无倒计时事�?,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _addCountdown,
                        icon: const Icon(Icons.add),
                        label: const Text('添加倒计�?),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _countdowns.length,
                  itemBuilder: (context, index) {
                    final countdown = _countdowns[index];
                    return _buildCountdownCard(countdown);
                  },
                ),
      floatingActionButton: _countdowns.isNotEmpty
          ? MD3ButtonStyles.fab(
              onPressed: _addCountdown,
              child: const Icon(Icons.add),
              tooltip: '添加倒计�?,
            )
          : null,
    );
  }

  Widget _buildCountdownCard(CountdownData countdown) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpired = countdown.isExpired;
    final isApproaching = countdown.isApproaching;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isExpired
          ? colorScheme.errorContainer.withValues(alpha: 0.3)
          : isApproaching
              ? colorScheme.tertiaryContainer.withValues(alpha: 0.3)
              : null,
      child: InkWell(
        onTap: () => _editCountdown(countdown),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: countdown.typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${countdown.remainingDays.abs()}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: countdown.typeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isExpired ? '天前' : '�?,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: countdown.typeColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            countdown.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                  color: countdown.typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                          child: Text(
                            countdown.typeLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: countdown.typeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countdown.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${countdown.targetDate.year}�?{countdown.targetDate.month}�?{countdown.targetDate.day}�?,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              MD3ButtonStyles.icon(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteCountdown(countdown),
                tooltip: '删除',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
