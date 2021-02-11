import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pal/Constant/global.dart';
import 'package:pal/Constant/strings.dart';
import 'package:pal/LOCALIZATION/localizations_constraints.dart';

import '../../Common/appbar.dart';
import '../../Constant/color.dart';
import '../../Constant/models.dart';
import '../../SERVICES/services.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List<NotificationData> notifications = [];
  bool notificationStatus = false;
  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  void getNotifications() async {
    Services.getNotifications().then((value) async {
      if (value.response == "y") {
        for (int i = 0; i < value.data.length; i++) {
          if (i == 0) {
            sharedPreferences.setString(
                lastNotificationId, value.data[i]["id"]);
          }
          var days = (DateTime.now()
              .difference(DateTime.parse(value.data[i]["inserted"])));
          var time;
          switch (days.inDays) {
            case 0:
              setState(() {
                time = "Today";
              });
              break;
            case 1:
              setState(() {
                time = "Yesterday";
              });
              break;
            default:
              setState(() {
                time = "${days.inDays} days ago";
              });
              break;
          }
          if (days.inDays <= 2) {
            setState(() {
              notifications.add(NotificationData(
                  title: value.data[i]["title"],
                  message: value.data[i]["content"],
                  id: value.data[i]["id"],
                  image: "assets/icons/store-icon.jpg",
                  time: time));
            });
          }
        }
        if (notifications.length == 0) {
          setState(() {
            notifications = null;
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
        appBar: appBar(
            context: context,
            title: translate(context, LocaleStrings.myNotifications)),
        body: notifications != null
            ? notifications.length > 0
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
                        valueColor: AlwaysStoppedAnimation(primaryColor),
                      ),
                    ),
                  )
            : Center(
                child: Text(
                    translate(context, LocaleStrings.youDontHaveNotifications)),
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
            Expanded(
              flex: 3,
              child: Text(
                notification.title + "",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  notification.time,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
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
