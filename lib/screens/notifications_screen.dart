import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/notification_overview.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart' as intl;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

List notificationList = [
  {'s'}
];

class _NotificationScreenState extends State<NotificationScreen> {
  List notifications = [];
  List company_names = [];
  List applications_uid = [];
  List applications_status = [];
  List notification_uid = [];
  List applications_message = [];
  List company_photos = [];
  List applications_address = [];
  List messages = [];
  bool finish = false;

  Future getNotifications() async {
    Query<Map<String, dynamic>> notification_ref = FirebaseFirestore.instance
        .collection('notifications')
        .where('applicant_uid',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('timestamp', descending: true);
    QuerySnapshot querySnapshot = await notification_ref.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataUid =
        querySnapshot.docs.map((doc) => doc.reference.id).toList();
    setState(() {
      notifications = allData;
      notification_uid = allDataUid;
    });
    CollectionReference companies =
        FirebaseFirestore.instance.collection('companies');
    for (var i = 0; i < allData.length; i++) {
      if (notifications[i].toString().contains('status')) {
        applications_status.add(notifications[i]['status']);
        if (notifications[i]['status'] == 'waiting') {
          setState(() {
            messages.add('Your application is ready for accepting meeting !');
          });
        } else if (notifications[i]['status'] == 'approved') {
          setState(() {
            messages.add('Congrats, your applied job got approved ✍️ !');
          });
        } else if (notifications[i]['status'] == 'accepted') {
          setState(() {
            messages.add('You accepted the meeting succefully !');
          });
        } else if (notifications[i]['status'] == 'rejected') {
          setState(() {
            messages.add('Sorry, your application got rejected');
          });
        } else {
          setState(() {
            messages.add('');
          });
        }
      } else {
        applications_status.add('');
      }
      await companies
          .doc(notifications[i]['company_uid'])
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          setState(() {
            company_names.add(
                ds.data().toString().contains('name') ? ds.get('name') : '');
            company_photos.add(ds.data().toString().contains('photoUrl')
                ? ds.get('photoUrl')
                : '');
          });
        } else {
          print('Document does not exist on the database');
        }
      });

      CollectionReference applications =
          FirebaseFirestore.instance.collection('applications');
      await applications
          .doc(notifications[i]['application_uid'])
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          setState(() {
            applications_uid.add(ds.reference.id);

            applications_message.add(
                ds.data().toString().contains('note') ? ds.get('note') : '');
            applications_address.add(ds.data().toString().contains('address')
                ? ds.get('address')
                : '');
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(status: 'loading...');
      await getNotifications();
      // await getAppliedPosts();
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
                child: finish && notifications.isNotEmpty
                    ? ListView(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: List.generate(notifications.length, (i) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationOverviewScreen(
                                            application_uid:
                                                applications_uid[i],
                                            company_uid: notifications[i]
                                                ['company_uid'],
                                            notification_uid:
                                                notification_uid[i],
                                            message: messages[i],
                                            post_uid: notifications[i]
                                                ['post_uid'],
                                            post_image: company_photos[i],
                                            job_title: '',
                                            note:
                                                notifications[i]['note'] ?? '',
                                            status: notifications[i]['status'],
                                            company_name: company_names[i],
                                            timestamp: notifications[i]
                                                    ['timestamp'] ??
                                                0,
                                            address:
                                                applications_address[i] ?? '',
                                          )),
                                ).then((value) async {
                                  // print('object');
                                  EasyLoading.show(status: 'loading...');
                                  // await getApplications();
                                  // await getAppliedPosts();
                                  setState(() {
                                    finish = true;
                                  });
                                  EasyLoading.dismiss();
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  width: 240,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: canvasColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image.network(
                                              company_photos[i] != null
                                                  ? company_photos[i]
                                                  : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
                                              // scale: 1,
                                              // fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                messages[i],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                company_names[i],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    color: white),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                notifications[i]['note'] ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    // fontWeight: FontWeight,
                                                    color: white),
                                              ),
                                              Text(
                                                notifications[i]['status'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    color: white),
                                              ),
                                              Text(
                                                intl.DateFormat(
                                                        'EEE, d MMM y | hh:mm a')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            notifications[i]
                                                                ['timestamp'])),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: notifications[i]['seen'] ??
                                                    false
                                                ? Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  )
                                                : Text(''),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        }))
                    : Text(''),
              )
            ],
          ),
        ),
      ),
    );
  }
}
