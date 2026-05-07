import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../booking/booking_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<Map<String, dynamic>> _savedServices = [
    {
      'name': 'Dr. Ahmed Khan',
      'specialty': 'General Physician',
      'rating': '4.9',
      'price': 'Rs. 500',
      'color': const Color(0xFF6C63FF),
      'category': 'Doctors',
      'isSaved': true,
    },
    {
      'name': 'Style Studio',
      'specialty': 'Hair & Beauty Salon',
      'rating': '4.8',
      'price': 'Rs. 300',
      'color': const Color(0xFFFF6584),
      'category': 'Salon',
      'isSaved': true,
    },
    {
      'name': 'FitLife Gym',
      'specialty': 'Fitness & Workout',
      'rating': '4.7',
      'price': 'Rs. 800',
      'color': const Color(0xFF4CAF50),
      'category': 'Gym',
      'isSaved': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6C63FF),
                      Color(0xFF9C94FF),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Services ❤️',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your Favourites',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_savedServices.length} Saved',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List
            Expanded(
              child: _savedServices.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _savedServices.length,
                itemBuilder: (context, index) {
                  return _buildSavedCard(
                    _savedServices[index],
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCard(
      Map<String, dynamic> service,
      int index,
      ) {
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (service['color'] as Color)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getCategoryIcon(service['category']),
                color: service['color'] as Color,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['specialty'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service['rating'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service['price'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: service['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Remove from saved
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _savedServices.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Removed from saved!'),
                        backgroundColor: const Color(0xFFE53E3E),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFFF6584),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                // Book button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          serviceName: service['specialty'],
                          serviceProvider: service['name'],
                          price: service['price'],
                          specialty: service['specialty'],
                          category: service['category'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Salon':
        return Icons.content_cut_rounded;
      case 'Gym':
        return Icons.fitness_center_rounded;
      case 'Tutors':
        return Icons.school_outlined;
      case 'Vet':
        return Icons.pets_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6584).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_outline_rounded,
              size: 50,
              color: Color(0xFFFF6584),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Saved Services!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save your favourite services!',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}