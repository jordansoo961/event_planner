// ignore_for_file: avoid_print

import 'package:event_planner/Config/string_config.dart';
import 'package:event_planner/Globals/general_text.dart';
import 'package:event_planner/event_details.dart';
import 'package:event_planner/event_form.dart';
import 'package:event_planner/models/event_model.dart';
import 'package:event_planner/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  final Box<Event>? testEventBox;
  const Dashboard({
    Key? key,
    this.testEventBox
  }) : super(key: key);

  @override
  DashboardState createState() => DashboardState();

  Future<void> addEvent(Event event) async {
    await DashboardState().addEvent(event);
  }
}

class DashboardState extends State<Dashboard> {
  late Box<Event> eventBox;

  @override
  void initState() {
    super.initState();
    eventBox = widget.testEventBox ?? Hive.box<Event>("eventDetails");
    fetchEventID();
  }

  Future<void> fetchEventID() async {
    try {
      var apiResponse = await ApiService().fetchEventID("2256668228513");

      setState(() {
        for (int i = 0; i < apiResponse['events'].length; i++) {
          fetchEventData(apiResponse['events'][i]['id']);
        }
      });
    }
    catch (e) {
      print("Error fetching event ID: $e");
    }
  }

  Future<void> fetchEventData(String eventID) async {
    try {
      Map<String, dynamic> apiResponse = await ApiService().fetchEventData(eventID);

      final apiEvent = Event(
        title: apiResponse['name']['text'],
        description: apiResponse['summary'],
        date: DateTime.parse(apiResponse['start']['local']),
        location: apiResponse['venue']['address']['address_1']
      );

      // Check if the event already exists in the box
      bool eventExists = eventBox.values.any((event) => event.title == apiEvent.title);

      if (!eventExists) addEvent(apiEvent);

    } catch (e) {
      print("Error fetching event data: $e");
    }
  }
  
  Future<void> addEvent(Event event) async {
    await eventBox.add(event);
    setState(() { });
  }

  updateEvent(int index, Event event) {
    eventBox.putAt(index, event);
    setState(() { });
  }

  navigateToAddEvent() async {
    final Event? newEvent = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EventFormScreen()
      )
    );

    if (newEvent != null) addEvent(newEvent);
  }

  Future<void> navigateToEditEvent(int index, Event event) async {
    final Event? editedEvent = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventFormScreen(event: event),
      ),
    );

    if (editedEvent != null) updateEvent(index, editedEvent);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: EdgeInsets.fromLTRB(StringConfig.deviceWidth(context) / 20, MediaQuery.of(context).padding.top, StringConfig.deviceWidth(context) / 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GeneralText(text: StringConfig.dashboard_title_event, textColor: HexColor(StringConfig.color_black), fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: eventBox.listenable(),
                builder: (context, Box<Event> box, _) {
                  if (box.isEmpty) {
                    return Center(
                      child: GeneralText(text: StringConfig.dashboard_label_noEvent, fontSize: 18),
                    );
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final event = box.getAt(index);

                      if (event is! Event) {
                        return const SizedBox.shrink(); // Handle non-Event objects gracefully
                      }
                      String formattedDate = DateFormat('MMM d, yyyy').format(event.date);
                
                      return Dismissible(
                        key: Key(event.title + event.date.toString()),
                        background: Container(
                          padding: EdgeInsets.all(StringConfig.deviceWidth(context) / 20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: HexColor(StringConfig.color_turquoise),
                                offset: const Offset(0.0, 1.0),
                                blurRadius: 3.0
                              )
                            ],
                            color: Colors.red,
                          ),
                          child: const Icon(Icons.delete, color: Colors.white)
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: GeneralText(text: StringConfig.dashboard_dialog_title),
                                content: GeneralText(text: StringConfig.dashboard_dialog_msg),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false), // Cancel
                                    child: GeneralText(text: StringConfig.dashboard_dialog_btnCancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      box.deleteAt(index);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GeneralText(text: "Event Deleted")));
                                    }, // Confirm
                                    child: GeneralText(text: StringConfig.dashboard_dialog_btnDelete),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EventDetailScreen(event: event, index: index),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(StringConfig.deviceWidth(context) / 20),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: HexColor(StringConfig.color_turquoise),
                                    offset: const Offset(0.0, 1.0),
                                    blurRadius: 3.0
                                  )
                                ],
                                color: HexColor(StringConfig.color_white)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GeneralText(text: formattedDate),
                                      GestureDetector(
                                        onTap: () => navigateToEditEvent(index, event),
                                        child: const Icon(Icons.edit, color: Colors.grey)
                                      )
                                    ],
                                  ),
                                  SizedBox(height: StringConfig.deviceHeight(context) / 100),
                                  GeneralText(text: event.title, fontSize: 24, fontWeight: FontWeight.bold),
                                  SizedBox(height: StringConfig.deviceHeight(context) / 100),
                                  GeneralText(text: event.description, fontSize: 16),
                                  SizedBox(height: StringConfig.deviceHeight(context) / 100),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: Icon(Icons.location_on, color: Colors.blue)
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Text(event.location, style: const TextStyle(color: Colors.grey))
                                      )
                                    ]
                                  )
                                ]
                              )
                            )
                          )
                        )
                      );
                    }
                  );
                }
              )
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddEvent,
        backgroundColor: HexColor(StringConfig.color_pink),
        child: const Icon(Icons.add)
      )
    );
  }
}