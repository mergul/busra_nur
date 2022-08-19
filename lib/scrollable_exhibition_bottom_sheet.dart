import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:busra_nur/sliding_cards.dart';
import 'package:flutter/material.dart';
import 'package:busra_nur/event_source/news_payload.dart';
import 'package:busra_nur/event_source/reactive_stream_bloc.dart';

import 'bloc_helpers/bloc_provider.dart';

///Notice that by default this class is not used
///Go to [home_page.dart] and replace [ExhibitionBottomSheet] with [ScrollableExhibitionSheet] to use it
class ScrollableExhibitionSheet extends StatefulWidget {
  // final ReactiveStreamBloc reactiveStreamBloc;

  // ScrollableExhibitionSheet({
  //   Key key,
  //   this.reactiveStreamBloc,
  // }) : super(key: key);
  @override
  _ScrollableExhibitionSheetState createState() =>
      _ScrollableExhibitionSheetState();
}

class _ScrollableExhibitionSheetState extends State<ScrollableExhibitionSheet> {
  double initialPercentage = 0.20;
  double scaledPercentage, percentage, availPixels;
  ReactiveStreamBloc reactiveStreamBloc;
  List<NewsPayload> maList=<NewsPayload>[];

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   reactiveStreamBloc =
        BlocProvider.of<ReactiveStreamBloc>(context);
   reactiveStreamBloc.stream.listen((event) {
     maList.clear();
     maList.addAll(event.toList());
   });
 }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<NewsPayload>>(
      stream: reactiveStreamBloc.topArticles,
      initialData: UnmodifiableListView<NewsPayload>([]),
      builder: (context, snapshot) => Positioned.fill(
        child: DraggableScrollableSheet(
          minChildSize: initialPercentage,
          initialChildSize: initialPercentage,
          builder: (context, scrollController) {
            return AnimatedBuilder(
              animation: scrollController,
              builder: (context, child) {
                percentage = initialPercentage;
                if (scrollController.hasClients) {
                  if(availPixels == null)
                    availPixels = scrollController.position.viewportDimension*5;
                  percentage = (scrollController.position.viewportDimension) /
                      (availPixels); //49.1428571428571
                }
                scaledPercentage =
                    (percentage - initialPercentage) / (1 - initialPercentage);
                return GestureDetector(
                  onTap: () {
                    _toggle(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 32),
                    decoration: const BoxDecoration(
                      color: Color(0xFF162A49),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: percentage == 1 ? 1 : 0,
                          child: ListView.builder(
                            padding: EdgeInsets.only(right: 32, top: 128),
                            controller: scrollController,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              Event event = events[index % 6];
                              Event mievent = new Event(
                                  event.assetName,
                                  snapshot.data.isNotEmpty &&
                                          snapshot.data.length >
                                              (index % 6)
                                      ? snapshot.data[index % 6].topic
                                      : event.title,
                                  snapshot.data.isNotEmpty &&
                                          snapshot.data.length >
                                              (index % 6)
                                      ? snapshot.data[index % 6].date
                                          .toIso8601String()
                                      : event.date);
                              return MyEventItem(
                                event: mievent,
                                percentageCompleted: percentage,
                              );
                            },
                          ),
                        ),
                        ..._builtWidgets(),
                        // ...events.map((event) {
                        //   int index = events.indexOf(event);
                        //   Event mievent = new Event(
                        //       event.assetName,
                        //       snapshot.data.isNotEmpty &&
                        //               snapshot.data.length > (index % 6)
                        //           ? snapshot.data[index % 6].topic
                        //           : event.title,
                        //       snapshot.data.isNotEmpty &&
                        //               snapshot.data.length > (index % 6)
                        //           ? snapshot.data[index % 6].date
                        //               .toIso8601String()
                        //           : event.date);
                        //   int heightPerElement = 120 + 8 + 8;
                        //   double widthPerElement =
                        //       40 + percentage * 80 + 8 * (1 - percentage);
                        //   double leftOffset = widthPerElement *
                        //       (index > 4 ? index + 2 : index) *
                        //       (1 - scaledPercentage);
                        //   return Positioned(
                        //     top: 44.0 +
                        //         scaledPercentage * (128 - 44) +
                        //         index * heightPerElement * scaledPercentage,
                        //     left: leftOffset,
                        //     right: 32 - leftOffset,
                        //     child: IgnorePointer(
                        //       ignoring: true,
                        //       child: Opacity(
                        //         opacity: percentage == 1 ? 0 : 1,
                        //         child: MyEventItem(
                        //           event: mievent,
                        //           percentageCompleted: percentage,
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        SheetHeader(
                          fontSize: 14 + percentage * 8,
                          topMargin: 16 +
                              percentage * MediaQuery.of(context).padding.top,
                        ),
                        MenuButton(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _toggle(BuildContext context) {
    showCustomDialogWithImage(context);
    // setState(() {
    //   percentage=0.2;
    //   scaledPercentage=0.0;
    // });
  }

  void showCustomDialogWithImage(BuildContext context) {
    Dialog dialogWithImage = Dialog(
      child: Container(
        height: 320.0,
        width: 320.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Text(
                "Dialog With Image",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              height: 200,
              width: 260,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                  right: Radius.circular(16),
                ),
                child: Image.asset(
                  'assets/${jpegs[0]}',
                  width: 240,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel!',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }

  List<Positioned> _builtWidgets() {
   List<Positioned> ll=[];
   int index=0;
 //  print('_builtWidgets --> '+maList.length.toString());
   for(NewsPayload event in maList){
     Event mievent = new Event(
         events[index].assetName,
         event.topic,
         event.date.toIso8601String()
     );
     int heightPerElement = 120 + 8 + 8;
     double widthPerElement =
         40 + percentage * 80 + 8 * (1 - percentage);
     double leftOffset = widthPerElement *
         (index > 4 ? index + 2 : index) *
         (1 - scaledPercentage);
     ll.add(Positioned(
       top: 44.0 +
           scaledPercentage * (128 - 44) +
           index * heightPerElement * scaledPercentage,
       left: leftOffset,
       right: 32 - leftOffset,
       child: IgnorePointer(
         ignoring: true,
         child: Opacity(
           opacity: percentage == 1 ? 0 : 1,
           child: MyEventItem(
             event: mievent,
             percentageCompleted: percentage,
           ),
         ),
       ),
     ),
     );
     index++;
   }
   return ll;
  }
}


class MyEventItem extends StatelessWidget {
  final Event event;
  final double percentageCompleted;

  const MyEventItem({Key key, this.event, this.percentageCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: 1 / 3 + 2 / 3 * percentageCompleted,
        child: SizedBox(
          height: 120,
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                  right: Radius.circular(16 * (1 - percentageCompleted)),
                ),
                child: Image.asset(
                  'assets/${event.assetName}',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: max(0, percentageCompleted * 2 - 1),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(8),
                    child: _buildContent(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        Text(event.title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              '1 ticket',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 8),
            Text(
              event.date,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.grey.shade400, size: 16),
            Text(
              'Science Park 10 25A',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            )
          ],
        )
      ],
    );
  }
}

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('index.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('indexx.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('video_cover.jpg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('index.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('indexx.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('video_cover.jpg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('index.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('indexx.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('video_cover.jpg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
];

class Event {
  final String assetName;
  final String title;
  final String date;

  Event(this.assetName, this.title, this.date);
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {Key key, @required this.fontSize, @required this.topMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 32,
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.only(top: topMargin, bottom: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF162A49),
          ),
          child: Text(
            'Booked Exhibition',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 24,
      child: Icon(
        Icons.menu,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
