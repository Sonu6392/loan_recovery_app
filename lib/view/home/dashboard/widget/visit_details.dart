import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../utils/app_colour.dart';


class VisitDetailsWidget extends StatefulWidget {

  final String caseID;
  final String customerName;
  final Function(DateTime?, String, XFile?) onDataChanged;
  final Function(String)? onStatusChanged;
  final Function(XFile?)? onImageChanged;
  final VoidCallback onComplete;

  const VisitDetailsWidget({
    super.key,
    required this.onDataChanged,
    required this.onComplete,
    this.onStatusChanged,
    this.onImageChanged,
    required this.caseID,
    required this.customerName,

  });

  @override
  State<VisitDetailsWidget> createState() => _VisitDetailsWidgetState();
}
class _VisitDetailsWidgetState extends State<VisitDetailsWidget> {

  Future<void> _openDatePicker() async {
    DateTime tempSelectedDate = selectedDate ?? DateTime.now();
    DateTime focusedDay = tempSelectedDate;

    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SizedBox(height: 10),

                      TableCalendar(
                        firstDay: DateTime(2000),
                        lastDay: DateTime(2100),
                        focusedDay: focusedDay,

                        selectedDayPredicate: (day) =>
                            isSameDay(tempSelectedDate, day),

                        onDaySelected: (selected, newFocused) {
                          setModalState(() {
                            tempSelectedDate = selected;
                            focusedDay = newFocused;
                          });
                        },

                        calendarFormat: CalendarFormat.month,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },

                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                        ),

                        rowHeight: 45,

                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(color: AppColors.primary),
                          weekendStyle: TextStyle(color: AppColors.primary),
                        ),

                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),

                          selectedDecoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),

                          todayTextStyle: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          SizedBox(width: 130),

                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedDate = tempSelectedDate;
                                });

                                widget.onDataChanged.call(tempSelectedDate, "", null); // instant parent update
                                widget.onDataChanged(selectedDate, selectedStatus, locationImage); // optional sync

                                Navigator.pop(bottomSheetContext);  // bottom sheet close

                                widget.onComplete(); //  pura VisitDetailsWidget close
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15,),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool isPaymentCompleted = false;
  bool isImageUploaded = false;
  DateTime? selectedDate;
  String selectedStatus = "";
  XFile? locationImage;
  final ImagePicker _picker = ImagePicker();

  void _pickLocationImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _picker.pickImage(source: ImageSource.camera);
                  if (img != null) {
                    setState(() {
                      locationImage = img;
                      isImageUploaded = true;
                    });
                    widget.onImageChanged?.call(img); // 🔥 instant send
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _picker.pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setState(() {
                      locationImage = img;
                      isImageUploaded = true;
                    });
                    widget.onImageChanged?.call(img);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //  LEFT SIDE VERTICAL LINE
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: Colors.grey.shade400,
          ),
        ),

        // TOP DOT
        Positioned(
          left: 6,
          top: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),

        // BOTTOM DOT
        Positioned(
          left: 6,
          bottom: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  Payment Section
              PaymentSectionWidget(
                caseID: widget.caseID,              // ✅ dynamic value
                customerName: widget.customerName, // ✅ dynamic value
                onCompleted: () {
                  setState(() {
                    isPaymentCompleted = true;
                  });
                },
                onStatusChanged: (status) {
                  widget.onStatusChanged?.call(status);
                },
              ),
              SizedBox(height: 20),


              //  Customer Status Section (FIXED)
              if (!isPaymentCompleted)
                CustomerStatusSectionWidget(
                  selectedDate: selectedDate,
                  locationImage: locationImage,
                  isImageUploaded: isImageUploaded,
                  onPickImage: _pickLocationImage,
                  onRemoveImage: () {
                    setState(() {
                      locationImage = null;
                      isImageUploaded = false;
                    });
                  },
                  onDateTap: () {
                    _openDatePicker();
                  },

                  onStatusChanged: (status) {
                    setState(() {
                      selectedStatus = status;
                    });
                  },

                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },

                  onImageChanged: (img) {
                    setState(() {
                      locationImage = img;
                    });
                  },

                ),
              SizedBox(height: 20),

              // End Visit Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       widget.onComplete();
              //     },
              //     child: Text("End Visit"),
              //   ),
              // )

            ],
          ),
        )

      ],
    );

  }
}



