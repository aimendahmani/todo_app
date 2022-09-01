import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp2/controller/task_controller.dart';
import 'package:todoapp2/ui/size_config.dart';
import 'package:todoapp2/ui/theme.dart';
import 'package:todoapp2/ui/widgets/button.dart';
import 'package:todoapp2/ui/widgets/input_field.dart';

import '../../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _noteController = new TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> _remindList = [5, 10, 15, 20];

  String _selectedRepeat = 'none';
  List<String> _repeatList = ['none', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
          color: Get.isDarkMode ? Colors.white : Color.fromARGB(255, 17, 2, 60),
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
      body: Container(
        height: SizeConfig.screenHeight,
        child: Padding(
          padding: EdgeInsets.all(
            SizeConfig.screenWidth * 0.03,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Add Task',
                  style: headingStyle,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                myInputField(
                  title: 'title',
                  hint: 'Enter title here',
                  textController: _titleController,
                ),
                myInputField(
                  title: 'note',
                  hint: 'Enter note here',
                  textController: _noteController,
                ),
                myInputField(
                  title: DateFormat.yMd().format(_selectedDate),
                  hint: 'Enter note here',
                  widget: IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: myInputField(
                        title: _startTime,
                        hint: 'start time',
                        widget: IconButton(
                          icon: Icon(Icons.calendar_today_outlined),
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.03,
                    ),
                    Expanded(
                      child: myInputField(
                        title: _endTime,
                        hint: 'End time',
                        widget: IconButton(
                          icon: Icon(Icons.calendar_today_outlined),
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                myInputField(
                  title: '$_selectedRemind minutes early',
                  hint: '',
                  widget: DropdownButton(
                    items: _remindList
                        .map<DropdownMenuItem<String>>(
                            (int val) => DropdownMenuItem<String>(
                                  child: Text('$val'),
                                  value: val.toString(),
                                ))
                        .toList(),
                    onChanged: (String? newval) {
                      setState(() {
                        _selectedRemind = int.parse(newval!);
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    underline: Container(height: 0),
                  ),
                ),
                myInputField(
                  title: '$_selectedRepeat ',
                  hint: '',
                  widget: DropdownButton(
                    items: _repeatList
                        .map<DropdownMenuItem<String>>(
                            (val) => DropdownMenuItem<String>(
                                  child: Text(val),
                                  value: val,
                                ))
                        .toList(),
                    onChanged: (String? newval) {
                      setState(() {
                        _selectedRepeat = newval!;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    underline: Container(height: 0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ColorPalette(),
                    MyButton(
                        label: 'Add Task',
                        ontap: () {
                          _validateDate();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _ColorPalette() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.01,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : Container(),
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else {
      Get.snackbar('required', 'All fields are required',
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          colorText: pinkClr,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print('$value');
  }

  void _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null)
      setState(() {
        _selectedDate = _pickedDate;
      });
    else
      print('something go wrong on pickedDate');
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    String _formattedTime = _pickedTime!.format(context);

    if (isStartTime)
      setState(() {
        _startTime = _formattedTime;
      });
    else if (!isStartTime)
      setState(() {
        _endTime = _formattedTime;
      });
    else
      print('something go wrong on picked Time');
  }
}
