import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/utils/error_handler.dart';

void main() {
  group('ErrorHandler Tests', () {
    // **Feature: project-enhancement, Property 8: Cache Fallback on Error**
    // **Validates: Requirements 5.2**
    // Note: This tests the error handling logic that enables cache fallback
    
    group('Network Error Handling', () {
      test('handles timeout error correctly', () {
        final error = Exception('Connection timeout');
        final appError = ErrorHandler.handleNetworkError(error);

        expect(appError.code, equals('TIMEOUT'));
        expect(appError.userMessage, contains('超时'));
        expect(appError.resolution, isNotEmpty);
      });

      test('handles 404 error correctly', () {
        final error = Exception('HTTP 404 Not Found');
        final appError = ErrorHandler.handleNetworkError(error);

        expect(appError.code, equals('NOT_FOUND'));
        expect(appError.userMessage, contains('不存在'));
      });

      test('handles 500 error correctly', () {
        final error = Exception('HTTP 500 Internal Server Error');
        final appError = ErrorHandler.handleNetworkError(error);

        expect(appError.code, equals('SERVER_ERROR'));
        expect(appError.userMessage, contains('服务器'));
      });

      test('handles generic network error', () {
        final error = Exception('Some network error');
        final appError = ErrorHandler.handleNetworkError(error);

        expect(appError.code, equals('NETWORK_ERROR'));
        expect(appError.userMessage, isNotEmpty);
        expect(appError.resolution, isNotEmpty);
      });
    });

    group('Storage Error Handling', () {
      test('handles permission error correctly', () {
        final error = Exception('permission denied to access file');
        final appError = ErrorHandler.handleStorageError(error);

        expect(appError.code, equals('PERMISSION_DENIED'));
        expect(appError.userMessage, contains('权限'));
      });

      test('handles storage full error correctly', () {
        final error = Exception('No space left on device');
        final appError = ErrorHandler.handleStorageError(error);

        expect(appError.code, equals('STORAGE_FULL'));
        expect(appError.userMessage, contains('空间'));
      });

      test('handles file not found error correctly', () {
        final error = Exception('File not found');
        final appError = ErrorHandler.handleStorageError(error);

        expect(appError.code, equals('FILE_NOT_FOUND'));
        expect(appError.userMessage, contains('不存在'));
      });
    });

    group('Validation Error Handling', () {
      test('creates validation error with message', () {
        final appError = ErrorHandler.handleValidationError('Invalid input');

        expect(appError.code, equals('VALIDATION_ERROR'));
        expect(appError.userMessage, equals('Invalid input'));
      });
    });

    group('JSON Error Handling', () {
      test('handles JSON parse error correctly', () {
        final error = FormatException('Invalid JSON');
        final appError = ErrorHandler.handleJsonError(error);

        expect(appError.code, equals('JSON_ERROR'));
        expect(appError.userMessage, contains('格式'));
      });
    });

    group('Unknown Error Handling', () {
      test('handles unknown error correctly', () {
        final error = Exception('Something unexpected');
        final appError = ErrorHandler.handleUnknownError(error);

        expect(appError.code, equals('UNKNOWN_ERROR'));
        expect(appError.userMessage, contains('未知'));
      });
    });

    group('Error Utility Methods', () {
      test('getUserMessage returns userMessage when available', () {
        final appError = AppError(
          code: 'TEST',
          message: 'Technical message',
          userMessage: 'User friendly message',
        );

        expect(ErrorHandler.getUserMessage(appError), equals('User friendly message'));
      });

      test('getUserMessage falls back to message when userMessage is null', () {
        final appError = AppError(
          code: 'TEST',
          message: 'Technical message',
        );

        expect(ErrorHandler.getUserMessage(appError), equals('Technical message'));
      });

      test('getResolution returns resolution when available', () {
        final appError = AppError(
          code: 'TEST',
          message: 'Error',
          resolution: 'Try again',
        );

        expect(ErrorHandler.getResolution(appError), equals('Try again'));
      });

      test('getResolution returns default when resolution is null', () {
        final appError = AppError(
          code: 'TEST',
          message: 'Error',
        );

        expect(ErrorHandler.getResolution(appError), equals('请重试'));
      });
    });
  });
}
