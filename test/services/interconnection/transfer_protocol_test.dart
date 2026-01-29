import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/services/interconnection/transfer_protocol.dart';

void main() {
  group('TransferProtocol', () {
    test('should encode and decode packet correctly', () async {
      final payload = {'foo': 'bar', 'count': 123};
      final packet = TransferProtocol.createPacket(PacketType.syncData, payload);
      
      expect(packet.length, greaterThan(8));
      
      final decoded = await TransferProtocol.parsePacket(packet);
      
      expect(decoded, isNotNull);
      expect(decoded!['type'], 'syncData');
      final data = decoded!['data'] as Map<String, dynamic>;
      expect(data['foo'], 'bar');
      expect(data['count'], 123);
    });

    test('should return null for invalid magic', () async {
      final packet = [0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00];
      final decoded = await TransferProtocol.parsePacket(packet);
      expect(decoded, isNull);
    });
    
    test('should return null for incomplete packet', () async {
      final payload = {'foo': 'bar'};
      final packet = TransferProtocol.createPacket(PacketType.syncData, payload);
      
      // Cut off last byte
      final incomplete = packet.sublist(0, packet.length - 1);
      final decoded = await TransferProtocol.parsePacket(incomplete);
      
      expect(decoded, isNull);
    });
  });
}
