import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  // var reactiveStreamBloc = ReactiveStreamBloc();
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(MyApp(reactiveStreamBloc: reactiveStreamBloc));
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
//  final ReactiveStreamBloc reactiveStreamBloc;

// MyApp({
//     Key key,
//     this.reactiveStreamBloc,
//   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SF Pro Display'),
      title: 'Buy Tickets',
      debugShowCheckedModeBanner: false,
      // home: HomePage(reactiveStreamBloc: reactiveStreamBloc),
      home: HomePage(),
    );
  }
}
