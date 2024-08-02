// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class StringConfig {
  static const String color_turquoise = "#049bb6";
  static const String color_white = "#FFFFFF";
  static const String color_black = "#000000";
  static const String color_pink = "#f15d61";

  static double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double deviceWidth(BuildContext context)  => MediaQuery.of(context).size.width;

  // Dashboard
  static const String dashboard_title_event = "Events";
  static const String dashboard_label_noEvent = "No events added.";
  static const String dashboard_dialog_title = "Confirm Delete?";
  static const String dashboard_dialog_msg = "Are you sure you want to delete this event?";
  static const String dashboard_dialog_btnCancel = "Cancel";
  static const String dashboard_dialog_btnDelete = "Delete";

  // Event Form
  static const String eventForm_btnAdd = "Add Event";
  static const String eventForm_btnSave = "Save Changes";
  static const String eventForm_subTitle_create = "Let's create an event";
  static const String eventForm_subTitle_edit = "Edit your event details";
  static const String eventForm_label_eventName = "Event Name";
  static const String eventForm_label_date = "Date";
  static const String eventForm_label_location = "Location";
  static const String eventForm_label_description = "Description";
  static const String eventForm_errorMsg_eventName = "Please enter an event name";
  static const String eventForm_errorMsg_date = "Please enter a date";
  static const String eventForm_errorMsg_location = "Please enter a location";
  static const String eventForm_errorMsg_description = "Please enter a description";

  // Event Details
  static const String eventDetails_btnAttending = "Attending";
  static const String eventDetails_btnNotAttending = "Not Attending";
  static const String eventDetails_title = "Event Details";
  static const String eventDetails_label_attendee = "Attendees";
  static const String eventDetails_label_details = "Details";
}