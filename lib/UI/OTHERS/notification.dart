import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Common/appbar.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List<NotificationData> notifications = [
    NotificationData(
        name: "Notification 1",
        image: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png",
        id: "1",
        time: "2 days ago",
        message: "Hi!, How are you! \nThe quick brown fox jumps over the lazy dog"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Notification"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ExpansionTile(
              leading: Image.network(notifications[0].image),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(notifications[0].name, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),),
                  Text(notifications[0].time, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),)
                ],
              ),
              tilePadding: notifications[0].expanded ? EdgeInsets.symmetric(horizontal: 16, vertical: 8) : null,
              subtitle: notifications[0].expanded ? null : Text(notifications[0].message, overflow: TextOverflow.ellipsis, maxLines: 1,),
              onExpansionChanged: (value) {
                setState(() {
                  notifications[0].expanded = value;
                });
              },
              initiallyExpanded: false,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              children: notifications[0].expanded ? [
                Divider(),
                Text(notifications[0].message)
              ] : [],
            )
          ],
        ),
      ),
    );
  }

  Widget notificationBuilder() {
    return null;
  }
}

class NotificationData {
  final String image, name, message, id, time;
  bool expanded;
  NotificationData({this.message, this.name, this.image, this.id, this.expanded : false, this.time});
}
