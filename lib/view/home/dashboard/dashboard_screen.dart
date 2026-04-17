import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../model/customer_model.dart';
import '../../../utils/app_colour.dart';
import 'customer_information/all_customer_status.dart';
import 'customer_information/case_detail.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool isCheckedIn = false;
  bool showCheckInInDialog = true;

  String getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  List<CustomerModel> customerList = [
    CustomerModel(
      caseID: "1022",
      customerName: "Rahul Sharma",
      amountDue: "₹50,000",
      status: "Pending",
      overdueBy: "12 days",
    ),
    CustomerModel(
      caseID: "1023",
      customerName: "Amit Kumar",
      amountDue: "₹30,000",
      status: "Completed",
    ),
    CustomerModel(
      caseID: "1024",
      customerName: "Pankaj Verma",
      amountDue: "₹70,000",
      status: "Follow-ups",
      overdueBy: "12 days",
      followUpDate: "18 June, 25",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(color: AppColors.primary),
            child: Padding(padding: EdgeInsets.only(left: 22, right: 20, top: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SVG image for notification and
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left SVG
                      SvgPicture.asset('assets/icons/Category.svg',
                        width: 22,
                        height: 23,
                      ),
                      // Right SVG Using Badge
                      badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -4, end: -4), // top-right
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: Colors.red,       // 🔴 red color
                          padding: EdgeInsets.all(3),   // dot size
                        ),
                        child: SvgPicture.asset('assets/icons/notification.svg',
                          width: 22,
                          height: 23,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NetworkImage
                      SizedBox(width:15),
                      CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg',),
                        backgroundColor: Colors.grey[200],
                      ),

                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hii Vishal 👋", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white,),),
                            SizedBox(height: 6),

                            Text("Today 16 June, 25", style: TextStyle(fontSize: 12, color: Colors.white,),),
                            SizedBox(height: 12),

                            //  Mark Attendance Button
                            SizedBox(
                              width: isCheckedIn ? 150 : double.infinity,
                              child: ElevatedButton(

                                //  Show Dialog
                                onPressed: () {

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Mark your Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                            SizedBox(height: 10),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.watch_later_outlined, size: 12, color: Color(0xff999999)),
                                                SizedBox(width: 5),
                                                Text("Current Time", style: TextStyle(fontWeight: FontWeight.bold)),
                                                SizedBox(width: 5),
                                                Text(getCurrentTime(), style: TextStyle(fontWeight: FontWeight.bold),)
                                              ],
                                            ),

                                            SizedBox(height: 10),
                                            Divider(color: Color(0xffC7C7C7)),

                                            SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(text: "Today’s Status: ",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black,),
                                                children: [
                                                  TextSpan(text: isCheckedIn ? "Checked-In" : "Not Checked-In",
                                                    style: TextStyle(color: Color(0xff787878), fontSize: 14, fontWeight: FontWeight.bold,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            RichText(
                                              text: TextSpan(text: "Location Status: ",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black,),
                                                children: [
                                                  TextSpan(text: "GPS Active ", style: TextStyle(color: Color(0xff019918), fontWeight: FontWeight.bold,),
                                                  ),
                                                  WidgetSpan(alignment: PlaceholderAlignment.middle,
                                                    child: Icon(Icons.check, color: Color(0xff019918), size: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            // ❌ CANCEL
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            // ✅ CHECK-IN / CHECK-OUT
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {

                                                  setState(() {
                                                    //  TOGGLE LOGIC FIXED
                                                    isCheckedIn = !isCheckedIn;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,),
                                                child: Text(isCheckedIn ? "Check-Out" : "Check-In",
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },

                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 10,), // height increase
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                ),
                                child: Text(isCheckedIn ? "Check-Out" : "Mark Attendance",
                                  style: TextStyle(color: AppColors.primary, fontSize: 14,),
                                ),
                              ),
                            ),

                            SizedBox(height: 6),
                            Text("Tap to mark your check-in and start day", style: TextStyle(color: Colors.white, fontSize: 12,),)
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),
            )
          ),

         Expanded(
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   SizedBox(height: 20),

                   /// container of completed, pending, totalamount
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8),
                     child: IntrinsicHeight( // 👈 IMPORTANT (same height karega)
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.stretch, // 👈 full height
                         children: const [
                           StatCard(
                             value: "22",
                             label: "Completed Visits",
                             color: Color(0xFFECFAEC),
                           ),
                           StatCard(
                             value: "22",
                             label: "Pending Follow-ups",
                             color: Color(0xFFFCF1EA),
                           ),
                           StatCard(
                             value: "₹1,50,000",
                             label: "Total Amount Collected",
                             color: Color(0xFFE8F7FC),
                           ),
                         ],
                       ),
                     ),
                   ),

                   // Today Assign case
                   SizedBox(height: 20),
                   Padding(
                     padding: EdgeInsets.symmetric(horizontal: 16),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Text("Today’s Assigned Cases", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                             SizedBox(height: 3),
                             Text("“Cases prioritized for today's recovery”", style: TextStyle(fontSize: 12, color: Colors.black87),),
                           ],
                         ),

                         TextButton(
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerStatus()),
                             );
                           },
                           style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                           child: IntrinsicWidth(
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text("View All", style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500,),),
                                 SizedBox(height: 1),
                                 Container(height: 1.5, color: AppColors.primary,),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),

                   /// Widget for Customer Details
                   ListView.builder(
                     itemCount: customerList.length,
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     itemBuilder: (context, index) {
                       final customer = customerList[index];

                       return CustomerDetail(
                         caseID: customer.caseID,
                         customerName: customer.customerName,
                         amountDue: customer.amountDue,
                         status: customer.status,
                         Overdueby: customer.overdueBy,
                         followUpDate: customer.followUpDate,
                       );
                     },
                   )

                 ],
               ),
             )
         ),
        ],
      ),
    );
  }
}


