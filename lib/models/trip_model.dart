import 'package:flutter/material.dart';

class Trip {
  String destination;
  DateTime startDate;
  DateTime endDate;
  double budget;
  String tripType;
  List<String> selectedMoods;
  List<Traveler> travelers;

  Trip({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.tripType,
    this.selectedMoods = const [],
    this.travelers = const [],
  });
}

class Traveler {
  String name;
  List<String> selectedInterests;
  String activityLevel;
  bool isCurrentUser;

  Traveler({
    required this.name,
    this.selectedInterests = const [],
    this.activityLevel = 'Medium',
    this.isCurrentUser = false,
  });
}