/// 1st Widget → PaymentSectionWidget
class PaymentSectionWidget extends StatefulWidget {
  final String caseID;
  final String customerName;
  final VoidCallback? onCompleted;
  final Function(String)? onStatusChanged;

  const PaymentSectionWidget({
    super.key,
    this.onCompleted,
    required this.caseID,
    required this.customerName,
    this.onStatusChanged,
  });

  @override
  State<PaymentSectionWidget> createState() => _PaymentSectionWidgetState();
}
class _PaymentSectionWidgetState extends State<PaymentSectionWidget> {

  bool isCompleted = false;
  bool isPaymentUploaded = false;
  String selectedPayment = "";
  XFile? paymentImage;
  final ImagePicker _picker = ImagePicker();

  void _pickPaymentImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _picker.pickImage(source: ImageSource.camera);
                  if (img != null) {
                    setState(() {
                      paymentImage = img;
                      isPaymentUploaded = true;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _picker.pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setState(() {
                      paymentImage = img;
                      isPaymentUploaded = true;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEndVisitBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Top indicator
              Container(
                width: 50,
                height: 6,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),

              Text("End Visit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              SizedBox(height: 10),

              Text("Are you sure you want to end this visit?", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
                  ),
                  child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black,fontSize: 14),),
                ),
              ),
              SizedBox(height: 10),

              // Yes End Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEndVisitDialog(widget.customerName, widget.caseID);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
                  ),
                  child: Text("Yes, End Visit", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEndVisitDialog(String name, String caseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, //  center align
            children: [

              Text("🎉 Visit Ended Successfully", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
              ),
              SizedBox(height: 10),

              Text("You have successfully ended the recovery visit for\n $name (Case ID: $caseId),",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check,color: Color(0xff008000), size: 16,),
                  Text("Payment proof uploaded", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check,color: Color(0xff008000), size: 16,),
                  Text("Visit Status Updated", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                ],
              ),
              SizedBox(height: 20),

              // Back to cases list Button (center)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                  ),
                  child: Text("Back to cases list", style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text("Starting Location", style: TextStyle(fontWeight:FontWeight.w400,fontSize: 16, color: AppColors.Followups)),
        SizedBox(height: 10,),

        Text("Urdu Academy sector 5 wave mall"),
        SizedBox(height: 22,),

        Text("Collected Amount",style: TextStyle(fontWeight:FontWeight.w600)),
        SizedBox(height: 11,),

        // Enter collected amount
        TextField(
          decoration: InputDecoration(
            hintText: "Enter collected amount",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400, // same color
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),

        if (!isCompleted)...[
          //  NORMAL UI (selection wala)
          Text("Select Payment Mode", style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 13),

          Row(
            children: [
              _box("Cash"),
              SizedBox(width: 10),
              _box("UPI"),
              SizedBox(width: 10),
              _box("Cheque"),
            ],
          ),
          SizedBox(height: 15),

          Text("Upload Payment Proof", style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isPaymentUploaded ? null : _pickPaymentImage,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: AppColors.primary,
              ),
              child: Text("Upload", style: TextStyle(color: Colors.white)),
            ),
          ),
          // Upload Image show
          if (paymentImage != null) ...[
            SizedBox(height: 10),

            Stack(
              children: [

                //  Image with rounded corner
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(paymentImage!.path),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                //  Close Button
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentImage = null;
                        isPaymentUploaded = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 10),

          // Mark as Completed Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:  (isPaymentUploaded && selectedPayment.isNotEmpty) ? () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // top indicator
                          Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          Text(
                            "Mark as Completed",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),

                          Text(
                            "Are you sure you want to complete this case?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                          SizedBox(height: 20),

                          // Cancel Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Cancel"),
                            ),
                          ),

                          SizedBox(height: 10),

                          // Yes Complete Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  isCompleted = true;
                                });
                                widget.onCompleted?.call();
                                widget.onStatusChanged?.call("Completed");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff6C2BD9), // purple
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Yes, Complete", style: TextStyle(color: Colors.white),),
                            ),
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.Completed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check,size: 18,color: Colors.white,),
                  SizedBox(width: 6,),
                  Text("Mark as Completed", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white,fontSize: 14),),
                ],
              ),

            ),
          ),
        ]

        else ...[
          //  COMPLETED UI (sirf result show karega)

          if (selectedPayment.isNotEmpty) ...[
            Text("Payment Mode", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Container(
              width: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff00A2DB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(selectedPayment,textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
            ),
            SizedBox(height: 15),
          ],

          if (paymentImage != null) ...[
            Text(" Upload Payment Proof", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(paymentImage!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
          ],

          // End Visit buton
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showEndVisitBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFBCBD),
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12),
                ),
              ),
              child: Text("End Visit", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xffF02D30),fontSize: 14),),

            ),
          ),

        ],

      ],
    );
  }

  Widget _box(String text) {
    bool isSelected = selectedPayment == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPayment = text; // ✅ ab kaam karega
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff00A2DB) : Colors.white,
            border: Border.all(
              color: isSelected
                  ? Color(0xff00A2DB)
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}



