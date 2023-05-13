import 'package:careergy_mobile/widgets/custom_textfieldform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/user.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _sendData() {
    final title = _titleController.text;
    final message = _messageController.text;

    if (title.isNotEmpty && message.isNotEmpty) {
      final database = FirebaseFirestore.instance;
      database.collection('ApplicantComplaints').add({
        'userID': _auth.currentUser!.uid,
        'title': title,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _titleController.clear();
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: const Text('Contact Us'),
      ),
      backgroundColor: accentCanvasColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              CustomTextField(
                label: 'Title',
                hint: 'Enter the title of your message',
                controller: _titleController,
                onChanged: (value) {},
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the Title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              CustomTextField(
                contentPadding: const EdgeInsets.symmetric(vertical: 200),
                label: 'Message',
                hint: 'Enter the message',
                controller: _messageController,
                onChanged: (value) {},
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendData();
                  }
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
