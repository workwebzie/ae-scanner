import 'package:ae_scanner_app/api/home/drop_down.dart';
import 'package:ae_scanner_app/api/home/faculty_controller.dart';
import 'package:ae_scanner_app/api/home/faculty_function.dart';
import 'package:ae_scanner_app/api/home/homeController.dart';
import 'package:ae_scanner_app/api/home/home_function.dart';
import 'package:ae_scanner_app/colors.dart';
import 'package:ae_scanner_app/login_page.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter RFID Web Listener',
      home: LoginPage(),
    );
  }
}

class RfidListenerScreen extends StatefulWidget {
  const RfidListenerScreen({super.key});

  @override
  State<RfidListenerScreen> createState() => _RfidListenerScreenState();
}

class _RfidListenerScreenState extends State<RfidListenerScreen> {
  HomeController homeController = Get.put(HomeController());

  // 1. Controller to capture the text entered by the RFID reader
  final TextEditingController _rfidController = TextEditingController();
     FacultyController facultyController = Get.put(FacultyController());
  // 2. FocusNode to ensure the input field is always selected (crucial for continuous scanning)
  final FocusNode _rfidFocusNode = FocusNode();

  String _lastScannedTag = 'Waiting for RFID tap...';
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    // Start listening and request focus when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("focus requested");
      _rfidFocusNode.requestFocus();
      fetchInitialData();
    });
  }

  fetchInitialData() async {
    await FacultyFunction.fnGetDepartments();
            items.value = facultyController.faculties
            .map(
              (i) => SearchItemModel(
                id: i.facultyId ?? "",
                name: i.facultyName ?? "",
              ),
            )
            .toList();
  }

  @override
  void dispose() {
    _rfidController.dispose();
    _rfidFocusNode.dispose();
    super.dispose();
  }

  final ValueNotifier<List<SearchItemModel>> items =
      ValueNotifier<List<SearchItemModel>>(<SearchItemModel>[]);

  Timer? _clearTimer;

  void _handleRfidTag(String tagId) {
    if (tagId.isEmpty) return;

    debugPrint('Tag Scanned: $tagId');

    // Cancel previous timer if a new tag comes quickly
    _clearTimer?.cancel();

    // Send tag to server
    _sendTagToServer(tagId);

    // Update last scanned tag
    setState(() {
      _lastScannedTag = tagId;
      _lastScanTime = DateTime.now();
    });

    // Start new 2-second clear timer
    _clearTimer = Timer(Duration(seconds: 4), () {
      setState(() {
        _lastScannedTag = "Waiting for RFID tap...";
        _lastScanTime = null;
      });
      homeController.studentData.value = null;
    });
  }

  // A helper function to simulate an API call (replace with actual logic)
  void _sendTagToServer(String tagId) {
    HomeFunction.markAttendance(tagId);
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
                  ],
                ),
                // backgroundColor: ThemeColors.background,
                child: Icon(Icons.restart_alt_outlined, color: Colors.white),
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
                  ],
                ),
                // backgroundColor: ThemeColors.background,
                child: Icon(Icons.exit_to_app, color: Colors.white),
              ),
            ),
          ),
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
                            color: ThemeColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<List<SearchItemModel>>(
                valueListenable:items,
                builder: (context, val, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: Get.width / 4,
                    child: SearchableDropdownDemo(
                      onSelected: (selectedItem) {
                        if (selectedItem == null) return;
                        facultyController.selectedFacultyID.value =
                            selectedItem.id;
                        // AttendanceFunction.fnAttendanceDetails(
                        //   selectedItem.id,
                        // );
                      },
                      mode:   "Faculty",
                      items: val,
                    ),
                  );
                },
              ),
                        // const Text(
                        //   'Ensure the RFID reader has focus on the input field below.',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(fontSize: 16, color: Colors.grey),
                        // ),
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
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _lastScannedTag,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _lastScannedTag.startsWith('Waiting')
                                        ? Colors.black54
                                        : Colors.teal,
                                  ),
                                ),
                                if (_lastScanTime != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Scan Time: ${_lastScanTime!.toLocal().toIso8601String().split('T').last.substring(0, 8)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
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
                      height: 300,
                      padding: EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        border: Border.all(color: ThemeColors.primaryBlue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "StudentDetails",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.primaryBlue,
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => homeController.studentData.value != null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: CircleAvatar(
                                                radius: 30,
                                                child: Image.asset(
                                                  "assets/images/man.png",
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                      Text(
                                                    "Student Name : ${homeController.studentData.value?.attendance?.studentName}",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Student ID : ${homeController.studentData.value?.attendance?.studentId}",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                              
                                                ],
                                              ),
                                            ),
                                            homeController
                                                        .studentData
                                                        .value
                                                        ?.action ==
                                                    "CLOCK_IN"
                                                ? Icon(
                                                    Icons.arrow_upward,
                                                    size: 100,
                                                    color: ThemeColors.green,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .arrow_downward_outlined,
                                                    size: 100,
                                                    color: ThemeColors.red,
                                                  ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              homeController
                                                          .studentData
                                                          .value
                                                          ?.action ==
                                                      "CLOCK_IN"
                                                  ? Icons.check
                                                  : Icons.close,
                                            ),
                                            Text(
                                              homeController
                                                          .studentData
                                                          .value
                                                          ?.action ==
                                                      "CLOCK_IN"
                                                  ? "Successfully Clocked in"
                                                  : "Successfully Clocked Out",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : NoDataWidget(),
                            ),
                          ),

                          // NoDataWidget()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),

              // Lottie.asset("assets/images/Girl meditating.json", height: 300),
              Opacity(
                opacity: 0.5,
                child: Image.asset("assets/images/logo.png", height: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height / 7,
            child: Lottie.asset("assets/images/Girl meditating.json"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text("No data found", style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
