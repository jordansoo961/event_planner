// lib/event_form.dart

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:event_planner/Config/string_config.dart';
import 'package:event_planner/Globals/general_text.dart';
import 'package:event_planner/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class EventFormScreen extends StatefulWidget {
  final Event? event;

  const EventFormScreen({super.key, this.event});

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final formKey = GlobalKey<FormState>();
  String 
    title = '',
    location = '',
    description = '';
  DateTime date = DateTime.now();
  TextEditingController 
    dateController = TextEditingController(),
    titleController = TextEditingController(),
    locationController = TextEditingController(),
    descController = TextEditingController(),
    startTimeController = TextEditingController(),
    endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.event?.title ?? '';
    locationController.text = widget.event?.location ?? '';
    descController.text = widget.event?.description ?? '';
    dateController.text = widget.event?.date == null ? '' : DateFormat('MMM d, yyyy').format(widget.event!.date);
  }

  submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var box = Hive.box<Event>("eventDetails");
      
      final newEvent = Event(
        title: title,
        date: date,
        location: location,
        description: description
      );

      await box.add(newEvent);
      Navigator.of(context).pop(newEvent);
    }
  }

  saveEvent() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final event = Event(title: title, date: date, location: location, description: description);
      Navigator.of(context).pop(event);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        dateController.text = DateFormat('MMM d, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.black)),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              padding: EdgeInsets.all(StringConfig.deviceHeight(context) / 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: HexColor(StringConfig.color_pink)
            ),
            onPressed: widget.event == null ? submitForm : saveEvent,
            child: GeneralText(text: widget.event == null ? StringConfig.eventForm_btnAdd : StringConfig.eventForm_btnSave, fontSize: 16)
          )
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GeneralText(text: widget.event == null ? StringConfig.eventForm_subTitle_create : StringConfig.eventForm_subTitle_edit, fontSize: 28, fontWeight: FontWeight.bold),
                  const SizedBox(height: 32),
                  textFormBuilder(context)
                ]
              )
            )
          )
        )
      )
    );
  }

  Widget textFormBuilder(BuildContext context) {
    var infoList = [
      {
        'label': StringConfig.eventForm_label_eventName,
        'controller': titleController,
        'icon': Icons.title,
        'errorMsg': StringConfig.eventForm_errorMsg_eventName,
        'type': "title"
      },
      {
        'label': StringConfig.eventForm_label_date,
        'controller': dateController,
        'icon': Icons.calendar_today,
        'errorMsg': StringConfig.eventForm_errorMsg_date,
        'type': "date"
      },
      {
        'label': StringConfig.eventForm_label_location,
        'controller': locationController,
        'icon': Icons.location_on,
        'errorMsg': StringConfig.eventForm_errorMsg_location,
        'type': "location"
      },
      {
        'label': StringConfig.eventForm_label_description,
        'controller': descController,
        'icon': Icons.description,
        'errorMsg': StringConfig.eventForm_errorMsg_description,
        'type': "description"
      }
    ];

    List<Widget> textBuilder = [];

    for (int i = 0; i < infoList.length; i++) {
      textBuilder.add(
        Column(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              onTap: () {
                if (infoList[i]['type'] == "date") selectDate(context);
              },
              controller: infoList[i]['controller'] as TextEditingController,
              decoration: InputDecoration(
                labelText: infoList[i]['label'].toString(),
                prefixIcon: Icon(infoList[i]['icon'] as IconData),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: HexColor(StringConfig.color_turquoise)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: HexColor(StringConfig.color_turquoise)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: HexColor(StringConfig.color_turquoise)),
                )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return infoList[i]['errorMsg'].toString();
                }
                return null;
              },
              readOnly: infoList[i]['type'] == "date" ? true : false,
              onSaved: (value) {
                if (infoList[i]['type'] == "title") {
                  setState(() => title = value!);
                }
                else if (infoList[i]['type'] == "location") {
                  setState(() => location = value!);
                }
                else if (infoList[i]['type'] == "description") {
                  setState(() => description = value!);
                }
              }
            )
          ]
        )
      );
    }

    return Column(
      children: textBuilder
    );
  }
}