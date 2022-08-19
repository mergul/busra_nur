
import 'sse_finder_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'mobile_sse.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'web_sse.dart' as platform;

 class SSEFinder {
  SSEFinder({this.stream});
  factory SSEFinder.connect(Uri uri) => platform.connect(uri);
  final Stream stream;
}
class MyEvent implements Comparable<MyEvent> {
  /// An identifier that can be used to allow a client to replay
  /// missed Events by returning the Last-Event-Id header.
  /// Return empty string if not required.
  String id;

  /// The name of the event. Return empty string if not required.
  String event;

  /// The payload of the event.
  String data;

  MyEvent({this.id, this.event, this.data});

  MyEvent.message({this.id, this.data}) : event = "message";

  @override
  int compareTo(MyEvent other) => id.compareTo(other.id);
}