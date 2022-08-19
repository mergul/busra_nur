import 'sse_finder.dart';

/// Implemented in `web_sse.dart` and `mobile_sse.dart`.
SSEFinder connect(Uri uri) => throw UnsupportedError(
    'Cannot create a client without dart:html or dart:io.');