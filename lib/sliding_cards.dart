import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:busra_nur/event_source/news_payload.dart';
import 'dart:math' as math;

import 'package:busra_nur/event_source/reactive_stream_bloc.dart';

import 'bloc_helpers/bloc_provider.dart';

class SlidingCardsView extends StatefulWidget {
  // SlidingCardsView({
  //   Key key,
  //   this.reactiveStreamBloc,
  // }) : super(key: key);

  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  ReactiveStreamBloc reactiveStreamBloc;
  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  bool onNotification(ScrollNotification scrollInfo, ReactiveStreamBloc bloc) {
    if (scrollInfo is OverscrollNotification) {
      bloc.sink.add(scrollInfo);
    }
    return false;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reactiveStreamBloc = BlocProvider.of<ReactiveStreamBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) =>
            onNotification(notification, reactiveStreamBloc),
        child: StreamBuilder<UnmodifiableListView<NewsPayload>>(
          stream: reactiveStreamBloc.stream,
          initialData: UnmodifiableListView<NewsPayload>([]),
          builder: (context, snapshot) {
         //   print('UnmodifiableListView --> '+snapshot.data.length.toString());
            return PageView(
              controller: pageController,
              children: <Widget>[
                if (snapshot.data.isEmpty)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  for (NewsPayload a in snapshot.data)
                    SlidingCard(
                      name: a.topic,
                      date: a.date.toIso8601String(),
                      assetName: jpegs[snapshot.data.indexOf(a) % 6],
                      offset: pageOffset-snapshot.data.indexOf(a).toDouble(),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

final List<String> jpegs = [
  'steve-johnson.jpeg',
  'rodion-kutsaev.jpeg',
  'efe-kurnaz.jpg',
  'index.jpeg',
  'indexx.jpeg',
  'video_cover.jpg'
];

class SlidingCard extends StatelessWidget {
  final String name;
  final String date;
  final String assetName;
  final double offset;

  const SlidingCard({
    Key key,
    @required this.name,
    @required this.date,
    @required this.assetName,
    @required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  //  print('offset --> ' + offset.toString());
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.asset(
                'assets/$assetName',
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.none,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                name: name,
                date: date,
                offset: gauss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String date;
  final double offset;

  const CardContent(
      {Key key,
      @required this.name,
      @required this.date,
      @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(name, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(24 * offset, 0),
                    child: Text('Reserve'),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {},
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  '0.00 \$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
/*

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
              controller: pageController,
              onPageChanged: (value) => {pageOffset = pageController.page},
              children: <Widget>[
                BlocProvider<ReactiveStreamBloc>(
                  bloc: reactiveStreamBloc,
                  child: NewsfeedPage(offset: pageOffset),
                )
              ],
            ),
         );
  }
}

final List<String> jpegs = [
  'steve-johnson.jpeg',
  'rodion-kutsaev.jpeg',
  'efe-kurnaz.jpg'
];

class NewsfeedPage extends StatelessWidget {
  final double offset;

  const NewsfeedPage({
    Key key,
    @required this.offset,
  }) : super(key: key);

  bool onNotification(ScrollNotification scrollInfo, ReactiveStreamBloc bloc) {
    if (scrollInfo is OverscrollNotification) {
      bloc.sink.add(scrollInfo);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ReactiveStreamBloc reactiveStreamBloc =
        BlocProvider.of<ReactiveStreamBloc>(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          onNotification(notification, reactiveStreamBloc),
      child: StreamBuilder<UnmodifiableListView<NewsPayload>>(
          stream: reactiveStreamBloc.topArticles,
          initialData: UnmodifiableListView<NewsPayload>([]),
          builder: (context, snapshot) {
            return snapshot.data.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.data.map((a) => SlidingCard(
                      name: a.topic,
                      date: a.date.toIso8601String(),
                      assetName: jpegs[snapshot.data.indexOf(a) % 3],
                      offset: offset - snapshot.data.indexOf(a).toDouble(),
                    ));
          }),
    );
  }
}

*/