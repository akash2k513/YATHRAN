import 'package:flutter/material.dart';
import 'package:yathran/screens/mood_selection_screen.dart';
import 'package:yathran/models/trip_model.dart';

class TripCreationScreen extends StatefulWidget {
  final Map<String, dynamic>? destinationData; // Add this parameter

  TripCreationScreen({this.destinationData}); // Add constructor

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

  @override
  void initState() {
    super.initState();

    // Auto-fill data if destinationData is provided
    if (widget.destinationData != null) {
      _destinationController.text = widget.destinationData!['name'] ?? '';

      // Parse budget from price range (e.g., "\$1,500-\$3,000")
      final priceRange = widget.destinationData!['priceRange'] ?? '';
      final priceMatch = RegExp(r'\$([\d,]+)').firstMatch(priceRange);
      if (priceMatch != null) {
        final priceStr = priceMatch.group(1)!.replaceAll(',', '');
        final price = double.tryParse(priceStr);
        if (price != null) {
          _budget = price;
        }
      }

      // Set default dates (next month)
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month + 1, 1);
      _endDate = DateTime(now.year, now.month + 1, 7);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now().add(Duration(days: 7))),
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

    // Create trip with optional destination data
    final trip = Trip(
      destination: _destinationController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      budget: _budget,
      tripType: _tripType,
      destinationData: widget.destinationData, // Pass along the destination data
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
        backgroundColor: Color(0xFF2F62A7),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show destination info if coming from trending
            if (widget.destinationData != null) ...[
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF4AB4DE).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF2F62A7)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Creating trip for:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2F62A7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.destinationData!['name'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A3E6D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.destinationData!['reason'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            Text(
              'Trip Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 20),

            // Destination
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.location_on, color: Color(0xFF2F62A7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4AB4DE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'e.g., Paris, France',
                filled: widget.destinationData != null,
                fillColor: widget.destinationData != null
                    ? Color(0xFFF0F8FF)
                    : Colors.transparent,
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2F62A7),
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