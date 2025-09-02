class Payment {
final String id;
final String studentId;
final double amount;
final DateTime dueDate;
final bool paid;


Payment({
required this.id,
required this.studentId,
required this.amount,
required this.dueDate,
required this.paid,
});
}