import 'package:ae_scanner_app/colors.dart';
import 'package:ae_scanner_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return   GetMaterialApp(
      title: 'Flutter RFID Web Listener',
      home: LoginPage()
    );
  }
}

class RfidListenerScreen extends StatefulWidget {
  const RfidListenerScreen({super.key});

  @override
  State<RfidListenerScreen> createState() => _RfidListenerScreenState();
}

class _RfidListenerScreenState extends State<RfidListenerScreen> {
  // 1. Controller to capture the text entered by the RFID reader
  final TextEditingController _rfidController = TextEditingController();
  // 2. FocusNode to ensure the input field is always selected (crucial for continuous scanning)
  final FocusNode _rfidFocusNode = FocusNode();

  String _lastScannedTag = 'Waiting for RFID tap...';
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    // Start listening and request focus when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rfidFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _rfidController.dispose();
    _rfidFocusNode.dispose();
    super.dispose();
  }

  // 🔔 THE CORE FUNCTION CALLED WHEN A TAG IS READ
  void _handleRfidTag(String tagId) {
    if (tagId.isEmpty) return;
    
    // --- 🎯 YOUR CUSTOM LOGIC GOES HERE ---
    
    debugPrint('Tag Scanned: $tagId');

    // Update the UI state
    setState(() {
      _lastScannedTag = tagId;
      _lastScanTime = DateTime.now();
    });

    // Example: Call a server-side API
    // _sendTagToServer(tagId);
    
    // ------------------------------------
  }
  
  // A helper function to simulate an API call (replace with actual logic)
  void _sendTagToServer(String tagId) {
    // You would use the 'http' package here in a real application
    // Example: 
    // http.post(Uri.parse('your_api_endpoint/scan'), body: {'rfid': tagId});
    debugPrint('Simulating sending $tagId to the server...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendease Class Scanner ',style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: ThemeColors.primaryBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Ready to Scan',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ensure the RFID reader has focus on the input field below.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // The invisible input field that captures the RFID data
              Container(
                width: 1.0, // Make the container very small
                height: 1.0,
                // Optional: You can make the input field invisible if preferred,
                // but keeping it visible helps with debugging focus issues.
                child: TextFormField(
                  controller: _rfidController,
                  focusNode: _rfidFocusNode,
                  autofocus: true, // Auto-focus on load
                  
                  // The crucial part: The reader typically sends the UID followed by an ENTER key.
                  // The ENTER key triggers the 'onFieldSubmitted' callback.
                  onFieldSubmitted: (String value) {
                    _handleRfidTag(value.trim());

                    // 1. Clear the input for the next scan
                    _rfidController.clear();
                    
                    // 2. CRITICAL: Request focus again immediately for continuous scanning
                    _rfidFocusNode.requestFocus(); 
                  },
                  keyboardType: TextInputType.none, // Hide virtual keyboard on mobile web
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                  ),
                  style: const TextStyle(color: Colors.transparent), // Hide the typed text
                ),
              ),
              
              const Icon(
                Icons.sensors_rounded,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 40),

              // Display the results
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Scanned UID:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _lastScannedTag,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _lastScannedTag.startsWith('Waiting') ? Colors.black54 : Colors.teal),
                      ),
                      if (_lastScanTime != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Scan Time: ${_lastScanTime!.toLocal().toIso8601String().split('T').last.substring(0, 8)}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}