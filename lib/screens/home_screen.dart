import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/admin_panel_screen.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/screens/order_history_screen.dart';
import 'package:ecommerce_app/screens/profile_screen.dart';
import 'package:ecommerce_app/widgets/notification_icon.dart';
import 'package:ecommerce_app/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userRole = 'user';
  String _userName = 'User';
  int _selectedIndex = 0; // ADDED: For bottom navigation
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ADDED: Bottom navigation pages
  List<Widget> get _pages => [
    _buildHomeContent(), // index 0 → Home with products
    const OrderHistoryScreen(), // index 1 → Orders
    const CartScreen(), // index 2 → Cart
    const ProfileScreen(), // index 3 → Profile
  ];

  Future<void> _fetchUserData() async {
    if (_currentUser == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (!mounted) return;
      if (doc.exists && doc.data() != null) {
        setState(() {
          _userRole = doc.data()!['role'] ?? 'user';
          _userName = doc.data()!['name'] ?? 'User';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      // APP BAR - FACEBOOK STYLE: Logo + Search + Icons
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        title: Row(
          children: [
            // LOGO - LEFT
            Image.asset(
              'assets/images/app_logo.png',
              height: 40,
            ),

            const SizedBox(width: 16),

            // SEARCH BAR - CENTER
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                      onPressed: _clearSearch,
                    )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _handleSearch,
                ),
              ),
            ),
          ],
        ),

        // ACTION BUTTONS - RIGHT SIDE
        actions: [
          // NOTIFICATION
          const NotificationIcon(),

          const SizedBox(width: 8),

          // ADMIN PANEL (Only show if admin)
          if (_userRole == 'admin')
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
              tooltip: 'Admin Panel',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminPanelScreen(),
                  ),
                );
              },
            ),
        ],
      ),

      // BODY - Uses bottom navigation
      body: _pages[_selectedIndex],

      // BOTTOM NAVIGATION BAR - Home, Orders, Cart, Profile
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3F51B5),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Add to Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'My Account',
          ),
        ],
      ),

      // FLOATING ACTION BUTTON - Contact Admin
      floatingActionButton: _userRole == 'user' && _currentUser != null
          ? StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('chats').doc(_currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!mounted) return const SizedBox.shrink();

          int unreadCount = 0;
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data();
            if (data != null) {
              unreadCount = (data as Map<String, dynamic>)['unreadByUserCount'] ?? 0;
            }
          }

          return Badge(
            label: Text('$unreadCount'),
            isLabelVisible: unreadCount > 0,
            child: FloatingActionButton.extended(
              icon: const Icon(Icons.support_agent),
              label: const Text('Contact Admin'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatRoomId: _currentUser!.uid,
                    ),
                  ),
                );
              },
            ),
          );
        },
      )
          : null,
    );
  }

  // HOME CONTENT - Products grid
  Widget _buildHomeContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!mounted) return const SizedBox.shrink();

        // Show search header when searching
        if (_searchQuery.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Search results for "$_searchQuery"',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: _buildProductGrid(snapshot)),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No products found. Add some in the Admin Panel!'),
          );
        }

        return _buildProductGrid(snapshot);
      },
    );
  }

  Widget _buildProductGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!mounted) return const SizedBox.shrink();

    final products = snapshot.data!.docs;

    // Filter products based on search query
    List<QueryDocumentSnapshot> filteredProducts = products;
    if (_searchQuery.isNotEmpty) {
      filteredProducts = products.where((doc) {
        final productData = doc.data() as Map<String, dynamic>;
        final productName = productData['name'].toString().toLowerCase();
        return productName.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_searchQuery.isNotEmpty && filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No products found for "$_searchQuery"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _clearSearch,
              child: const Text('Show all products'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final productDoc = filteredProducts[index];
        final productData = productDoc.data() as Map<String, dynamic>;

        final name = productData['name'] ?? 'No name';
        final price = (productData['price'] is num)
            ? (productData['price'] as num).toDouble()
            : 0.0;
        final imageUrl = productData['imageUrl'] ?? '';

        return ProductCard(
          productName: name,
          price: price,
          imageUrl: imageUrl,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productData: productData,
                  productId: productDoc.id,
                ),
              ),
            );
          },
        );
      },
    );
  }
}