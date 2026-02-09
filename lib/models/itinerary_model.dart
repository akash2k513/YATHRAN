import 'package:flutter/material.dart';

class Itinerary {
  List<DayPlan> days;
  double totalCost;
  int totalTravelTime;

  Itinerary({
    required this.days,
    required this.totalCost,
    required this.totalTravelTime,
  });
}

class DayPlan {
  int day;
  DateTime date;
  List<Activity> activities;

  DayPlan({
    required this.day,
    required this.date,
    required this.activities,
  });
}

class Activity {
  String time;
  String name;
  String description;
  String location;
  String crowdLevel;
  double budget;
  int travelTime; // in minutes

  Activity({
    required this.time,
    required this.name,
    required this.description,
    required this.location,
    required this.crowdLevel,
    required this.budget,
    required this.travelTime,
  });
}