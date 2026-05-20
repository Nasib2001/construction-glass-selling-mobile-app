import 'package:flutter/material.dart';
import '../models/product.dart';

class AppStateProvider extends ChangeNotifier {
  // User Authentication State
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _userName = '';
  String get userName => _userName;

  String _userEmail = '';
  String get userEmail => _userEmail;

  String _companyName = '';
  String get companyName => _companyName;

  String _siteId = '';
  String get siteId => _siteId;

  String _safetyClearance = 'Level 1 Trainee';
  String get safetyClearance => _safetyClearance;

  // Completed safety dispatches (Order History)
  final List<Map<String, dynamic>> _dispatches = [];
  List<Map<String, dynamic>> get dispatches => _dispatches;

  // Shopping Cart: maps productId -> quantity
  final Map<String, int> _cart = {};
  Map<String, int> get cart => _cart;

  // Wishlist: holds productIds
  final Set<String> _wishlist = {};
  Set<String> get wishlist => _wishlist;

  // Search & Safety Categories
  String _selectedCategory = 'All Safety';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Sorting: 'Popular', 'Price Low-High', 'Price High-Low'
  String _sortBy = 'Popular';
  String get sortBy => _sortBy;

  // Selected face profile for Virtual Try-On
  int _selectedFaceIndex = 0;
  int get selectedFaceIndex => _selectedFaceIndex;

  // Active filters
  double _priceLimit = 250.0;
  double get priceLimit => _priceLimit;

  // Available Try-On Face Models
  final List<Map<String, String>> faceModels = [
    {
      'name': 'Alexander (Male)',
      'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=faces&q=80',
    },
    {
      'name': 'Sophia (Female)',
      'url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop&crop=faces&q=80',
    },
    {
      'name': 'Marcus (Safety/Athletic)',
      'url': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop&crop=faces&q=80',
    },
    {
      'name': 'Elena (Elegant)',
      'url': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=faces&q=80',
    },
  ];

  // Methods
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void setPriceLimit(double limit) {
    _priceLimit = limit;
    notifyListeners();
  }

  void setSelectedFaceIndex(int index) {
    if (index >= 0 && index < faceModels.length) {
      _selectedFaceIndex = index;
      notifyListeners();
    }
  }

  // Cart operations
  void addToCart(Product product, {int qty = 1}) {
    if (_cart.containsKey(product.id)) {
      _cart[product.id] = _cart[product.id]! + qty;
    } else {
      _cart[product.id] = qty;
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    if (_cart.containsKey(productId)) {
      final newQty = _cart[productId]! + delta;
      if (newQty <= 0) {
        _cart.remove(productId);
      } else {
        _cart[productId] = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  int getCartCount() {
    return _cart.values.fold(0, (sum, val) => sum + val);
  }

  double getCartTotal() {
    double total = 0.0;
    _cart.forEach((id, qty) {
      final prod = sampleProducts.firstWhere((p) => p.id == id, orElse: () => sampleProducts[0]);
      total += prod.price * qty;
    });
    return total;
  }

  // Wishlist operations
  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlist.contains(productId);
  }

  // Filter products based on search, category and price limit
  List<Product> getFilteredProducts() {
    List<Product> list = sampleProducts.where((p) {
      // ONLY use Construction glasses
      if (p.category != 'Construction') return false;

      // Filter by Safety Sub-Category
      bool matchesSubCategory = true;
      if (_selectedCategory == 'Ballistic Pro') {
        matchesSubCategory = p.id == 'c1';
      } else if (_selectedCategory == 'Anti-Glare') {
        matchesSubCategory = p.id == 'c2';
      } else if (_selectedCategory == 'Over-Specs') {
        matchesSubCategory = p.id == 'c3';
      } else if (_selectedCategory == 'Laminated Pro') {
        matchesSubCategory = p.id == 'c4';
      }

      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPrice = p.price <= _priceLimit;
      return matchesSubCategory && matchesSearch && matchesPrice;
    }).toList();

    if (_sortBy == 'Price Low-High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price High-Low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else {
      // Popular (Sorting by rating & reviews)
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  // Auth Operations
  void loginUser(String email, String password) {
    _isLoggedIn = true;
    _userEmail = email;
    _userName = email.split('@')[0].toUpperCase();
    _companyName = 'Apex Structural Masonry';
    _siteId = 'SITE-8709';
    _safetyClearance = 'Z87 Compliance Auditor';
    notifyListeners();
  }

  void signUpUser(String name, String email, String company, String siteId, String password) {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _companyName = company.isEmpty ? 'IronClad Builders Inc.' : company;
    _siteId = siteId.isEmpty ? 'SITE-4521' : siteId;
    _safetyClearance = 'Z87 Authorized Inspector';
    notifyListeners();
  }

  void logoutUser() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _companyName = '';
    _siteId = '';
    _safetyClearance = 'Level 1 Trainee';
    _cart.clear();
    _wishlist.clear();
    notifyListeners();
  }

  // Dispatch Checkout Operations
  void executeDispatch() {
    if (_cart.isEmpty) return;
    
    final orderId = 'DSP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final List<Map<String, dynamic>> itemsList = [];
    
    _cart.forEach((prodId, qty) {
      final p = sampleProducts.firstWhere((prod) => prod.id == prodId, orElse: () => sampleProducts[0]);
      itemsList.add({
        'product': p,
        'quantity': qty,
      });
    });
    
    _dispatches.insert(0, {
      'orderId': orderId,
      'date': DateTime.now().toString().split(' ')[0],
      'items': itemsList,
      'total': getCartTotal() + 8.50,
      'status': 'Packaging Z87 Gear',
    });
    
    _cart.clear();
    notifyListeners();
  }
}
