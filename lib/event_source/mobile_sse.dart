
import 'dart:async';
import 'package:http/http.dart';
import 'event.dart';
import 'event_source_transformer.dart';
import 'package:busra_nur/event_source/sse_finder.dart';

class MobileSSE extends SSEFinder{
  MobileSSE(Stream stream) : super(stream: stream);
 factory MobileSSE.connect(Uri uri) {
  //  Future<EventSource> eventSource = EventSource.connect(new Uri.http(
  //       '10.0.2.2:8091', '/sse/chat/room/TopNews/subscribeMessages'));     
 StreamController<Event> incomingController;
    final client = Client();

    incomingController = StreamController<Event>.broadcast(
      onListen: () {
        var request = Request('GET', uri)
          ..headers['Accept'] = 'text/event-stream';
        
        client.send(request).then((response) {
          if (response.statusCode == 200) {
            response.stream.transform(EventSourceTransformer()).listen((event) {
              incomingController.sink.add(event);
            });
          } else { 
            incomingController.addError(Exception('Failed to connect to ${uri.toString()}'));
          }
        });
      },
      onCancel: () {
        incomingController.close();
      }
    );

    return MobileSSE(incomingController.stream);
  }
}
 SSEFinder connect(Uri uri) => MobileSSE.connect(uri);
