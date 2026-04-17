import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan_recovery_app/utils/app_colour.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../widget/visit_details.dart';

class CaseDetail extends StatefulWidget {

  final String status;
  final String caseID;
  final String customerName;
  final String amountDue;

  const CaseDetail({
    super.key,
    required this.status,
    required this.caseID,
    required this.customerName,
    required this.amountDue,
  });

  @override
  State<CaseDetail> createState() => _CaseDetailState();
}

Future<void> openMap() async {
  final Uri url = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=26.8467,80.9462",
  );

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw "Could not open map";
  }
}

class _CaseDetailState extends State<CaseDetail> {

  TextEditingController remarkController = TextEditingController();
  String savedRemark = "";
  bool isRemarkSaved = false;
  bool isDataSaved = false;
  bool _clicked  = false;
  bool _showVisitUI = false;
  DateTime? selectedDate;
  String selectedStatus = "";
  XFile? locationImage;
  XFile? paymentImage;
  String visitStatus = "Not Started Yet!";
  DateTime? completedDate;

  void _openBottomDatePicker() {
     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       builder: (context) {

         DateTime focusedDay = selectedDate ?? DateTime.now();
         DateTime? selectedDay = selectedDate ?? DateTime.now();

         return StatefulBuilder(
           builder: (context, setStateModal) {
             return SingleChildScrollView(
               child: Container(
                 padding: EdgeInsets.all(16),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [

                     TableCalendar(
                       firstDay: DateTime(2000),
                       lastDay: DateTime(2100),
                       focusedDay: focusedDay,
                       selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                       onDaySelected: (selected, focused) {
                         setStateModal(() {
                           selectedDay = selected;
                           focusedDay = focused;
                         });
                       },
                     ),

                     SizedBox(height: 10),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [

                         //Cancel
                         TextButton(
                             onPressed: (){
                               Navigator.pop(context);
                             },
                             child: Text("Cancel",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700, fontSize: 14),)
                         ),

                         // Done
                         SizedBox(
                           width: 100,
                           child: ElevatedButton(
                             onPressed: () {
                               setState(() {
                                 selectedDate = selectedDay;
                               });

                               Navigator.pop(context);
                             },
                             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
                             ),
                             child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w700),),
                           ),
                         )
                       ],
                     ),

                   ],
                 ),
               ),
             );
           },
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
                style: TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // 👈 center align
            children: [

              Text("🎉 Visit Ended Successfully", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
              ),
              SizedBox(height: 10),

              Text("You have successfully ended the recovery visit for\n$name (Case ID: $caseId)",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13),),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text("Case Details", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,color: Colors.white,),),
      ),

      body: SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Customer Information", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,),),
              SizedBox(height: 15),

              Row(
                children: [
                  Expanded(flex: 2, child: Text("Case ID:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                  ),
                  Expanded(flex: 2, child: Text(widget.caseID, style: TextStyle(fontSize: 14),),
                  ),
                ],
              ),
              SizedBox(height: 10),

              //Customer Name
              Row(
                children: [
                  Expanded(flex: 2, child: Text("Customer Name:",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                  ),
                  Expanded(flex: 2, child: Text(widget.customerName, style: TextStyle(fontSize: 14),),
                  ),
                ],
              ),
              SizedBox(height: 10),

              //Address
              Row(
                children: [
                  Expanded(flex: 2, child: Text("Address:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                  ),
                  Expanded(flex: 2, child: Text("Plot No. 5 Khurram Nagar Lucknow 226022",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                  ),
                ],
              ),

              // ViewMap Button
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 170,
                  child:  ElevatedButton(
                      onPressed:(){
                        openMap();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ViewMap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      child: Text("View on Map", style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w400),
                      )
                  ),
                ),
              ),

              // Dashed Divider
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: DashedDivider(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),

              // Recovery detail
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recovery Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),

                  InkWell(
                    onTap: () {
                      setState(() {
                        _clicked = !_clicked;
                      });
                    },
                    child: Icon(_clicked ? Icons.keyboard_arrow_up_sharp : Icons.keyboard_arrow_down_sharp,),
                  ),
                ],
              ),

              //  Expandable Content
              if (_clicked) ...[

                //Account Numbe
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(flex: 2, child: Text("Account Number:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(flex: 2, child: Text("1245893939", style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),

                // Amount
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 2, child: Text("Amount:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(flex: 2, child: Text(widget.amountDue, style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),

                // Bucket Status
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 2, child: Text("Bucket Status:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(flex: 2, child: Text("Overdue by 20days", style: TextStyle(fontSize: 14),),
                    ),
                  ],
                ),

                // Status
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 2, child: Text("Status:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(flex: 2, child: Text(widget.status, style: TextStyle(fontSize: 14,color: Color(0xffF02D30)),),
                    ),
                  ],
                ),

                // Visit Status
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 2, child: Text("Visit Status:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(flex: 2, child: Text(visitStatus,
                      style: TextStyle(fontSize: 14, color: visitStatus == "Completed" ? Colors.green : Colors.black,),
                    ),
                    ),
                  ],
                ),
                if (completedDate != null) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Completed Date:",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${completedDate!.day}/${completedDate!.month}/${completedDate!.year}",
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],

                // Next Follow Up-dat
                if (selectedDate != null) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Next Follow Up-date:",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            //  Date Text
                            Text(
                              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: TextStyle(fontSize: 14,color: AppColors.primary),
                            ),

                            SizedBox(width: 8),

                            //  Edit Icon
                            GestureDetector(
                              onTap: () {
                                _openBottomDatePicker();
                              },
                              child: Icon(Icons.edit, size: 18, color: Color(0xff6330C6),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                // Customer Status
                if (selectedStatus.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("Customer Status:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          selectedStatus,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],

                // Location Photo
                if (locationImage != null) ...[
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("Location Photo:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft, // 👈 control position
                          child: SizedBox(
                            width: 110,  // ✅ ab width control ho jayegi
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(locationImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

              ],


              // Start Visit Button  && open showDialog BOx
              SizedBox(height: 22),
              if(!_showVisitUI && !isDataSaved)...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    // open showDialog Box
                      onPressed: () {
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Icon(Icons.location_on, color: AppColors.location,size: 40,),
                                  SizedBox(height: 15),

                                  Text("Allow Your Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                                  SizedBox(height: 5),

                                  Text("This will your starting point",style: TextStyle(fontSize: 14,),),
                                  SizedBox(height: 15),

                                  //  CANCEL
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.grey.shade400, width: 1,),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400,),),
                                    ),
                                  ),
                                  SizedBox(height: 5),

                                  //  Yes, Allow
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // dialog band
                                        setState(() {
                                          _showVisitUI = true; // yaha magic
                                        });
                                      },

                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
                                      ),
                                      child: Text("Yes, Allow", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 14),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            );
                          },
                        );
                      },

                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.StartVisit,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
                      ),
                      child: Text("Start Visit", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),)
                  ),
                ),
              ],


              /// when tap the Yes Allow
              if (_showVisitUI)
                VisitDetailsWidget(
                  caseID: widget.caseID,          //  dynamic
                  customerName: widget.customerName, //  dynamic
                  onDataChanged: (date, status, image) {
                    setState(() {
                      isDataSaved = true;
                      selectedDate = date;
                      selectedStatus = status;
                      locationImage = image;
                    });
                  },

                  onStatusChanged: (status) {
                    setState(() {
                      visitStatus = status;
                      completedDate = DateTime.now(); // 🔥 save date
                    });
                  },

                  onComplete: () {
                    setState(() {
                      _showVisitUI = false; //  widget hide hoga, screen nahi
                    });
                  },
                ),


              // data saved from pyment details widigit
              SizedBox(height: 15),
              if(isDataSaved)...[

                Text("Remark",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),

                //  SHOW SAVED TEXT
                if (isRemarkSaved && savedRemark.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text(savedRemark,style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black),),
                ],

                //  TEXT FIELD TABHI DIKHE JAB SAVE NAHI HUA
                if (!isRemarkSaved) ...[
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: remarkController,
                      maxLines: 4,
                      maxLength: 120,
                      decoration: InputDecoration(
                        hintText: "Write here...",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        contentPadding: EdgeInsets.all(12),
                        counterStyle: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
                SizedBox(height: 15,),

                // Save now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isRemarkSaved) {
                        //  SAVE NOW
                        setState(() {
                          savedRemark = remarkController.text;
                          isRemarkSaved = true;
                        });
                      } else {
                        _showEndVisitBottomSheet();  //  END VISIT → OPEN BOTTOM SHEET
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRemarkSaved ? Color(0xFFFFBCBD) : AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isRemarkSaved ? "End Visit" : "Save Now",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isRemarkSaved ? Colors.red : Colors.white,),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

              ],

            ],
          ),
        ),
      )

    );
  }
}



/// for Divider
class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;

   DashedDivider({
    this.height = 1,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;   //  dash ki length
        const dashSpace = 4.0;   //  dash ke beech gap
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

