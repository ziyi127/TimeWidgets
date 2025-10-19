import 'package:flutter/services.dart';

class SystemTrayService {
  static const MethodChannel _channel = MethodChannel('system_tray_channel');
  static final SystemTrayService _instance = SystemTrayService._internal();
  
  factory SystemTrayService() => _instance;
  SystemTrayService._internal();
  
  Function? _onNavigateToTimetableEdit;
  
  void initialize(Function onNavigateToTimetableEdit) {
    _onNavigateToTimetableEdit = onNavigateToTimetableEdit;
    
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'navigate_to_timetable_edit':
        if (_onNavigateToTimetableEdit != null) {
          _onNavigateToTimetableEdit!();
        }
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }
}