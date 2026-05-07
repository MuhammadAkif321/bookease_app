import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../booking/booking_screen.dart';
import '../booking/my_appointments_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.grid_view_rounded, 'name': 'All'},
    {
      'icon': Icons.medical_services_outlined,
      'name': 'Doctors'
    },
    {'icon': Icons.content_cut_rounded, 'name': 'Salon'},
    {'icon': Icons.fitness_center_rounded, 'name': 'Gym'},
    {'icon': Icons.school_outlined, 'name': 'Tutors'},
    {'icon': Icons.pets_outlined, 'name': 'Vet'},
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Dr. Ahmed Khan',
      'specialty': 'General Physician',
      'rating': '4.9',
      'price': 'Rs. 500',
      'experience': '10 years',
      'color': const Color(0xFF6C63FF),
      'category': 'Doctors',
    },
    {
      'name': 'Style Studio',
      'specialty': 'Hair & Beauty Salon',
      'rating': '4.8',
      'price': 'Rs. 300',
      'experience': '5 years',
      'color': const Color(0xFFFF6584),
      'category': 'Salon',
    },
    {
      'name': 'FitLife Gym',
      'specialty': 'Fitness & Workout',
      'rating': '4.7',
      'price': 'Rs. 800',
      'experience': '8 years',
      'color': const Color(0xFF4CAF50),
      'category': 'Gym',
    },
    {
      'name': 'Dr. Sara Ali',
      'specialty': 'Dentist',
      'rating': '4.9',
      'price': 'Rs. 700',
      'experience': '7 years',
      'color': const Color(0xFF4299E1),
      'category': 'Doctors',
    },
    {
      'name': 'Prof. Usman',
      'specialty': 'Math & Science Tutor',
      'rating': '4.8',
      'price': 'Rs. 400',
      'experience': '6 years',
      'color': const Color(0xFFED8936),
      'category': 'Tutors',
    },
    {
      'name': 'PetCare Clinic',
      'specialty': 'Animal & Pet Care',
      'rating': '4.6',
      'price': 'Rs. 600',
      'experience': '4 years',
      'color': const Color(0xFF9C94FF),
      'category': 'Vet',
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    return _services.where((service) {
      final matchesSearch = service['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          service['specialty']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' ||
              service['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _currentIndex == 0
          ? SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildBanner(),
              _buildCategories(),
              _buildPopularServices(),
            ],
          ),
        ),
      )
          : _currentIndex == 1
          ? const MyAppointmentsScreen(
        showAppBar: false,
      )
          : _currentIndex == 3
          ? const ProfileScreen()
          : const Center(
        child: Text(
          'Coming Soon!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    return FadeInDown(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning! 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.displayName ?? 'Welcome!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: const Text(
                          '🔔 No new notifications!',
                        ),
                        backgroundColor:
                        const Color(0xFF6C63FF),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() => _currentIndex = 3);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFF6C63FF),
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

  Widget _buildSearchBar() {
    return FadeInDown(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: TextField(
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          decoration: InputDecoration(
            hintText: 'Search doctors, salons...',
            hintStyle: const TextStyle(
              color: Color(0xFF718096),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF6C63FF),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              onPressed: () {
                setState(() => _searchQuery = '');
              },
              icon: const Icon(
                Icons.clear_rounded,
                color: Color(0xFF718096),
              ),
            )
                : Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF6584),
              Color(0xFFFF8FA3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6584).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '20% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'On first appointment\nBook now!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const BookingScreen(
                            serviceName: 'General Checkup',
                            serviceProvider: 'Any Available',
                            price: 'Rs. 500',
                            specialty: 'General Service',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Color(0xFFFF6584),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategory ==
                      _categories[index]['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory =
                        _categories[index]['name'];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFF6C63FF)
                                  .withOpacity(0.1),
                              borderRadius:
                              BorderRadius.circular(16),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset:
                                  const Offset(0, 4),
                                ),
                              ]
                                  : null,
                            ),
                            child: Icon(
                              _categories[index]['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF6C63FF),
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _categories[index]['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFF2D3748),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularServices() {
    final filtered = _filteredServices;
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == 'All'
                      ? 'Popular Services'
                      : _selectedCategory,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(
                          () => _selectedCategory = 'All',
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            filtered.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 60,
                      color: Color(0xFF718096),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No services found!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final service = filtered[index];
                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.05),
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
                          color: service['color']
                              .withOpacity(0.1),
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: service['color'],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
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
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  service['rating'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.circle,
                                  size: 4,
                                  color:
                                  Color(0xFF718096),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  service['experience'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color:
                                    Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text(
                            service['price'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: service['color'],
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingScreen(
                                        serviceName: service[
                                        'specialty'],
                                        serviceProvider:
                                        service['name'],
                                        price: service['price'],
                                        specialty: service[
                                        'specialty'],
                                        category: service[
                                        'category'],
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets
                                  .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF6C63FF,
                                ),
                                borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                              ),
                              child: const Text(
                                'Book',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) =>
            setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: const Color(0xFF718096),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}