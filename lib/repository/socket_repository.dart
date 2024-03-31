import 'package:google_docs/clients/sockets_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void joinRoom(String documentId) async {
    _socketClient.emit("join", documentId);
    print("success");
  }

  void typing(Map <String, dynamic> data){
   _socketClient.emit('typing', data);
  }

  void changeListner(Function(Map<String, dynamic>) func) {
    _socketClient.on('changes', (data) => func(data));
  }
}
