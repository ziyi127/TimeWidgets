import 'package:flutter/material.dart';
import 'package:time_widgets/services/weather_service.dart';

class CitySearchDialog extends StatefulWidget {
  const CitySearchDialog({super.key});

  @override
  State<CitySearchDialog> createState() => _CitySearchDialogState();
}

class _CitySearchDialogState extends State<CitySearchDialog> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  Future<void> _search() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final results = await _weatherService.searchCity(_controller.text);

    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('搜索城市'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '城市名称 (支持中文/拼音)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty && _controller.text.isNotEmpty
                      ? const Center(child: Text('未找到城市'))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final city = _results[index];
                            final name = city['name'] ?? 'Unknown';
                            final admin1 = city['admin1'] ?? '';
                            final country = city['country'] ?? '';
                            
                            return ListTile(
                              title: Text(name),
                              subtitle: Text([admin1, country].where((e) => e.toString().isNotEmpty).join(', ')),
                              onTap: () {
                                Navigator.pop(context, city);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ],
    );
  }
}
