import 'dart:async';
// import 'dart:html';
import 'package:universal_html/html.dart';
// import 'package:sse/client/sse_client.dart';
import 'package:busra_nur/event_source/sse_finder.dart';
// import "package:eventsource/eventsource.dart";
// import "package:http/browser_client.dart";

import 'event.dart';

class WebSSE extends SSEFinder {
  WebSSE(Stream stream) : super(stream: stream);
  factory WebSSE.connect(Uri uri, {bool withCredentials = false}) {
    Uri miUri = new Uri.http(
        '127.0.0.1:8091', '/sse/chat/room/TopNews2134356/subscribeMessages');
    StreamController<Event> incomingController =
        new StreamController<Event>.broadcast();
    final eventSource = EventSource(
        miUri.toString(),
        withCredentials: withCredentials);
    // _setUpEventSource();
    //  final sseClient=SseClient('http://localhost:8091/sse/chat/room/TopNews2134356/subscribeMessages');
    //  sseClient.stream.listen((event) {
    //    var currentEvent = Event();
    //    currentEvent.data=(event as html.MessageEvent).data;
    //    currentEvent.id=(event as html.MessageEvent).lastEventId;
    //    currentEvent.event=(event as html.MessageEvent).type;
    //    incomingController.add(currentEvent);
    //  }, onError: (err) {
    //    incomingController?.close();
    //  });
    eventSource.addEventListener('message', (event) {
      var currentEvent = Event();
      currentEvent.data = (event as MessageEvent).data;
      currentEvent.id = (event as MessageEvent).lastEventId;
      currentEvent.event = (event as MessageEvent).type;
      incomingController.add(currentEvent);
    });
    eventSource.onError.listen((event) {
      eventSource?.close();
      incomingController?.close();
    });
    return WebSSE(incomingController.stream);
  }
}

SSEFinder connect(Uri uri) => WebSSE.connect(uri);
// void _setUpEventSource(StreamController<Event> incomingController) async {
// evtsrc.EventSource eventSource=await
// evtsrc.EventSource.connect("http://localhost:8091/sse/chat/room/TopNews2134356/subscribeMessages", client: new BrowserClient());
// eventSource.listen((evtsrc.Event event) {
//   print("New event:");
//   print("  event: ${event.event}");
//   print("  data: ${event.data}");
//       var currentEvent = Event();
//       currentEvent.data = event.data;
//       currentEvent.id = event.id;
//       currentEvent.event = event.event;
//   incomingController.add(currentEvent);
// });
// }
/*
class WebSSE implements SSEFinder{
SseClient sseClient;
final streamController = StreamController<MyEvent>.broadcast();
String _id, _evt, _data;
  WebSSE() {
  }
MyEvent getEvt(MessageEvent messageEvent){
  //MessageEvent messageEvent=jsonDecode(text);
  _id=messageEvent.timeStamp.toString();
  _evt=messageEvent.type;
  _data=messageEvent.data.toString();
  return MyEvent(id: _id, event: _evt, data: _data);
}
  @override
  Future<Stream<MyEvent>> getListener() async {
    // final eventSource = new EventSource('http://localhost:8091/sse/chat/room/TopNews/subscribeMessages'
    // , withCredentials: true);

    // eventSource.addEventListener('message', (Event message) {
    //    streamController.add(getEvt(message as MessageEvent));
    // });

    //  sseClient=SseClient('http://localhost:8091/sse/chat/room/TopNews/subscribeMessages');
    //  sseClient.stream.listen((event) { 
    //    streamController.add(getEvt(event as MessageEvent));
    //  });
    return await HttpRequest.request(
    'http://localhost:8091/sse/chat/room/TopNews/subscribeMessages',
    method: 'GET',
    withCredentials: true,
    requestHeaders: {
      'Accept': 'text/event-stream',
      'X-Custom-Header': 'last-event-id'
    }
  ).then((HttpRequest req) => 
       req.onReadyStateChange.where((event) => req.readyState==HttpRequest.DONE)
       .first.then((value) => streamController.add(getEvt(value as MessageEvent)))
  ).then((value) => streamController.stream);
    // return await Future.value(streamController.stream);
  }
}
 SSEFinder createSSE() => WebSSE();

    HttpRequest.request(
    'http://localhost:8091/sse/chat/room/TopNews/subscribeMessages',
    method: 'GET',
    withCredentials: true,
    requestHeaders: {
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'X-Custom-Header': 'last-event-id'
    }
  ).then((HttpRequest req) => {
       streamController.add(getEvt(req.responseText))
  });
 */
