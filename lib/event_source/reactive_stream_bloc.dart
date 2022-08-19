import 'dart:collection';
import 'dart:convert';

// import 'package:busra_nur/event_source/sse.dart';
import 'package:busra_nur/bloc_helpers/bloc_provider.dart';
import 'package:busra_nur/event_source/sse_finder.dart';
import 'package:flutter/widgets.dart';

// import 'package:eventsource/eventsource.dart';
import 'package:rxdart/rxdart.dart';
import 'news_payload.dart';
import 'record_sse.dart';

class ReactiveStreamBloc implements BlocBase {
  double pageNumber = 0.0;
  double pixels = 0.0;
  SSEFinder sseFinder;

  // Sse sse;
  // EventSource eventSource;
  final _newsBehaviorSubject =
      BehaviorSubject<UnmodifiableListView<NewsPayload>>();
  final _tagsBehaviorSubject =
      BehaviorSubject<UnmodifiableListView<RecordSSE>>();
  final _countsBehaviorSubject = BehaviorSubject<RecordSSE>();
  final _meBehaviorSubject =
      BehaviorSubject<UnmodifiableListView<NewsPayload>>();
  BehaviorSubject<UnmodifiableListView<NewsPayload>> _subject =
      BehaviorSubject();
  final ReplaySubject<ScrollNotification> _controller = ReplaySubject();

  ReactiveStreamBloc() {
    sseFinder = SSEFinder.connect(new Uri.http(
        '10.0.2.2:8091', '/sse/chat/room/TopNews2134356/subscribeMessages'));
    // sse = Sse.connect(
    //   uri: new Uri.http('localhost:8091', '/sse/chat/room/TopNews2134356/subscribeMessages'),
    //   uri: Uri.parse('http://localhost:8091/sse/chat/room/TopNews2134356/subscribeMessages'),
    //   closeOnError: true,
    //   withCredentials: false,
    // );
    _setUpEventSource();
    _controller.listen((notification) => loadPhotos(notification));
  }

  Stream<UnmodifiableListView<NewsPayload>> get topArticles =>
      _newsBehaviorSubject.stream;

  Stream<UnmodifiableListView<RecordSSE>> get topTags =>
      _tagsBehaviorSubject.stream;

  Stream<RecordSSE> get countArticles => _countsBehaviorSubject.stream;

  Stream<UnmodifiableListView<NewsPayload>> get meArticles =>
      _meBehaviorSubject.stream;

  Stream<UnmodifiableListView<NewsPayload>> get stream => _subject.stream;

  Sink<ScrollNotification> get sink => _controller.sink;

  void _setUpEventSource() async {
    // eventSource = await EventSource.connect(new Uri.http(
    //   '10.0.2.2:8091', '/sse/chat/room/TopNews/subscribeMessages'));
    sseFinder.stream.listen((event) {
      switch (event.event) {
        case "top-news-2134356":
          {
            var jsonNewsPayload = jsonDecode(event.data)['list'] as List;
            List<NewsPayload> tagObjs = jsonNewsPayload
                .map((tagJson) => NewsPayload.fromJson(tagJson))
                .toList();

            List<NewsPayload> ml = _newsBehaviorSubject.value != null
                ? [..._newsBehaviorSubject.value.toList(), ...tagObjs]
                : tagObjs;
            _newsBehaviorSubject.add(UnmodifiableListView(ml));
            int d=_newsBehaviorSubject.value.length;
            if (_subject.value == null&&_newsBehaviorSubject.value.length==5) {
              int ls=(pageNumber.toInt() + 1) * 5;
              Iterable<NewsPayload> list = _newsBehaviorSubject.value.getRange(
                  pageNumber.toInt() * 5, d>ls?ls:d);
              _subject.add(UnmodifiableListView(list));
            }
          }

          break;

        case "top-tags":
          {
            var tagObjsJson = jsonDecode(event.data)['list'] as List;
            List<RecordSSE> tagObjs = tagObjsJson
                .map((tagJson) => RecordSSE.fromJson(tagJson))
                .toList();
            _tagsBehaviorSubject.add(UnmodifiableListView(tagObjs));
          }

          break;
        case "user-counts":
          {
            var jsonCounts = jsonDecode(event.data);

            _countsBehaviorSubject.add(RecordSSE.fromJson(jsonCounts));
          }

          break;
        default:
      }
    });
  }

  void loadPhotos([
    ScrollNotification notification,
  ]) {
    if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        pixels != notification.metrics.pixels) {
      pixels = notification.metrics.pixels;
      pageNumber++;
      int ls=(pageNumber.toInt() + 1) * 5;
      int d=_newsBehaviorSubject.value.length;
      Iterable<NewsPayload> list = _newsBehaviorSubject.value
          .getRange(0, d>ls?ls:d);
      _subject.add(UnmodifiableListView(list));
    }
  }

  void close() {
    _newsBehaviorSubject.close();
    _tagsBehaviorSubject.close();
    _countsBehaviorSubject.close();
    _meBehaviorSubject.close();
    _subject.close();
    _controller.close();
  }

  @override
  void dispose() {
    close();
  }
}
