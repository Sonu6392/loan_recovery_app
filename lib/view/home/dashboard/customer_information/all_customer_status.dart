import 'package:flutter/material.dart';
import '../../../../model/customer_model.dart';
import '../../../../utils/app_colour.dart';
import 'case_detail.dart';

class CustomerStatus extends StatefulWidget {
  const CustomerStatus({super.key});

  @override
  State<CustomerStatus> createState() => _CustomerStatusState();
}

class _CustomerStatusState extends State<CustomerStatus> {

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

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Today’s Assigned Cases (10)", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),

      body: Padding(padding: EdgeInsetsGeometry.only(left: 10, right: 10, top: 20),
          child: Column(
          children: [
            Row(
              children: [

                //  Search Field
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search cases by account no. or customer name...",
                      hintStyle: TextStyle(fontSize: 12),

                      //  DEFAULT BORDER
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      //  NORMAL (grey border)
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),

                      //  FOCUS hone par
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                //  Filter Button
                InkWell(
                  onTap: () {},
                  child:  Container(
                      height: 57,
                      width: 53,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Icon(Icons.tune, color: AppColors.primary,size: 33,)
                  ),
                ),

              ],
            ),

            SizedBox(width: 10),
            Expanded(
                child: SingleChildScrollView(

                  /// Widget for Customer Details
                  child:  Column(
                    children: customerList.map((customer) {
                      return CustomerDetail(
                        caseID: customer.caseID,
                        customerName: customer.customerName,
                        amountDue: customer.amountDue,
                        status: customer.status,
                        Overdueby: customer.overdueBy,
                        followUpDate: customer.followUpDate,
                      );
                    }).toList(),
                  ),
                ),

            )

          ],
      ),
      )

    );
  }
}


/// Widget for Customer Details
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
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CaseDetail(
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
          constraints: BoxConstraints(
            minHeight: 200, //  outer height bada
          ),
          margin: EdgeInsets.symmetric(vertical: 10,),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(0xffF6F6F6),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Column(
            children: [

              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 170,),  // inner height bada
                padding: EdgeInsets.all(18), //  zyada space
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

                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Customer:", style: TextStyle(fontSize: 14, color: Colors.black),),

                        Text(customerName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

                      ],
                    ),

                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount Due:", style: TextStyle(fontSize: 14, color: Colors.black),),

                        Text(amountDue, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

                      ],
                    ),

                    SizedBox(height: 5,),
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
                                decoration: BoxDecoration(
                                  color: color, // 👈 SAME COLOR
                                  shape: BoxShape.circle,
                                ),
                              ),

                              SizedBox(width: 6),

                              // 🔹 Status Text
                              Text(
                                status,
                                style: TextStyle(
                                  color: color, // 👈 SAME COLOR
                                  fontWeight: FontWeight.w500,
                                ),
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
                  text: TextSpan(
                    text: "Completed on: ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "24 June, 25",
                        style: TextStyle(
                          color: AppColors.Completed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                    : RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [

                      //  Overdue
                      TextSpan(text: "Overdue by: "),
                      TextSpan(
                        text: Overdueby,
                        style: TextStyle(
                          color: AppColors.Pending,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // 🔥 Follow-up (agar available hai)
                      if (followUpDate != null) ...[
                        TextSpan(text: "  |  "),
                        TextSpan(text: "Follow-ups: "),
                        TextSpan(
                          text: followUpDate!,
                          style: TextStyle(
                            color: AppColors.Followups,
                            fontWeight: FontWeight.w500,
                          ),
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