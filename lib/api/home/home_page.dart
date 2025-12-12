import 'package:ae_scanner_app/colors.dart';
import 'package:ae_scanner_app/login_page.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter RFID Web Listener',
        home: LoginPage());
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Attendease Class Scanner ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeColors.primaryBlue,
        actions: [
          Bounce(
            onTap: () {
              _rfidFocusNode.requestFocus();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeColors.primaryBlue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ]),
                // backgroundColor: ThemeColors.background,
                child: Icon(
                  Icons.restart_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Bounce(
            onTap: () {
              Get.offAll(LoginPage());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeColors.primaryBlue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ]),
                // backgroundColor: ThemeColors.background,
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Ready to Scan',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.primaryBlue),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Ensure the RFID reader has focus on the input field below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 40),

                        Container(
                          width: 1.0, // Make the container very small
                          height: 1.0,

                          child: TextFormField(
                            controller: _rfidController,
                            focusNode: _rfidFocusNode,
                            autofocus: true, // Auto-focus on load

                            onFieldSubmitted: (String value) {
                              _handleRfidTag(value.trim());

                              _rfidController.clear();

                              _rfidFocusNode.requestFocus();
                            },
                            keyboardType: TextInputType.none,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: false,
                            ),
                            style: const TextStyle(color: Colors.transparent),
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _lastScannedTag,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _lastScannedTag.startsWith('Waiting')
                                              ? Colors.black54
                                              : Colors.teal),
                                ),
                                if (_lastScanTime != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Scan Time: ${_lastScanTime!.toLocal().toIso8601String().split('T').last.substring(0, 8)}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                       
                    decoration: BoxDecoration(
                        border: Border.all(color: ThemeColors.primaryBlue),
                        borderRadius: BorderRadius.circular(
                          15,
                        )),
                    child: Column(
                      children: [Text("StudentDetails",  style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.primaryBlue),),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                          Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10,right: 10),
                                          child: CircleAvatar(
                                            radius: 30,
                                            child: Image.asset(
                                                "assets/images/man.png"),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Student ID :",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              "Student Name :",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(  Icons.check),
                                        Text(
                                           
                                              "Successfully Clocked in",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              // NoDataWidget()
                       
                               
                               ],
                    ),
                  ))
                ],
              ),
              Spacer(),

              // Lottie.asset("assets/images/Girl meditating.json", height: 300),
              Image.asset(
                "assets/images/kidasset.png",
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}


class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: Get.height / 7,
              child: Lottie.asset(
                "assets/images/Girl meditating.json",
              )),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              "No data found",
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}