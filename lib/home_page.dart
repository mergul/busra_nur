// import 'package:busra_nur/bloc_helpers/bloc_provider.dart';
import 'package:flutter/material.dart';
// import 'package:busra_nur/event_source/reactive_stream_bloc.dart';
import 'bloc_helpers/bloc_provider.dart';
import 'event_source/reactive_stream_bloc.dart';
import 'scrollable_exhibition_bottom_sheet.dart';
import 'sliding_cards.dart';
// import 'package:scrollable_app_view/tabs.dart';

class HomePage extends StatefulWidget {
// final ReactiveStreamBloc reactiveStreamBloc;

  // HomePage({
  //   Key key,
  //   this.reactiveStreamBloc,
  // }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Choice _selectedChoice = choices[0];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Stack _stack = Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SlidingCardsView(),
            ],
          ),
        ),
        ScrollableExhibitionSheet(), //use this or ScrollableExhibitionSheet
      ],
    );
    TabBar _tabBar = TabBar(
      unselectedLabelColor: Colors.white,
      labelColor: Colors.amber,
      tabs: [
        new Tab(
          icon: new Icon(Icons.call),
        ),
        new Tab(
          icon: new Icon(Icons.chat),
        ),
        new Tab(
          icon: new Icon(Icons.notifications),
        )
      ],
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
    );
    return Scaffold(
        appBar: new AppBar(
          title: Header(),
          actions: <Widget>[
            IconButton(
              icon: Icon(choices[0].icon),
              onPressed: () {
                _select(choices[0]);
              },
            ),
            IconButton(
              icon: Icon(choices[1].icon),
              onPressed: () {
                _select(choices[1]);
              },
            ),
            PopupMenuButton<Choice>(
              icon: Icon(Icons.account_circle),
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(2).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice, child: Text(choice.title));
                }).toList();
              },
            ),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(_tabBar.preferredSize.height - 30),
              child: _tabBar),
          bottomOpacity: 1,
        ),
        body: BlocProvider<ReactiveStreamBloc>(
            blocBuilder: () => ReactiveStreamBloc(),
            child: TabBarView(
              children: [
                _stack,
                _stack,
                _stack,
              ],
              controller: _tabController,
            )));
  }

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Shenzhen',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  final Choice choice;

  const ChoiceCard({Key key, this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline4;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                choice.icon,
                size: 128.0,
              ),
              Text(choice.title, style: textStyle)
            ],
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

/*
FlatButton(
  onPressed: () {
    Navigator.of(context).push(
      // We will now use PageRouteBuilder
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, __) {
          return new Scaffold(
            backgroundColor: Colors.black45,
            body: new Container(
              margin: EdgeInsetsDirectional.only(
                          top: 60.0, end: 2.0)
              color: Color.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: new FlatButton(
                 child: Text('Close'),
                 onPressed: () {
                   Navigator.pop(context);
                 }
              ), // FlatButton
            ), // Container
          ); // Scaffold
        }
      )
    ), // PageRouteBuilder
  }
)
 */
