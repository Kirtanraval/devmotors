import 'package:flutter/material.dart';

class Tracking extends StatelessWidget {
  const Tracking({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample tracking data
    final trackingData = [
      'Order Placed',
      'Preparing Your Order',
      'Order Dispatched',
      'Out for Delivery',
      'Delivered',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: trackingData.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'), // Step number
                ),
                title: Text(trackingData[index]),
                subtitle: Text(
                    'Status: ${index == 0 ? 'Pending' : index == trackingData.length - 1 ? 'Completed' : 'In Progress'}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
