import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Bill {
  final String watchName;
  final double totalAmount;
  final double monthlyPayment;
  final int totalInstallments;
  final int paidInstallments;
  final DateTime nextPaymentDate;

  Bill({
    required this.watchName,
    required this.totalAmount,
    required this.monthlyPayment,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.nextPaymentDate,
  });
}

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  final List<Bill> bills = [
    Bill(
      watchName: 'Omega Seamaster',
      totalAmount: 8500,
      monthlyPayment: 708.33,
      totalInstallments: 12,
      paidInstallments: 4,
      nextPaymentDate: DateTime.now().add(const Duration(days: 7)),
    ),
    Bill(
      watchName: 'Tag Heuer Carrera',
      totalAmount: 5200,
      monthlyPayment: 433.33,
      totalInstallments: 12,
      paidInstallments: 2,
      nextPaymentDate: DateTime.now().add(const Duration(days: 14)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Bills'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalDueCard(),
              const SizedBox(height: 20),
              const Text(
                'Active Installments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  return _buildBillCard(bills[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalDueCard() {
    double totalDue = bills.fold(
        0, (sum, bill) => sum + (bill.totalAmount - (bill.monthlyPayment * bill.paidInstallments)));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff004CFF), Color(0xff6B9DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Amount Due',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'RM${totalDue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(Bill bill) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bill.watchName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Monthly Payment', 'RM${bill.monthlyPayment.toStringAsFixed(2)}'),
                _buildInfoColumn('Next Payment',
                    DateFormat('MMM dd, yyyy').format(bill.nextPaymentDate)),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: bill.paidInstallments / bill.totalInstallments,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff004CFF)),
            ),
            const SizedBox(height: 8),
            Text(
              '${bill.paidInstallments}/${bill.totalInstallments} installments paid',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}