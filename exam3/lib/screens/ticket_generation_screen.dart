import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TicketGenerationScreen extends StatefulWidget {
  const TicketGenerationScreen({super.key});

  @override
  State<TicketGenerationScreen> createState() => _TicketGenerationScreenState();
}

class _TicketGenerationScreenState extends State<TicketGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedPlace;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _numberOfPersons = 1;
  
  final List<Map<String, dynamic>> _touristPlaces = [
    {
      'name': 'Statue of Unity',
      'location': 'Kevadia',
      'price': 150.0,
      'description': 'World\'s tallest statue of Sardar Vallabhbhai Patel',
    },
    {
      'name': 'Somnath Temple',
      'location': 'Somnath',
      'price': 0.0,
      'description': 'Ancient temple dedicated to Lord Shiva',
    },
    {
      'name': 'Gir National Park',
      'location': 'Gir Forest',
      'price': 300.0,
      'description': 'Home to Asiatic lions',
    },
    {
      'name': 'Sabarmati Ashram',
      'location': 'Ahmedabad',
      'price': 50.0,
      'description': 'Gandhi\'s residence and museum',
    },
    {
      'name': 'Kutch Desert',
      'location': 'Bhuj',
      'price': 200.0,
      'description': 'Great Rann of Kutch salt desert',
    },
  ];

  String _generateTicketNumber() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    final randomNum = random.nextInt(999).toString().padLeft(3, '0');
    return 'GT$timestamp$randomNum';
  }

  double get _totalPrice {
    if (_selectedPlace == null) return 0.0;
    final place = _touristPlaces.firstWhere((p) => p['name'] == _selectedPlace);
    return place['price'] * _numberOfPersons;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange[700]!,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange[700]!,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _bookTicket() {
    if (_formKey.currentState!.validate()) {
      final ticketNumber = _generateTicketNumber();
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 28),
              const SizedBox(width: 8),
              const Text('Booking Confirmed!'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket Number: $ticketNumber',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTicketDetail('Place', _selectedPlace!),
                      _buildTicketDetail(
                        'Date', 
                        DateFormat('dd MMM yyyy').format(_selectedDate!),
                      ),
                      _buildTicketDetail(
                        'Time', 
                        _selectedTime!.format(context),
                      ),
                      _buildTicketDetail('Persons', _numberOfPersons.toString()),
                      _buildTicketDetail('Total Amount', '₹${_totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please save this ticket number for your records. You can show this at the venue.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: const Text('Book Another'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTicketDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedPlace = null;
      _selectedDate = null;
      _selectedTime = null;
      _numberOfPersons = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Book Tickets'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[600]!, Colors.orange[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.confirmation_number,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Book Your Adventure',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reserve your tickets for Gujarat\'s amazing destinations',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange[100],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Booking Form
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place Selection
                      const Text(
                        'Select Tourist Place',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPlace,
                        decoration: InputDecoration(
                          hintText: 'Choose a destination',
                          prefixIcon: const Icon(Icons.place),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: _touristPlaces.map((place) {
                          return DropdownMenuItem<String>(
                            value: place['name'],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${place['location']} - ₹${place['price'].toStringAsFixed(0)} per person',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPlace = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a tourist place';
                          }
                          return null;
                        },
                      ),

                      if (_selectedPlace != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            _touristPlaces.firstWhere(
                              (place) => place['name'] == _selectedPlace,
                            )['description'],
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Date Selection
                      const Text(
                        'Visit Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDate == null
                                    ? 'Select visit date'
                                    : DateFormat('dd MMM yyyy').format(_selectedDate!),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedDate == null
                                      ? Colors.grey[600]
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Time Selection
                      const Text(
                        'Preferred Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time),
                              const SizedBox(width: 12),
                              Text(
                                _selectedTime == null
                                    ? 'Select preferred time'
                                    : _selectedTime!.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedTime == null
                                      ? Colors.grey[600]
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Number of Persons
                      const Text(
                        'Number of Persons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[50],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '$_numberOfPersons person${_numberOfPersons > 1 ? 's' : ''}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: _numberOfPersons > 1
                                  ? () {
                                      setState(() {
                                        _numberOfPersons--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            IconButton(
                              onPressed: _numberOfPersons < 10
                                  ? () {
                                      setState(() {
                                        _numberOfPersons++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Total Amount
                      if (_selectedPlace != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${_totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Book Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _selectedPlace != null &&
                                  _selectedDate != null &&
                                  _selectedTime != null
                              ? _bookTicket
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Book Ticket',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Note: Tickets are non-refundable. Please arrive 30 minutes before your scheduled time.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}