/// 2nd Widget → CustomerStatusSectionWidget
class CustomerStatusSectionWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final XFile? locationImage;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final VoidCallback onDateTap;
  final bool isImageUploaded;
  final Function(String)? onStatusChanged;
  final Function(DateTime?)? onDateChanged;
  final Function(XFile?)? onImageChanged;

  const CustomerStatusSectionWidget({
    super.key,
    required this.selectedDate,
    required this.locationImage,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onDateTap,
    required this.isImageUploaded,
    this.onStatusChanged,
    this.onDateChanged,
    this.onImageChanged,
  });

  @override
  State<CustomerStatusSectionWidget> createState() =>
      _CustomerStatusSectionWidgetState();
}
class _CustomerStatusSectionWidgetState extends State<CustomerStatusSectionWidget> {

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  final List<String> options = [
    "Not Available",
    "Skip",
    "Refused"
  ];

  void _toggleDropdown() {
    if (isDropdownOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: _getWidth(),
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0, 50),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options.map((e) {
                    return ListTile(
                      dense: true, //  height kam karega
                      visualDensity: VisualDensity(vertical: -3), // aur compact
                      title: Text(e),
                      onTap: () {
                        setState(() {
                          _controller.text = e;
                          isStatusSelected = true;
                        });

                        widget.onStatusChanged?.call(e); // instant send
                        _removeDropdown();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
    setState(() => isDropdownOpen = true);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => isDropdownOpen = false);
    }
  }

  double _getWidth() {
    final RenderBox renderBox =
    _fieldKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }

  @override
  void dispose() {
    _controller.dispose();
   // _removeDropdown();
    _overlayEntry?.remove(); //  sirf remove karo
    _overlayEntry = null;    //  cleanup

    super.dispose();
  }

  bool isStatusSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Status", style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 5),

        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            key: _fieldKey,
            child: TextFormField(
              readOnly: true,
              controller: _controller,
              onTap: _toggleDropdown,
              decoration: InputDecoration(
                hintText: "Select Status",

                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 12),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: Colors.grey.shade400),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: Colors.grey.shade400),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: Colors.grey.shade400),
                ),

                suffixIcon: Icon(
                  isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),

        // Upload Location Photo
        Text("Upload Location Photo",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
        SizedBox(height: 10),

        // Upload Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isStatusSelected && !widget.isImageUploaded)
                ? widget.onPickImage
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12),
                )
            ),
            child: Text("Upload",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w500),),
          ),
        ),
        SizedBox(height: 5),

        Text("Upload photo of location, you can upload only 1 photo",style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12,color: Colors.grey.shade500),),
        SizedBox(height: 10),

        //  Upload Button Image
        if (widget.locationImage != null) ...[
          SizedBox(height: 10),

          Stack(
            children: [

              //  Image with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(widget.locationImage!.path),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),

              //  Close Button
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: widget.onRemoveImage,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 15),

        //  Next Follow Up Date Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isStatusSelected ? widget.onDateTap : null, // 👈 disable logic

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12),
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.date_range, size: 18,color: Colors.white,),
                SizedBox(width: 6,),
                Text("Next Follow Up-date", style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),),
            ],
          ),
          ),
        ),
      ],
    );
  }
}

