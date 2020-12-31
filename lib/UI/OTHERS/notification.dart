import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/color.dart';
import 'package:pal/Constant/userdata.dart';
import 'package:pal/SERVICES/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/appbar.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List<NotificationData> notifications = [];
  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  void getNotifications() async {
    Services.getNotifications().then((value) async {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          if(i == value.data.length - 1){
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString(UserParams.lastNotificationId, value.data[i]["id"]);
          }
          var days = (DateTime.now().day - DateTime.parse(value.data[i]["inserted"].toString().split(" ").first).day);
          var time = days == 0 ? "Today" : days == 1 ? "Yesterday" : "${days.toString()} days ago";
          setState(() {
            notifications.add(NotificationData(title: value.data[i]["title"], message: value.data[i]["content"], id: value.data[i]["id"], image: "assets/icons/store-icon.jpg", time: time));
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context: context, title: "Notification"),
        body: notifications.length > 0
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    for (int i = 0; i < notifications.length; i++)
                      notificationBuilder(notifications[i])
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
              ));
  }

  Widget notificationBuilder(NotificationData notification) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(10),
      shadowColor: Colors.grey[100],
      child: ExpansionTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              notification.image,
              fit: BoxFit.fill,
              height: 50,
              width: 50,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              notification.title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            Text(
              notification.time,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
        tilePadding: notification.expanded
            ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : null,
        subtitle: notification.expanded
            ? null
            : Text(
                notification.message,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
        onExpansionChanged: (value) {
          setState(() {
            notification.expanded = value;
          });
        },
        initiallyExpanded: false,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        children: notification.expanded
            ? [Divider(), Text(notification.message)]
            : [],
      ),
    );
  }
}

class NotificationData {
  final String image, title, message, id, time;
  bool expanded;
  NotificationData(
      {this.message,
      this.title,
      this.image,
      this.id,
      this.expanded: false,
      this.time});
}