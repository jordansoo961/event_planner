// lib/main.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:event_planner/dashboard.dart';
import 'package:event_planner/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>("eventDetails");
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      theme: ThemeData(fontFamily: "Roboto"),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const Dashboard()
    );
  }
}
