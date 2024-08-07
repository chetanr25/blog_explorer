// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blog_explorer/utils/custom_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController feedbackController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEmpty = true;
  SharedPreferences? prefs;
  bool isSubmitted = false;

  void sendMail(feedback) async {
    var url = dotenv.env['emailSecret'] ?? 'E-Mail Service API Key';
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'isEmail': 'true',
            'email': 'chetan250204@gmail.com',
            'subject':
                '${emailController.text} Feedback from Flutter Blog Explorer App',
            'body': '$feedback',
          },
        ),
      );
      CustomSnackbar.snack(context, 'Feedback sent successfully',
          color: Colors.green);
    } catch (e) {
      print(e);
      CustomSnackbar.snack(context,
          'E-Mail service API key missing in .env file. Please add it and try again.');
    }
  }

  void initprefs() async {
    prefs = await SharedPreferences.getInstance();
    String? feedback = prefs?.getString('feedback');
    String? submitedDate = prefs?.getString('submitedDate');
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (feedback != null && submitedDate == currentDate) {
      setState(() {
        feedbackController.text = feedback;
        isSubmitted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initprefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  // style: TextButton.styleFrom(
                  //     elevation: 12,
                  //     side: BorderSide(
                  //         color: Theme.of(context).primaryColor.withOpacity(0.2),
                  //         width: 0.5)),
                  onPressed: () async {
                    var url = 'https://www.linkedin.com/in/chetanr25/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                    // }
                    // Add your logic here to connect with LinkedIn
                  },
                  icon: Image.asset(
                    'assets/images/linkedin.png',
                    height: 28,
                  ),
                  label: const Text('Contact developer'),
                ),
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: 'E-mail (Optional)'),
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                controller: emailController,
              ),
              const Gap(10),
              TextField(
                controller: feedbackController,
                enabled: !isSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Send feedback anonymously',
                ),
                onChanged: (value) {
                  if (isEmpty && value.trim().isNotEmpty) {
                    setState(() {
                      isEmpty = false;
                    });
                  } else if (!isEmpty && value.trim().isEmpty) {
                    setState(() {
                      isEmpty = true;
                    });
                  }
                },
                maxLines: 5,
              ),
              const Gap(20),
              if (!isEmpty && !isSubmitted)
                ElevatedButton(
                  onPressed: () {
                    if (isEmpty) {
                      return;
                    }
                    setState(() {
                      isSubmitted = true;
                    });
                    prefs?.setString('feedback', feedbackController.text);
                    prefs?.setString('submitedDate',
                        DateFormat('dd-MM-yyyy').format(DateTime.now()));
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Feedback Submitted'),
                            content: const Text(
                                'Thank you for your feedback. We will try to improve the app based on your feedback.\nClick on Home to go back to the home screen'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });

                    String feedback = feedbackController.text;
                    if (feedback.trim().isEmpty) {
                      return;
                    }
                    // return;
                    feedback +=
                        '\n\n\nSent from ${emailController.text != '' ? emailController.text : 'Anonymous\n\n'}';
                    sendMail(feedback);
                  },
                  child: const Text('Submit'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
