import 'package:flutter/material.dart';
import 'package:time_widgets/services/weather_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

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
  bool _hasError = false;

  Future<void> _search() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _results = [];
    });

    final results = await _weatherService.searchCity(_controller.text);

    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
        _hasError = results.isEmpty && _controller.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        '搜索城市',
        style: TextStyle(
          fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * fontMultiplier,
        ),
      ),
      content: SizedBox(
        width: ResponsiveUtils.value(300),
        height: ResponsiveUtils.value(400),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(fontSize: 16 * fontMultiplier),
              decoration: InputDecoration(
                labelText: '城市名称 (支持中文/拼音)',
                labelStyle: TextStyle(fontSize: 16 * fontMultiplier),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: ResponsiveUtils.getIconSize(width, baseSize: 24),
                  ),
                  onPressed: _search,
                ),
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.all(ResponsiveUtils.value(16)),
              ),
              onSubmitted: (_) => _search(),
            ),
            SizedBox(height: ResponsiveUtils.value(16)),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off_outlined,
                                size: ResponsiveUtils.getIconSize(width, baseSize: 48),
                                color: theme.colorScheme.error,
                              ),
                              SizedBox(height: ResponsiveUtils.value(16)),
                              Text(
                                '搜索失败',
                                style: TextStyle(
                                  fontSize: 16 * fontMultiplier,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.error,
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.value(8)),
                              Text(
                                '网络连接超时，请重试',
                                style: TextStyle(fontSize: 14 * fontMultiplier),
                              ),
                              SizedBox(height: ResponsiveUtils.value(16)),
                              ElevatedButton(
                                onPressed: _search,
                                child: const Text('重试'),
                              ),
                            ],
                          ),
                        )
                      : _results.isEmpty
                          ? Center(
                              child: Text(
                                _controller.text.isEmpty
                                    ? '请输入城市名称'
                                    : '未找到城市',
                                style: TextStyle(fontSize: 14 * fontMultiplier),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final city = _results[index];
                                final name = city['name'] ?? 'Unknown';
                                final admin1 = city['admin1'] ?? '';
                                final country = city['country'] ?? '';
                                
                                return ListTile(
                                  title: Text(
                                    name,
                                    style: TextStyle(fontSize: 16 * fontMultiplier),
                                  ),
                                  subtitle: Text(
                                    [admin1, country].where((e) => e.toString().isNotEmpty).join(', '),
                                    style: TextStyle(fontSize: 14 * fontMultiplier),
                                  ),
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
          child: Text(
            '取消',
            style: TextStyle(fontSize: 14 * fontMultiplier),
          ),
        ),
      ],
    );
  }
}
