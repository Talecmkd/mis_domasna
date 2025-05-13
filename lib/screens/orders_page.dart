import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_domasna/screens/wishlist_page.dart';
import '../models/order.dart' as app_order;
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';

import '../widgets/bottom_nav_bar.dart';
import 'cart_page.dart';
import 'order_details_page.dart';
import '../utils/navigation_utils.dart';
import '../widgets/custom_loading_indicator.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // 'all', 'today', 'week', 'month'
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<app_order.Order> _filterOrders(List<app_order.Order> orders) {
    // First apply search filter
    var filteredOrders = orders.where((order) {
      final searchLower = _searchQuery.toLowerCase();
      return order.id.toLowerCase().contains(searchLower) ||
          order.products.any((product) =>
              product.name.toLowerCase().contains(searchLower));
    }).toList();

    // Then apply date filter
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'today':
        return filteredOrders.where((order) =>
          order.dateTime.year == now.year &&
          order.dateTime.month == now.month &&
          order.dateTime.day == now.day).toList();
      case 'week':
        final weekAgo = now.subtract(Duration(days: 7));
        return filteredOrders.where((order) =>
          order.dateTime.isAfter(weekAgo)).toList();
      case 'month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return filteredOrders.where((order) =>
          order.dateTime.isAfter(monthAgo)).toList();
      default:
        return filteredOrders;
    }
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          SizedBox(width: 8),
          _buildFilterChip('Today', 'today'),
          SizedBox(width: 8),
          _buildFilterChip('This Week', 'week'),
          SizedBox(width: 8),
          _buildFilterChip('This Month', 'month'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      selected: _selectedFilter == value,
      label: Text(label),
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
      },
      selectedColor: Color(0xFF4F964F).withOpacity(0.2),
      checkmarkColor: Color(0xFF4F964F),
      labelStyle: GoogleFonts.plusJakartaSans(
        color: _selectedFilter == value ? Color(0xFF4F964F) : Color(0xFF6C736B),
        fontWeight: _selectedFilter == value ? FontWeight.w600 : FontWeight.w400,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _selectedFilter == value ? Color(0xFF4F964F) : Color(0xFFE8F2E8),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search orders...',
          hintStyle: GoogleFonts.plusJakartaSans(
            color: Color(0xFF6C736B),
          ),
          prefixIcon: Icon(Icons.search, color: Color(0xFF6C736B)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Color(0xFF6C736B)),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Orders',
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: theme.colorScheme.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WishlistPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: StreamBuilder<List<app_order.Order>>(
              stream: _firestoreService.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CustomLoadingIndicator(
                      message: 'Loading orders...',
                    ),
                  );
                }

                if (snapshot.hasError) {
                  print('Error in OrdersPage: ${snapshot.error}');
                  if (snapshot.error.toString().contains('permission-denied')) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, size: 48, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            'Access Denied',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C170D),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You don\'t have permission to view orders',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: Color(0xFF6C736B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
          children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading orders',
                          style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C170D),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Color(0xFF6C736B),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {});  // Trigger a rebuild to retry
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4F964F),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
                      ],
                    ),
                  );
                }

                final orders = _filterOrders(snapshot.data ?? []);

                if (orders.isEmpty) {
                  if (_searchQuery.isNotEmpty || _selectedFilter != 'all') {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No orders yet',
                          style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your order history will appear here',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) => _buildOrderItem(context, orders[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: NavigationUtils.getIndexFromRoute('/orders'),
        onTap: (index) => NavigationUtils.handleNavigation(context, index),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, app_order.Order order) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsPage(order: order),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 93,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      order.products.first.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.surface,
                          child: Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(order.dateTime),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)} • ${order.products.length} ${order.products.length == 1 ? 'item' : 'items'}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
