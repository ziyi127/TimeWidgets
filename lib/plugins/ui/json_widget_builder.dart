import 'package:flutter/material.dart';

class JsonWidgetBuilder {
  static Widget build(Map<String, dynamic> json, BuildContext context) {
    final type = json['type'];
    
    switch (type) {
      case 'Container':
        return _buildContainer(json, context);
      case 'Column':
        return _buildColumn(json, context);
      case 'Row':
        return _buildRow(json, context);
      case 'Text':
        return _buildText(json, context);
      case 'Icon':
        return _buildIcon(json, context);
      case 'SizedBox':
        return _buildSizedBox(json, context);
      case 'Center':
        return _buildCenter(json, context);
      case 'GestureDetector':
        return _buildGestureDetector(json, context);
      case 'Image':
        return _buildImage(json, context);
      case 'Padding':
        return _buildPadding(json, context);
      case 'Align':
        return _buildAlign(json, context);
      default:
        return SizedBox.shrink();
    }
  }

  static Widget _buildContainer(Map<String, dynamic> json, BuildContext context) {
    final width = _parseDouble(json['width']);
    final height = _parseDouble(json['height']);
    final padding = _parseEdgeInsets(json['padding']);
    final color = _parseColor(json['color']);
    final childJson = json['child'] as Map<String, dynamic>?;
    
    Widget? child;
    if (childJson != null) {
      child = build(childJson, context);
    }
    
    return Container(
      width: width,
      height: height,
      padding: padding,
      color: color,
      decoration: _parseDecoration(json['decoration'] as Map<String, dynamic>?),
      child: child,
    );
  }

  static Widget _buildColumn(Map<String, dynamic> json, BuildContext context) {
    final mainAxisAlignment = _parseMainAxisAlignment(json['mainAxisAlignment'] as String?);
    final childrenJson = json['children'] as List<dynamic>?;
    
    List<Widget> children = [];
    if (childrenJson != null) {
      children = childrenJson.map((c) => build(c as Map<String, dynamic>, context)).toList();
    }
    
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }

  static Widget _buildRow(Map<String, dynamic> json, BuildContext context) {
    final mainAxisAlignment = _parseMainAxisAlignment(json['mainAxisAlignment'] as String?);
    final childrenJson = json['children'] as List<dynamic>?;
    
    List<Widget> children = [];
    if (childrenJson != null) {
      children = childrenJson.map((c) => build(c as Map<String, dynamic>, context)).toList();
    }
    
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }

  static Widget _buildText(Map<String, dynamic> json, BuildContext context) {
    final text = json['text'] as String? ?? '';
    final styleJson = json['style'] as Map<String, dynamic>?;
    
    TextStyle style = TextStyle();
    if (styleJson != null) {
      style = TextStyle(
        fontSize: _parseDouble(styleJson['fontSize']),
        color: _parseColor(styleJson['color']),
        fontWeight: _parseFontWeight(styleJson['fontWeight'] as String?),
      );
    }
    
    return Text(text, style: style);
  }

  static Widget _buildIcon(Map<String, dynamic> json, BuildContext context) {
    final iconName = json['icon'] as String?;
    final size = _parseDouble(json['size']);
    final color = _parseColor(json['color']);
    
    return Icon(
      _parseIconData(iconName),
      size: size,
      color: color,
    );
  }

  static Widget _buildSizedBox(Map<String, dynamic> json, BuildContext context) {
    final width = _parseDouble(json['width']);
    final height = _parseDouble(json['height']);
    
    return SizedBox(width: width, height: height);
  }

  static Widget _buildCenter(Map<String, dynamic> json, BuildContext context) {
    final childJson = json['child'] as Map<String, dynamic>?;
    
    Widget? child;
    if (childJson != null) {
      child = build(childJson, context);
    }
    
    return Center(child: child);
  }

  static Widget _buildGestureDetector(Map<String, dynamic> json, BuildContext context) {
    final childJson = json['child'] as Map<String, dynamic>?;
    final onTap = json['onTap'] as String?;
    
    Widget? child;
    if (childJson != null) {
      child = build(childJson, context);
    }
    
    return GestureDetector(
      child: child,
      onTap: () {
        // 处理点击事件，这里可以根据onTap属性执行不同的操作
        print('GestureDetector tapped: $onTap');
      },
    );
  }

