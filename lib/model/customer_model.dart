class CustomerModel {
  final String caseID;
  final String customerName;
  final String amountDue;
  final String status;
  final String? overdueBy;
  final String? followUpDate;

  CustomerModel({
    required this.caseID,
    required this.customerName,
    required this.amountDue,
    required this.status,
    this.overdueBy,
    this.followUpDate,
  });
}