import 'package:flutter/material.dart';
import 'bill.dart'; // Ensure you have the Bill model imported
import 'package:intl/intl.dart'; // For date formatting

class BillEntry extends StatefulWidget {
  final Function(Bill) onAddBill; // Function to add a bill

  BillEntry({required this.onAddBill});

  @override
  _BillEntryState createState() => _BillEntryState();
}

class _BillEntryState extends State<BillEntry> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Initialize with the current date

  // Format date as dd/MM/yyyy
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  // Method to select a date using a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked; // Update the selected date
      });
  }

  void _submitBill() {
    final String description = _descriptionController.text.trim();
    final double amount = double.tryParse(_amountController.text) ?? 0;

    if (description.isNotEmpty && amount > 0) {
      widget.onAddBill(Bill(
        description: description,
        amount: amount,
        date: _selectedDate,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill added successfully!')),
      );
      Navigator.of(context).pop(); // Close the BillEntry page
    } else {
      // Handle validation errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid description and amount.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Bill',
          style: TextStyle(
              color: Colors.white), // White text color for AppBar title
        ),
        backgroundColor:
            const Color.fromARGB(255, 68, 68, 68), // Orange color for AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Bill Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black color for title text
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black), // Black label text
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 2, // Allow multiple lines for description
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.black), // Black label text
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // Display the selected date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Date: $formattedDate",
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                OutlinedButton(
                  onPressed: () => _selectDate(context), // Call the date picker
                  style: OutlinedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    side: BorderSide(
                        color: const Color.fromARGB(
                            255, 0, 0, 0)), // Orange border color
                    padding: EdgeInsets.all(
                        10), // Padding to create a circular button
                  ),
                  child: const Text(
                    'Pick',
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 0, 0, 0)), // White text color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitBill,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                    const Color.fromARGB(255, 0, 0, 0), // Orange button
              ),
              child: const Text(
                'Submit Bill',
                style: TextStyle(color: Colors.white), // White text for button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