  static Widget _buildImage(Map<String, dynamic> json, BuildContext context) {
    final src = json['src'] as String?;
    final width = _parseDouble(json['width']);
    final height = _parseDouble(json['height']);
    
    if (src == null) return const SizedBox.shrink();
    
    // 这里可以支持不同的图片来源，如网络图片、资产图片等
    return Image.network(
      src,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image_not_supported);
      },
    );
  }

  static Widget _buildPadding(Map<String, dynamic> json, BuildContext context) {
    final padding = _parseEdgeInsets(json['padding']);
    final childJson = json['child'] as Map<String, dynamic>?;
    
    Widget? child;
    if (childJson != null) {
      child = build(childJson, context);
    }
    
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }

  static Widget _buildAlign(Map<String, dynamic> json, BuildContext context) {
    final alignment = _parseAlignment(json['alignment'] as String?);
    final childJson = json['child'] as Map<String, dynamic>?;
    
    Widget? child;
    if (childJson != null) {
      child = build(childJson, context);
    }
    
    return Align(
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }

  static EdgeInsets? _parseEdgeInsets(dynamic value) {
    if (value == null) return null;
    if (value is num) return EdgeInsets.all(value.toDouble());
    if (value is List && value.length == 4) {
      return EdgeInsets.fromLTRB(
        (value[0] as num).toDouble(),
        (value[1] as num).toDouble(),
        (value[2] as num).toDouble(),
        (value[3] as num).toDouble(),
      );
    }
    return null;
  }

  static Color? _parseColor(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      // Hex string #RRGGBB or #AARRGGBB
      value = value.replaceAll('#', '');
      if (value.length == 6) {
        value = 'FF$value';
      }
      return Color(int.parse(value, radix: 16));
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    return (value as num).toDouble();
  }

  static MainAxisAlignment _parseMainAxisAlignment(String? value) {
    switch (value) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spaceBetween': return MainAxisAlignment.spaceBetween;
      case 'spaceAround': return MainAxisAlignment.spaceAround;
      case 'spaceEvenly': return MainAxisAlignment.spaceEvenly;
      default: return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
    switch (value) {
      case 'start': return CrossAxisAlignment.start;
      case 'end': return CrossAxisAlignment.end;
      case 'center': return CrossAxisAlignment.center;
      case 'stretch': return CrossAxisAlignment.stretch;
      default: return CrossAxisAlignment.center;
    }
  }

  static FontWeight? _parseFontWeight(String? value) {
    switch (value) {
      case 'bold': return FontWeight.bold;
      case 'w500': return FontWeight.w500;
      default: return FontWeight.normal;
    }
  }

  static Alignment? _parseAlignment(String? value) {
    switch (value) {
      case 'topLeft': return Alignment.topLeft;
      case 'topCenter': return Alignment.topCenter;
      case 'topRight': return Alignment.topRight;
      case 'centerLeft': return Alignment.centerLeft;
      case 'center': return Alignment.center;
      case 'centerRight': return Alignment.centerRight;
      case 'bottomLeft': return Alignment.bottomLeft;
      case 'bottomCenter': return Alignment.bottomCenter;
      case 'bottomRight': return Alignment.bottomRight;
      default: return null;
    }
  }

  static IconData? _parseIconData(String? value) {
    switch (value) {
      case 'home': return Icons.home;
      case 'settings': return Icons.settings;
      case 'person': return Icons.person;
      case 'access_time': return Icons.access_time;
      case 'calendar_today': return Icons.calendar_today;
      case 'skip_previous': return Icons.skip_previous;
      case 'play_arrow': return Icons.play_arrow;
      case 'skip_next': return Icons.skip_next;
      case 'extension': return Icons.extension;
      case 'help': return Icons.help;
      case 'add': return Icons.add;
      case 'remove': return Icons.remove;
      case 'edit': return Icons.edit;
      case 'delete': return Icons.delete;
      case 'save': return Icons.save;
      case 'cancel': return Icons.cancel;
      case 'refresh': return Icons.refresh;
      case 'search': return Icons.search;
      case 'menu': return Icons.menu;
      case 'close': return Icons.close;
      case 'arrow_back': return Icons.arrow_back;
      case 'arrow_forward': return Icons.arrow_forward;
      case 'check': return Icons.check;
      case 'warning': return Icons.warning;
      case 'info': return Icons.info;
      case 'error': return Icons.error;
      case 'success': return Icons.check_circle;
      default: return Icons.help;
    }
  }

  static BoxDecoration? _parseDecoration(Map<String, dynamic>? decoration) {
    if (decoration == null) return null;
    
    return BoxDecoration(
      color: _parseColor(decoration['color']),
      borderRadius: _parseBorderRadius(decoration['borderRadius']),
      boxShadow: _parseBoxShadow(decoration['boxShadow'] as List<dynamic>?)
    );
  }

  static BorderRadius? _parseBorderRadius(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      return BorderRadius.circular(value.toDouble());
    }
    return null;
  }

  static List<BoxShadow>? _parseBoxShadow(List<dynamic>? shadows) {
    if (shadows == null) return null;
    
    return shadows.map((shadow) {
      final shadowMap = shadow as Map<String, dynamic>;
      return BoxShadow(
        color: _parseColor(shadowMap['color']) ?? Colors.black,
        offset: Offset(
          _parseDouble(shadowMap['offset']['x']) ?? 0,
          _parseDouble(shadowMap['offset']['y']) ?? 0
        ),
        blurRadius: _parseDouble(shadowMap['blurRadius']) ?? 0
      );
    }).toList();
  }
}
