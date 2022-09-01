import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp2/services/theme_services.dart';
import 'package:todoapp2/ui/size_config.dart';
import 'package:todoapp2/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  NotificationScreen(
    this.payload,
  );

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String _payload;
  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? white : darkGreyClr,
          ),
        ),
        backgroundColor: context.theme.backgroundColor,
        title: Text(_payload.split("|")[0]),
        titleTextStyle: TextStyle(color: Get.isDarkMode ? white : darkGreyClr),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.03,
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      color: Get.isDarkMode ? white : darkGreyClr,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "you have a reminder",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  decoration: BoxDecoration(
                    color: primaryClr,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.text_format,
                              size: 30,
                              color: white,
                            ),
                            Text(
                              'Title',
                              style: TextStyle(color: white, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _payload.split("|")[0].toString(),
                          style: const TextStyle(color: white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.description,
                              size: 20,
                              color: white,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(color: white, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _payload.split("|")[1].toString(),
                          style: const TextStyle(color: white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.calendar_today,
                              size: 30,
                              color: white,
                            ),
                            Text(
                              'Date',
                              style: TextStyle(color: white, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _payload.split("|")[2].toString(),
                          style: const TextStyle(color: white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