// Widget of completed, pending, totalamount
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 13),
        decoration: BoxDecoration(color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
            SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }
}

// Widget for Customer Details
class CustomerDetail extends StatelessWidget {
  final String caseID;
  final String customerName;
  final String amountDue;
  final String status;
  final String? Overdueby;
  final String? followUpDate;

  const CustomerDetail({
    super.key,
    required this.caseID,
    required this.customerName,
    required this.amountDue,
    required this.status,
    this.Overdueby,
    this.followUpDate,
  });

  @override
  Widget build(BuildContext context) {

    final statusColorMap = {
      "Pending": AppColors.Pending,
      "Completed": AppColors.Completed,
      "Follow-ups": AppColors.Followups,
    };

    final color = statusColorMap[status] ?? Colors.red;

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CaseDetail(
          status: status,
          caseID: caseID,
          customerName: customerName,
          amountDue: amountDue,
        ),
      ),
        );
      },
      child: Container(
          width: double.infinity,
          constraints: BoxConstraints( minHeight: 200,), //  outer height bada
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(0xffF6F6F6),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Column(
            children: [

              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 160,),  // inner height bada
                padding: EdgeInsets.all(12), //  zyada space
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, //  center content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Case ID:", style: TextStyle(fontSize: 14, color: Colors.black),),

                        Text(caseID, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

                      ],
                    ),

                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Customer:", style: TextStyle(fontSize: 14, color: Colors.black),),

                        Text(customerName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

                      ],
                    ),

                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount Due:", style: TextStyle(fontSize: 14, color: Colors.black),),

                        Text(amountDue, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

                      ],
                    ),

                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status", style: TextStyle(fontSize: 14, color: Colors.black),),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1), //  badge background
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [

                              // 🔴🔵🟢 Badge Dot (dynamic)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle,),
                              ),

                              SizedBox(width: 6),
                              Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w500,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),

              SizedBox(height: 10,),
              Center(
                child: (status == "Completed" || status == "Paid")
                    ? RichText(
                  text: TextSpan(text: "Completed on: ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "24 June, 25",
                        style: TextStyle(color: AppColors.Completed, fontWeight: FontWeight.w500,),
                      ),
                    ],
                  ),
                )
                    : RichText(
                  text: TextSpan(style: TextStyle(color: Colors.black),
                    children: [
                      //  Overdue
                      TextSpan(text: "Overdue by: "),
                      TextSpan(text: Overdueby, style: TextStyle(color: AppColors.Pending, fontWeight: FontWeight.w500,),
                      ),

                      //  Follow-up (agar available hai)
                      if (followUpDate != null) ...[
                        TextSpan(text: "  |  "),
                        TextSpan(text: "Follow-ups: "),
                        TextSpan(text: followUpDate!,
                          style: TextStyle(color: AppColors.Followups, fontWeight: FontWeight.w500,),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            ],
          )


      ),
    );

  }
}
