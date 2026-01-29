import 'package:flutter/material.dart';

class JsonWidgetBuilder {
  static Widget build(Map<String, dynamic> json, BuildContext context) {
    final type = json['type'];
    final params = json['params'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final childrenJson = json['children'] as List<dynamic>?;

    List<Widget> children = [];
    if (childrenJson != null) {
      children = childrenJson.map((c) => build(c as Map<String, dynamic>, context)).toList();
    }

    switch (type) {
      case 'Container':
        return Container(
          padding: _parseEdgeInsets(params['padding']),
          margin: _parseEdgeInsets(params['margin']),
          color: _parseColor(params['color']),
          width: _parseDouble(params['width']),
          height: _parseDouble(params['height']),
          child: children.isNotEmpty ? children.first : null,
        );
      case 'Column':
        return Column(
          mainAxisAlignment: _parseMainAxisAlignment(params['mainAxisAlignment'] as String?),
          crossAxisAlignment: _parseCrossAxisAlignment(params['crossAxisAlignment'] as String?),
          children: children,
        );
      case 'Row':
        return Row(
          mainAxisAlignment: _parseMainAxisAlignment(params['mainAxisAlignment'] as String?),
          crossAxisAlignment: _parseCrossAxisAlignment(params['crossAxisAlignment'] as String?),
          children: children,
        );
      case 'Text':
        return Text(
          (params['text'] as String?) ?? '',
          style: TextStyle(
            fontSize: _parseDouble(params['fontSize']),
            color: _parseColor(params['color']),
            fontWeight: _parseFontWeight(params['fontWeight'] as String?),
          ),
        );
      case 'Icon':
        return Icon(
          _parseIconData(params['icon'] as String?),
          size: _parseDouble(params['size']),
          color: _parseColor(params['color']),
        );
      case 'SizedBox':
        return SizedBox(
          width: _parseDouble(params['width']),
          height: _parseDouble(params['height']),
        );
      case 'Center':
        return Center(
          child: children.isNotEmpty ? children.first : null,
        );
      default:
        return SizedBox.shrink();
    }
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

  static IconData? _parseIconData(String? value) {
    // Basic mapping, in a real app use a full map or MaterialIcons lookup
    switch (value) {
      case 'home': return Icons.home;
      case 'settings': return Icons.settings;
      case 'person': return Icons.person;
      case 'access_time': return Icons.access_time;
      case 'calendar_today': return Icons.calendar_today;
      default: return Icons.help;
    }
  }
}
