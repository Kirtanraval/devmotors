import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'bill.dart';

class AllBillsView extends StatelessWidget {
  final List<Bill> bills;

  AllBillsView({required this.bills});

  // Format date as dd/MM/yyyy
  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'All Bills',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 20),
              ...bills.map((bill) => pw.Container(
                    margin: pw.EdgeInsets.symmetric(vertical: 8),
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey),
                      borderRadius: pw.BorderRadius.circular(10),
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
                  ))
            ],
          );
        },
      ),
    );

    // Trigger download
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bills'),
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Using a blue accent color
        actions: [
          // Improved download button in AppBar with a tooltip
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: _downloadPdf,
            tooltip: 'Download Bills as PDF', // Tooltip for the icon
            color: Colors.white, // White icon for contrast
          ),
        ],
      ),
      body: bills.isEmpty
          ? const Center(
              child: Text(
                'No bills to show.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 12),
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
                          color: Colors.black87,
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
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      onTap: () {
                        // Add logic to navigate or show bill details if needed
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
