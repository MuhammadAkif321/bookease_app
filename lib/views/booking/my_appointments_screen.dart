import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class MyAppointmentsScreen extends StatefulWidget {
  final bool showAppBar;
  const MyAppointmentsScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<MyAppointmentsScreen> createState() =>
      _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState
    extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: widget.showAppBar
          ? AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Appointments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      )
          : PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          color: const Color(0xFF6C63FF),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    'My Appointments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList('pending'),
          _buildBookingsList('confirmed'),
          _buildBookingsList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    return StreamBuilder<QuerySnapshot>(
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
        final bookings = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final docStatus =
              data['status']?.toString() ?? 'pending';
          return docStatus == status;
        }).toList();

        if (bookings.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final data =
            bookings[index].data() as Map<String, dynamic>;
            return _buildAppointmentCard(
              data,
              bookings[index].id,
              index,
            );
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> data,
      String docId,
      int index,
      ) {
    Color statusColor;
    IconData statusIcon;
    String statusText = data['status'] ?? 'pending';

    switch (statusText) {
      case 'confirmed':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.check_circle_rounded;
        statusText = 'Confirmed';
        break;
      case 'cancelled':
        statusColor = const Color(0xFFE53E3E);
        statusIcon = Icons.cancel_rounded;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = const Color(0xFFED8936);
        statusIcon = Icons.pending_rounded;
        statusText = 'Pending';
    }

    return FadeInUp(
      delay: Duration(milliseconds: index * 100),
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF)
                              .withOpacity(0.1),
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF6C63FF),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['serviceProvider'] ??
                                  'Service Provider',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['serviceName'] ?? 'Service',
                              style: const TextStyle(
                                color: Color(0xFF718096),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              statusIcon,
                              color: statusColor,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        Icons.calendar_today_rounded,
                        data['date'] ?? 'N/A',
                      ),
                      _buildInfoItem(
                        Icons.access_time_rounded,
                        data['time'] ?? 'N/A',
                      ),
                      _buildInfoItem(
                        Icons.payments_rounded,
                        data['amount'] ?? 'N/A',
                      ),
                    ],
                  ),
                  if (data['status'] == 'pending') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await DatabaseService
                              .updateBookingStatus(
                            bookingId: docId,
                            status: 'cancelled',
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Appointment cancelled!',
                                ),
                                backgroundColor:
                                const Color(0xFFE53E3E),
                                behavior:
                                SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                          const Color(0xFFE53E3E),
                          side: const BorderSide(
                            color: Color(0xFFE53E3E),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          'Cancel Appointment',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6C63FF)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                size: 50,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Appointments Yet!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Book your first appointment now!',
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}