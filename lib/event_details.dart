// ignore_for_file: library_private_types_in_public_api

import 'package:event_planner/Globals/general_text.dart';
import 'package:event_planner/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:event_planner/Config/string_config.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final int index;

  const EventDetailScreen({super.key, required this.event, required this.index});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late bool isAttending;

  List attendees = [
    {
      'name': "Jack"
    },
    {
      'name': "Amber"
    },
    {
      'name': "Jasper"
    },
    {
      'name': "Brownie"
    },
    {
      'name': "Ashley"
    },
    {
      'name': "Calvin"
    },
  ];

  @override
  void initState() {
    super.initState();
    isAttending = widget.event.isAttending ?? false;
  }

  toggleAttendance() async {
    setState(() {
      isAttending = !isAttending;
    });

    var box = Hive.box<Event>("eventDetails");
    final updatedEvent = Event(
      title: widget.event.title,
      date: widget.event.date,
      location: widget.event.location,
      description: widget.event.description,
      isAttending: isAttending
    );

    box.putAt(widget.index, updatedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    String formattedDate = DateFormat('MMM d, yyyy').format(event.date);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    padding: EdgeInsets.all(StringConfig.deviceHeight(context) / 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: isAttending == true ? Colors.green : Colors.grey
                  ),
                  onPressed: toggleAttendance,
                  child: GeneralText(text: StringConfig.eventDetails_btnAttending, fontSize: 16)
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    padding: EdgeInsets.all(StringConfig.deviceHeight(context) / 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: isAttending == false ? Colors.red : Colors.grey
                  ),
                  onPressed: toggleAttendance,
                  child: GeneralText(text: StringConfig.eventDetails_btnNotAttending, fontSize: 16)
                ),
              ),
            )
          ]
        )
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: GeneralText(text: StringConfig.eventDetails_title, fontWeight: FontWeight.bold, textColor: HexColor(StringConfig.color_black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(StringConfig.deviceWidth(context) / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/event.jpg',
                fit: BoxFit.cover,
              )
            ),
            const SizedBox(height: 24),
            GeneralText(text: event.title, fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 14),
            GeneralText(text: formattedDate, fontSize: 16),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 5),
                GeneralText(text: event.location, fontSize: 16)
              ]
            ),
            const SizedBox(height: 24),
            GeneralText(text: "${StringConfig.eventDetails_label_attendee} (${attendees.length})", fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 14),
            SizedBox(
              height: StringConfig.deviceHeight(context) / 7,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: attendees.length,
                itemBuilder: (content, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: StringConfig.deviceWidth(context) / 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: StringConfig.deviceHeight(context) / 70),
                          child: const CircleAvatar(backgroundImage: AssetImage("assets/images/user.png"), backgroundColor: Colors.transparent, radius: 30),
                        ),
                        GeneralText(text: attendees[index]['name'], fontSize: 16, fontWeight: FontWeight.bold)
                      ]
                    )
                  );
                }
              )
            ),
            GeneralText(text: StringConfig.eventDetails_label_details, fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 14),
            GeneralText(text: event.description, fontSize: 16)
          ]
        )
      )
    );
  }
}
