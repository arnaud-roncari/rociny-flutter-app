import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:rociny/core/config/environment.dart';

class ConversationGateway {
  late io.Socket _socket;

  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get eventsStream => _eventController.stream;

  void connect() {
    _socket = io.io(
      '$kEndpoint/conversation',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'query': {
          'token': kJwt,
        },
      },
    );

    _socket.connect();

    _socket.onConnect((_) {
      // connected
    });

    _socket.onDisconnect((_) {
      // disconnected
    });

    // Listen for new message events
    _socket.on('add_message', (data) {
      _eventController.add({'type': 'add_message', 'data': data});
    });

    // Listen for conversation refresh events
    _socket.on('refresh_conversation', (data) {
      _eventController.add({'type': 'refresh_conversation', 'data': data});
    });
  }

  void dispose() {
    _eventController.close();
    _socket.dispose();
  }
}
