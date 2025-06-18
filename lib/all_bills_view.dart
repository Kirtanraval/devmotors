import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For better date formatting
import 'package:pdf/pdf.dart'; // PDF package for creating PDFs
import 'package:pdf/widgets.dart' as pw; // PDF widgets
import 'package:printing/printing.dart'; // Printing package for layout and download
import 'bill.dart';

class AllBillsView extends StatelessWidget {
  final List<Bill> bills; // List of bills to display
  final Function(Bill) onDeleteBill; // Function to handle bill deletion

  AllBillsView({required this.bills, required this.onDeleteBill});

  // Format date as dd/MM/yyyy
  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Method to create and download the PDF
  Future<void> _downloadPdf() async {
    final pdf = pw.Document();

    // Add a page with the list of bills
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'All Bills',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              ...bills.map((bill) {
                return pw.Container(
                  margin: pw.EdgeInsets.symmetric(vertical: 8),
                  padding: pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Description: ${bill.description}',
                          style: pw.TextStyle(fontSize: 18)),
                      pw.Text('Amount: ₹${bill.amount.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 16)),
                      pw.Text('Date: ${_formattedDate(bill.date)}',
                          style: pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              })
            ],
          );
        },
      ),
    );

    // Trigger download
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Function to confirm deletion of a bill
  void _confirmDelete(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this bill?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                onDeleteBill(
                    bill); // Call the delete function passed from parent
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Bills',
          style: TextStyle(
              color: Colors.white), // Set "All Bills" text color to white
        ),
        backgroundColor: const Color.fromARGB(255, 195, 195, 195),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadPdf, // Call the download function
          ),
        ],
      ),
      body: bills.isEmpty
          ? Center(
              child: Text(
                'No bills added yet.',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 0, 0)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return Card(
                    color: const Color.fromARGB(255, 220, 220, 220),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        bill.description,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount: ₹${bill.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${_formattedDate(bill.date)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 255, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(
                              context, bill); // Show delete confirmation dialog
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
