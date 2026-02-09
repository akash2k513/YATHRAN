import 'package:flutter/material.dart';
import 'package:yathran/screens/mood_selection_screen.dart';
import 'package:yathran/models/trip_model.dart';

class TripCreationScreen extends StatefulWidget {
  @override
  _TripCreationScreenState createState() => _TripCreationScreenState();
}

class _TripCreationScreenState extends State<TripCreationScreen> {
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  double _budget = 1000;
  String _tripType = 'Solo';
  final List<String> _tripTypes = ['Solo', 'Family', 'Friends', 'Couple'];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _proceedToMoodSelection() {
    if (_destinationController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    final trip = Trip(
      destination: _destinationController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      budget: _budget,
      tripType: _tripType,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodSelectionScreen(trip: trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Trip'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 30),

            // Destination
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'e.g., Paris, France',
              ),
            ),
            SizedBox(height: 20),

            // Dates
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _startDate != null
                                ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                : 'Select Date',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'Select Date',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Budget
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget: \$${_budget.toInt()}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Slider(
                    value: _budget,
                    min: 100,
                    max: 10000,
                    divisions: 99,
                    label: '\$${_budget.toInt()}',
                    onChanged: (value) {
                      setState(() => _budget = value);
                    },
                    activeColor: Color(0xFF4AB4DE),
                    inactiveColor: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$100'),
                      Text('\$10,000'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Trip Type
            Text(
              'Trip Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _tripTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _tripType == type,
                  onSelected: (selected) {
                    setState(() => _tripType = type);
                  },
                  selectedColor: Color(0xFF4AB4DE),
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: _tripType == type ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _proceedToMoodSelection,
                child: Text(
                  'Continue to Mood Selection',
                  style: TextStyle(fontSize: 18),
                ),
                // Line 243 - Update this:
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2F62A7), // Changed from primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}