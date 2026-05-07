import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  // ─── USER METHODS ────────────────────────────

  // Save user data after register
  static Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUser(
      String uid,
      ) async {
    try {
      DocumentSnapshot doc =
      await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ─── BOOKING METHODS ─────────────────────────

  // Save new booking
  static Future<Map<String, dynamic>> saveBooking({
    required String serviceName,
    required String serviceProvider,
    required String date,
    required String time,
    required String amount,
    required String paymentMethod,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'Please login first!',
        };
      }

      // Create booking document
      DocumentReference docRef =
      await _db.collection('bookings').add({
        'userId': user.uid,
        'userName': user.displayName ?? 'User',
        'userEmail': user.email ?? '',
        'serviceName': serviceName,
        'serviceProvider': serviceProvider,
        'date': date,
        'time': time,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Booking saved successfully!',
        'bookingId': docRef.id,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to save booking!',
      };
    }
  }

  // Get user bookings
  static Stream<QuerySnapshot> getUserBookings() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  }

  // Get all bookings (admin)
  static Stream<QuerySnapshot> getAllBookings() {
    return _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update booking status (admin)
  static Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      await _db
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});
    } catch (e) {
      rethrow;
    }
  }

  // ─── SERVICE METHODS ─────────────────────────

  // Get all services
  static Stream<QuerySnapshot> getServices() {
    return _db
        .collection('services')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // Add default services (run once)
  static Future<void> addDefaultServices() async {
    try {
      List<Map<String, dynamic>> services = [
        {
          'name': 'Dr. Ahmed Khan',
          'specialty': 'General Physician',
          'rating': 4.9,
          'price': 'Rs. 500',
          'experience': '10 years',
          'category': 'Doctors',
          'available': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Style Studio',
          'specialty': 'Hair & Beauty Salon',
          'rating': 4.8,
          'price': 'Rs. 300',
          'experience': '5 years',
          'category': 'Salon',
          'available': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'FitLife Gym',
          'specialty': 'Fitness & Workout',
          'rating': 4.7,
          'price': 'Rs. 800',
          'experience': '8 years',
          'category': 'Gym',
          'available': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Dr. Sara Ali',
          'specialty': 'Dentist',
          'rating': 4.9,
          'price': 'Rs. 700',
          'experience': '7 years',
          'category': 'Doctors',
          'available': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var service in services) {
        await _db.collection('services').add(service);
      }
    } catch (e) {
      rethrow;
    }
  }
}