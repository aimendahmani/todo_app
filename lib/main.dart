import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp2/db/db_helper.dart';
import 'package:todoapp2/services/notification_services.dart';
import 'package:todoapp2/services/theme_services.dart';
import 'package:todoapp2/ui/pages/add_task_page.dart';
import 'package:todoapp2/ui/pages/notification_screen.dart';

import 'ui/pages/home_page.dart';
import 'ui/size_config.dart';
import 'ui/theme.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await GetStorage.init();
  NotifyHelper().InitializeNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().modeTheme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
