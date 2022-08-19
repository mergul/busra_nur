import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       // SizedBox(width: 24),
        MyTab(text: 'Nearby', isSelected: false),
        MyTab(text: 'Recent', isSelected: true),
        MyTab(text: 'Notice', isSelected: false),
      ],
    );
  }
}

class MyTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const MyTab({Key key, @required this.isSelected, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: isSelected ? 16 : 14,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Container(
            height: 6,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? Color(0xFFFF5A1D) : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
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