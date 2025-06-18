import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dm/userprofile.dart';
import 'package:dm/bill_entry.dart';
import 'package:dm/payment.dart';
import 'package:dm/purchase_page.dart';
import 'package:dm/all_bills_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'bill.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  List<Bill> bills = [];
  int _selectedIndex = 0;
  final List<String> imagePaths = [
    'assets/images/home1.jpg',
    'assets/images/home2.jpg',
    'assets/images/home3.jpg',
    'assets/images/home4.jpg',
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setupFCM();
    NotificationService.instance.listenToForegroundMessages();
    _loadBills();
    _startImageSlider();
  }

  void setupFCM() async {
    await NotificationService.instance.requestNotification();
    await NotificationService.instance.setupFlutterNotifications();

    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('New FCM Token: $newToken');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message);
    });
  }

  void _handleMessageNavigation(RemoteMessage message) {
    if (message.data['route'] == 'purchaseDetails') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PurchaseDetailsPage()),
      );
    } else if (message.data['route'] == 'payment') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()),
      );
    }
  }

  void _startImageSlider() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % imagePaths.length;
        });
        _startImageSlider();
      }
    });
  }

  Future<void> signout() async {
    await _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _sendFeedback() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Feedback Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFeedbackOption('Car Wash Service Feedback'),
              _buildFeedbackOption('Car Repair Service Feedback'),
              _buildFeedbackOption('General Inquiry Feedback'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedbackOption(String feedbackType) {
    return ListTile(
      title: Text(feedbackType),
      onTap: () async {
        final Uri feedbackUri = Uri.parse(
            'https://www.justdial.com/Vadodara/Dev-Motors-Subway-Lane-Opp-Osia-Mall-Gotri/0265PX265-X265-181025152438-Y6K5_BZDET');

        if (await canLaunchUrl(feedbackUri)) {
          await launchUrl(feedbackUri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch the feedback URL.')),
          );
        }

        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/919510704785');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp.')),
      );
    }
  }

  void _addBill(Bill bill) {
    setState(() {
      bills.add(bill);
    });
    _saveBills();
  }

  Future<void> _loadBills() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? billList = prefs.getStringList('bills');

    if (billList != null) {
      bills = billList.map((bill) {
        final Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(bill));
        return Bill.fromJson(json);
      }).toList();
      setState(() {});
    }
  }

  Future<void> _saveBills() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> billList =
        bills.map((bill) => jsonEncode(bill.toJson())).toList();
    await prefs.setStringList('bills', billList);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PurchaseDetailsPage()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaymentPage()));
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserProfilePage()));
    } else if (index == 4) {
      signout();
    }
  }

  Future<void> _scheduleService() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+919510704785', // Mechanic's phone number
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate the call.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light gray background
      appBar: AppBar(
        backgroundColor: Color(0xFF333333), // Dark gray
        elevation: 4,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/2.png'),
              radius: 30,
            ),
            SizedBox(width: 10),
            Text(
              'DevMotors',
              style: TextStyle(
                  color: const Color.fromARGB(
                      255, 202, 202, 202), // Mechanic theme color
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome User, ${user?.email ?? "Guest"}',
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333), // Dark gray for text
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: Image.asset(
                      imagePaths[_currentIndex],
                      key: ValueKey<int>(_currentIndex),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildButton(context, 'Add Bill', Icons.add, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BillEntry(onAddBill: _addBill)));
            }),
            SizedBox(height: 20),
            _buildButton(context, 'View All Bills', Icons.list, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllBillsView(
                    bills: bills,
                    onDeleteBill: (Bill bill) {
                      setState(() {
                        bills.remove(bill);
                      });
                      _saveBills();
                    },
                  ),
                ),
              );
            }),
            SizedBox(height: 20),
            _buildButton(context, 'Call to Schedule a Service', Icons.schedule,
                _scheduleService),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color(0xFF333333)),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
              backgroundColor: Color(0xFF333333)),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Payment',
              backgroundColor: Color(0xFF333333)),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              backgroundColor: Color(0xFF333333)),
          BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Sign Out',
              backgroundColor: Color(0xFF333333)),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor:
            const Color.fromARGB(255, 104, 104, 104), // Orange for buttons
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
