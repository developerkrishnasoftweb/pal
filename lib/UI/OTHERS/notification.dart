import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../Common/appbar.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List<NotificationData> notifications = [
    NotificationData(
        title: "Notification 1",
        image: "assets/icons/store-icon.jpg",
        id: "1",
        time: "2 days ago",
        message: "Hi!, How are you! \nThe quick brown fox jumps over the lazy dog"),
    NotificationData(
        title: "Notification 1",
        image: "assets/icons/store-icon.jpg",
        id: "1",
        time: "2 days ago",
        message: "Hi!, How are you! \nThe quick brown fox jumps over the lazy dog"),
    NotificationData(
        title: "Notification 1",
        image: "assets/icons/store-icon.jpg",
        id: "1",
        time: "2 days ago",
        message: "Hi!, How are you! \nThe quick brown fox jumps over the lazy dog"),
    NotificationData(
        title: "Notification 1",
        image: "assets/icons/store-icon.jpg",
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
            for(int i = 0; i < notifications.length; i++)
              notificationBuilder(notifications[i])
          ],
        ),
      ),
    );
  }

  Widget notificationBuilder(NotificationData notification) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(10),
      shadowColor: Colors.grey[100],
      child: ExpansionTile(
        leading: ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset(notification.image, fit: BoxFit.fill, height: 50, width: 50,)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(notification.title, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),),
            Text(notification.time, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),)
          ],
        ),
        tilePadding: notification.expanded ? EdgeInsets.symmetric(horizontal: 16, vertical: 8) : null,
        subtitle: notification.expanded ? null : Text(notification.message, overflow: TextOverflow.ellipsis, maxLines: 1,),
        onExpansionChanged: (value) {
          setState(() {
            notification.expanded = value;
          });
        },
        initiallyExpanded: false,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        children: notification.expanded ? [
          Divider(),
          Text(notification.message)
        ] : [],
      ),
    );
  }
}

class NotificationData {
  final String image, title, message, id, time;
  bool expanded;
  NotificationData({this.message, this.title, this.image, this.id, this.expanded : false, this.time});
}
