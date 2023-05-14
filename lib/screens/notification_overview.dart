import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart' as intl;

class NotificationOverviewScreen extends StatefulWidget {
  final String application_uid;
  final String company_uid;
  final String notification_uid;
  final String post_uid;
  final String message;
  final String post_image;
  final String job_title;
  final String note;
  final String status;
  final String address;
  final String company_name;
  final int timestamp;
  const NotificationOverviewScreen(
      {required this.application_uid,
      required this.company_uid,
      required this.notification_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.note,
      required this.status,
      required this.address,
      required this.message,
      required this.company_name,
      required this.timestamp,
      super.key});

  @override
  State<NotificationOverviewScreen> createState() =>
      _NotificationOverviewScreenState();
}

class _NotificationOverviewScreenState
    extends State<NotificationOverviewScreen> {
  String application_uid = '';
  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String note = '';
  String yearsOfExperience = '';
  String location = '';
  String status = '';
  String address = '';
  int appointment_timestamp = 0;
  bool finish = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(status: 'loading...');
      CollectionReference noti =
          FirebaseFirestore.instance.collection('notifications');

      await noti.doc(widget.notification_uid).update({'seen': true});
      setState(() {
        finish = true;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: ,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Notifications'),
        automaticallyImplyLeading: true,
        backgroundColor: canvasColor,
      ),
      backgroundColor: accentCanvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 90,
                                width: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    widget.post_image,
                                    // scale: 1,
                                    // fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                widget.company_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            intl.DateFormat('EEE, d MMM y | hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    widget.timestamp)),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      const Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        widget.message,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Compnay note',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        widget.note,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Application status',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        widget.status,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: white),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
