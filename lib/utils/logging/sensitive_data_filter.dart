/// 敏感数据过滤器
class SensitiveDataFilter {
  /// 敏感字段名称列表
  static const List<String> _sensitiveFields = [
    'password',
    'token',
    'authorization',
    'auth',
    'secret',
    'api_key',
    'apiKey',
    'access_token',
    'accessToken',
    'refresh_token',
    'refreshToken',
    'private_key',
    'privateKey',
    'credit_card',
    'creditCard',
    'ssn',
    'phone',
    'email',
  ];

  /// 敏感URL模式
  static final List<RegExp> _sensitiveUrlPatterns = [
    RegExp(r'token=[^&\s]+', caseSensitive: false),
    RegExp(r'api_key=[^&\s]+', caseSensitive: false),
    RegExp(r'password=[^&\s]+', caseSensitive: false),
  ];

  /// 过滤敏感数据
  static Map<String, dynamic> filterMap(Map<String, dynamic> data) {
    final filtered = <String, dynamic>{};

    data.forEach((key, value) {
      if (_isSensitiveField(key)) {
        filtered[key] = _maskValue(value);
      } else if (value is Map<String, dynamic>) {
        filtered[key] = filterMap(value);
      } else if (value is List) {
        filtered[key] = _filterList(value);
      } else {
        filtered[key] = value;
      }
    });

    return filtered;
  }

  /// 过滤列表中的敏感数据
  static List<dynamic> _filterList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return filterMap(item);
      } else if (item is List) {
        return _filterList(item);
      }
      return item;
    }).toList();
  }

  /// 过滤URL中的敏感信息
  static String filterUrl(String url) {
    var filtered = url;
    for (final pattern in _sensitiveUrlPatterns) {
      filtered = filtered.replaceAllMapped(pattern, (match) {
        final matched = match.group(0)!;
        final parts = matched.split('=');
        return '${parts[0]}=***';
      });
    }
    return filtered;
  }

  /// 过滤文件路径中的用户名
  static String filterFilePath(String path) {
    // 将绝对路径转换为相对路径或移除用户名
    final patterns = [
      RegExp(r'C:\\Users\\[^\\]+\\', caseSensitive: false),
      RegExp('/Users/[^/]+/', caseSensitive: false),
      RegExp('/home/[^/]+/', caseSensitive: false),
    ];

    var filtered = path;
    for (final pattern in patterns) {
      filtered = filtered.replaceAll(pattern, '<USER_HOME>/');
    }

    return filtered;
  }

  /// 过滤字符串中的敏感信息
  static String filterString(String text) {
    var filtered = text;

    // 过滤邮箱
    filtered = filtered.replaceAll(
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
      '***@***.***',
    );

    // 过滤电话号码
    filtered = filtered.replaceAll(
      RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b'),
      '***-***-****',
    );

    // 过滤信用卡号
    filtered = filtered.replaceAll(
      RegExp(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'),
      '****-****-****-****',
    );

    return filtered;
  }

  /// 判断是否为敏感字段
  static bool _isSensitiveField(String fieldName) {
    final lowerField = fieldName.toLowerCase();
    return _sensitiveFields.any(
      (sensitive) => lowerField.contains(sensitive.toLowerCase()),
    );
  }

  /// 掩码值
  static String _maskValue(dynamic value) {
    if (value == null) return 'null';
    final str = value.toString();
    if (str.length <= 4) return '***';
    return '${str.substring(0, 2)}***${str.substring(str.length - 2)}';
  }
}
