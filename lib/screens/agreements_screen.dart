import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AgreementsScreen extends StatefulWidget {
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;
  final String company_name;
  final List choosen_attachments_List;

  const AgreementsScreen(
      {super.key,
      required this.company_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.descreption,
      required this.yearsOfExperience,
      required this.location,
      required this.company_name,
      required this.choosen_attachments_List});

  @override
  State<AgreementsScreen> createState() => _AgreementsScreenState();
}

class _AgreementsScreenState extends State<AgreementsScreen> {
  bool terms_of_service = false;
  bool acknowledge_correct_info = false;

  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String descreption = '';
  String yearsOfExperience = '';
  String location = '';

  String company_name = '';

  List<dynamic> choosen_attachments_List = [];

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
    choosen_attachments_List = widget.choosen_attachments_List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlue,
          title: const Text('Agreements'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    const SizedBox(
                      height: 1,
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
                            color: kBlue,
                          ),
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
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 70,
                  width: MediaQuery.of(context).size.width - 70,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: terms_of_service,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    newValue!
                                        ? terms_of_service = true
                                        : terms_of_service = false;
                                  });
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                'I have read and accept the terms of service and privacy policy',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: acknowledge_correct_info,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    newValue!
                                        ? acknowledge_correct_info = true
                                        : acknowledge_correct_info = false;
                                  });
                                }),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                'I acknowledge that all information are correct and belongs to me.',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  child: const Text(
                    '* all agreements must be marked to be able to send the application to the coresponding company.',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    terms_of_service && acknowledge_correct_info
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OverviewScreen(
                                    company_name: company_name,
                                    company_uid: company_uid,
                                    descreption: descreption,
                                    job_title: job_title,
                                    location: location,
                                    post_image: post_image,
                                    post_uid: post_uid,
                                    yearsOfExperience: yearsOfExperience,
                                    choosen_attachments_List:
                                        choosen_attachments_List)))
                        : null;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: terms_of_service && acknowledge_correct_info
                            ? kBlue
                            : Colors.black38,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
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
              ]),
        ));
  }
}
