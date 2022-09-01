import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp2/controller/task_controller.dart';
import 'package:todoapp2/db/db_helper.dart';
import 'package:todoapp2/services/notification_services.dart';
import 'package:todoapp2/ui/pages/add_task_page.dart';
import 'package:todoapp2/ui/pages/notification_screen.dart';
import 'package:todoapp2/ui/size_config.dart';
import 'package:todoapp2/ui/theme.dart';
import 'package:todoapp2/ui/widgets/button.dart';
import 'package:todoapp2/ui/widgets/input_field.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todoapp2/ui/widgets/task_tile.dart';

import '../../models/task.dart';
import '../../services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _taskController.getTask();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Get.isDarkMode
              ? Icon(Icons.wb_sunny)
              : Icon(
                  Icons.dark_mode,
                  color: darkGreyClr,
                ),
          onPressed: () {
            ThemeServices().switchTheme();

            //Get.to(() => NotificationScreen('title|Note|Date'));
          },
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.03,
          )
        ],
        elevation: 0,
        backgroundColor: Get.isDarkMode ? darkGreyClr : white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
          child: Column(
            children: [
              _TaskBar(),
              _DateBar(),
              //_NoTask(),
              _ShowTask(),
            ],
          ),
        ),
      ),
    );
  }

  _TaskBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            label: " + Add Task",
            ontap: () => Get.to(() => AddTaskPage()),
          ),
        ],
      ),
    );
  }

  _DateBar() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        monthTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        onDateChange: (newdate) {
          // New date selected
          setState(() {
            _selectedDate = newdate;
            _taskController.getTask();
          });
        },
      ),
    );
  }

  _ShowTask() {
    return Container(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _NoTask();
          // return Stack(
          //   children: [
          //     Wrap(
          //       direction: Axis.horizontal,
          //       children: [
          //         SvgPicture.asset('images/task.svg'),
          //         Text(
          //           "You don't have any tasks yet\nAdd new taks to make your day productive",
          //           style: subTitleStyle,
          //         ),
          //       ],
          //     ),
          //   ],
          // );
        } else {
          return Container(
            height: double.maxFinite,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctx, int index) {
                    var task = _taskController.taskList[index];
                    if (task.repeat == 'Daily' ||
                        task.date == DateFormat.yMd().format(_selectedDate) ||
                        (task.repeat == 'Weekly' &&
                            _selectedDate
                                        .difference(
                                            DateFormat.yMd().parse(task.date!))
                                        .inDays %
                                    7 ==
                                0) ||
                        (task.repeat == 'Monthly' &&
                            _selectedDate.day ==
                                DateFormat.yMd().parse(task.date!).day))
                      return GestureDetector(
                        onTap: () => showBottomSheet(
                          _taskController.taskList[index],
                        ),
                        child: TaskTile(
                          task: _taskController.taskList[index],
                        ),
                      );
                    else
                      return Container();
                  },
                  itemCount: _taskController.taskList.length,
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  _NoTask() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: Wrap(
            direction: //SizeConfig.orientation == Orientation.landscape
                //? Axis.vertical
                Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              SvgPicture.asset(
                'images/task.svg',
                height: 100,
                width: 80,
                color: primaryClr.withOpacity(0.5),
              ),
              Text(
                "You don't have any tasks yet\nAdd new taks to make your day productive",
                style: subTitleStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = true}) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.7,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.white
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  showBottomSheet(Task task) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[900] : Colors.white),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              task.isCompleted == 0
                  ? _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        NotifyHelper().cancellNotification(task);
                        _taskController.markAsCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr)
                  : Container(),
              _buildBottomSheet(
                  label: 'Delete',
                  onTap: () {
                    NotifyHelper().cancellNotification(task);
                    _taskController.deleteTask(task);
                    Get.back();
                  },
                  clr: primaryClr),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              _buildBottomSheet(
                  label: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr),
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTask();
  }
}
