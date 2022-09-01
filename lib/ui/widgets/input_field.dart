import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp2/ui/size_config.dart';
import 'package:todoapp2/ui/theme.dart';

class myInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? textController;
  final Widget? widget;
  const myInputField(
      {required this.title,
      required this.hint,
      this.textController,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.02),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: widget,
                border: OutlineInputBorder(),
                hintText: hint,
                hintStyle: subTitleStyle,
                label: Text(title),
                labelStyle: titleStyle,
              ),
              cursorColor: Get.isDarkMode ? Colors.white : Colors.grey,
              controller: textController,
              autofocus: false,
              readOnly: widget == null ? false : true,
              style: subTitleStyle,
            ),
          ),
          //widget ?? Container(),
        ],
      ),
    );
  }
}
