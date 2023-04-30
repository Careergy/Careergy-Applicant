import 'package:careergy_mobile/screens/agreements_screen.dart';
import 'package:careergy_mobile/screens/timeslots_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants.dart';

class ApplyForCompanyScnd extends StatefulWidget {
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;
  final String company_name;

  const ApplyForCompanyScnd(
      {super.key,
      required this.company_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.descreption,
      required this.yearsOfExperience,
      required this.location,
      required this.company_name});

  @override
  State<ApplyForCompanyScnd> createState() => _ApplyForCompanyScndState();
}

class _ApplyForCompanyScndState extends State<ApplyForCompanyScnd> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;
  final mainReference = FirebaseStorage.instance.ref('attachments/');

  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String descreption = '';
  String yearsOfExperience = '';
  String location = '';

  String company_name = '';

  List<dynamic> attachments_list = [];
  List<dynamic> attachments_ref_list = [];
  List<dynamic> attachments_format_list = [];

  final List<dynamic> choosen_attachments_List = [];

  Future<void> getUserAttachments(uid) async {
    EasyLoading.show(status: 'loading...');
    attachments_list.clear();
    attachments_ref_list.clear();
    attachments_format_list.clear();
    final storageRef = mainReference.child(uid);
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      // print(item.fullPath);
      final last_slash = item.fullPath!.lastIndexOf('/');
      final doc_name = item.fullPath!.substring(last_slash + 1);
      final format =
          doc_name.substring(doc_name.lastIndexOf('.') + 1).toLowerCase();
      setState(() {
        attachments_list.add(doc_name);
        attachments_ref_list.add(item);
        attachments_format_list.add(format);
      });
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    company_uid = widget.company_uid;
    post_uid = widget.post_uid;
    post_image = widget.post_image;
    job_title = widget.job_title;
    descreption = widget.descreption;
    yearsOfExperience = widget.yearsOfExperience;
    location = widget.location;
    company_name = widget.company_name;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getUserAttachments(user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlue,
          title: const Text('Attachments'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'job',
                        style: TextStyle(fontSize: 10),
                      ),
                      // Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      const Text(
                        'attachments',
                        style: TextStyle(fontSize: 10),
                      ),
                      // Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      const Text(
                        'agreements',
                        style: TextStyle(fontSize: 10),
                      ),
                      const Spacer(),
                      const Text(
                        'overview',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: kBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Flexible(
                        child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 2,
                            color: kBlue),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: kBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 2,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 2,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Select CV and attachments',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kBlue),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < attachments_list.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 224, 224, 224),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              attachments_format_list[i] == 'pdf'
                                  ? const Icon(Icons.picture_as_pdf)
                                  : attachments_format_list[i] == 'png' ||
                                          attachments_format_list[i] ==
                                              'jpeg' ||
                                          attachments_format_list[i] == 'jpg'
                                      ? const Icon(Icons.image)
                                      : const Icon(Icons.attach_file),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                attachments_list[i],
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              const Spacer(),
                              Checkbox(
                                  activeColor: kBlue,
                                  value: choosen_attachments_List
                                      .contains(attachments_list[i]),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      newValue!
                                          ? choosen_attachments_List
                                              .add(attachments_list[i])
                                          : choosen_attachments_List
                                              .remove(attachments_list[i]);
                                    });
                                    print(choosen_attachments_List);
                                    print(attachments_ref_list[i].fullPath);
                                  }),
                              // Container(
                              //   width: 30,
                              //   height: 30,
                              //   decoration: new BoxDecoration(
                              //     color: Colors.white,
                              //     shape: BoxShape.circle,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '* advice: you should attach files that either company might interested in, or important files that company requires.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  print('brief cv button');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AgreementsScreen(
                                company_name: company_name,
                                company_uid: company_uid,
                                descreption: descreption,
                                job_title: job_title,
                                location: location,
                                post_image: post_image,
                                post_uid: post_uid,
                                yearsOfExperience: yearsOfExperience,
                                choosen_attachments_List:
                                    choosen_attachments_List,
                              )));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  // color: Colors.blue,
                  child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const TimeslotScreen()));
              //   },
              //   child: const Text('Continue'),
              // )
            ],
          ),
        ));
  }
}
