import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
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

  Future<void> _deleteCountdown(CountdownData countdown) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认删除'),
            content: Text('确定要删除"${countdown.title}"吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('删除'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      await _storageService.deleteCountdown(countdown.id);
      await _loadCountdowns();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('倒计时')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('倒计时'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCountdowns,
            tooltip: '刷新',
          ),
        ],
      ),
      body: _countdowns.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '暂无倒计时',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '点击右下角按钮添加第一个倒计时',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _countdowns.length,
              itemBuilder: (context, index) {
                final countdown = _countdowns[index];
                final timeLeft =
                    '${countdown.remainingDays}天 ${countdown.remainingHours}小时 ${countdown.remainingMinutes}分钟';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () => _editCountdown(countdown),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  countdown.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteCountdown(countdown),
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            countdown.description,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                countdown.targetDate.toString(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              Text(
                                timeLeft,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCountdown,
        child: const Icon(Icons.add),
      ),
    );
  }
}
