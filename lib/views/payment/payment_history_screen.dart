import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C63FF),
              ),
            );
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index].data()
              as Map<String, dynamic>;
              return _buildPaymentCard(data, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(
      Map<String, dynamic> data,
      int index,
      ) {
    final status = data['status'] ?? 'pending';
    Color statusColor;
    switch (status) {
      case 'confirmed':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'cancelled':
        statusColor = const Color(0xFFE53E3E);
        break;
      default:
        statusColor = const Color(0xFFED8936);
    }

    return FadeInUp(
      delay: Duration(milliseconds: index * 100),
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.receipt_rounded,
                color: Color(0xFF6C63FF),
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['serviceProvider'] ?? 'Provider',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    '${data['date']} • ${data['time']}',
                    style: const TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    data['paymentMethod'] ?? 'Cash',
                    style: const TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data['amount'] ?? 'Rs. 0',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 80,
            color: Color(0xFF718096),
          ),
          SizedBox(height: 16),
          Text(
            'No Payments Yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}