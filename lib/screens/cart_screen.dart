import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state_provider.dart';
import '../models/product.dart';
import '../widgets/glass_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  void _triggerCheckout() async {
    setState(() {
      _isCheckingOut = true;
    });

    // Simulate securing transaction & warehouse dispatching
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      setState(() {
        _isCheckingOut = false;
      });

      final state = Provider.of<AppStateProvider>(context, listen: false);
      state.executeDispatch();

      // Show high-tech checkout success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(color: Color(0xFFFF9E00), width: 1.5),
              ),
              title: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9E00).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFFFF9E00),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SECURE DISPATCH CONFIRMED',
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: const Text(
                'Your safety equipment has been authorized for immediate shipment. A tracking confirmation has been sent to your secure dashboard.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back home
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9E00),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'RETURN TO CONTROL CENTER',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final cartItems = state.cart;
    final cartCount = state.getCartCount();

    return Scaffold(
      body: Stack(
        children: [
          // Cyber Space Background
          Container(
            color: const Color(0xFF070B13),
            child: Stack(
              children: [
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9E00).withOpacity(0.04),
                          blurRadius: 160,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Core Views
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom Navigation bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.04),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      Text(
                        'SECURE CART',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9E00).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.2)),
                        ),
                        child: Text(
                          '$cartCount UNITS',
                          style: const TextStyle(
                            color: Color(0xFFFF9E00),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Cart list
                Expanded(
                  child: cartItems.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          itemCount: cartItems.length,
                          itemBuilder: (context, idx) {
                            final productId = cartItems.keys.elementAt(idx);
                            final quantity = cartItems[productId]!;
                            final prod = sampleProducts.firstWhere(
                              (p) => p.id == productId,
                              orElse: () => sampleProducts[0],
                            );

                            return _buildCartItem(state, prod, quantity);
                          },
                        ),
                ),

                // Checkout Summary (Visible only when cart has items)
                if (cartItems.isNotEmpty) _buildCheckoutPanel(state),
              ],
            ),
          ),

          // Full Screen Loading overlay during dispatch authorization
          if (_isCheckingOut)
            Positioned.fill(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9E00)),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'AUTHORIZING DISPATCH PROTOCOLS...',
                            style: GoogleFonts.orbitron(
                              textStyle: const TextStyle(
                                color: Color(0xFFFF9E00),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Securing payment gateway & allocating inventory',
                            style: TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Cart item builder
  Widget _buildCartItem(AppStateProvider state, Product prod, int quantity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 20,
        fillGradientStart: Colors.white.withOpacity(0.04),
        fillGradientEnd: Colors.white.withOpacity(0.01),
        child: Row(
          children: [
            // Product photo
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                prod.imageUrl,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // Middle Description details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prod.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    prod.specs[0],
                    style: const TextStyle(
                      color: Color(0xFFFF9E00),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${prod.price.toStringAsFixed(2)} / unit',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Right interactive quantity adjusters
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(prod.price * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => state.updateQuantity(prod.id, -1),
                        icon: const Icon(Icons.remove, color: Colors.white70, size: 12),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => state.updateQuantity(prod.id, 1),
                        icon: const Icon(Icons.add, color: Color(0xFFFF9E00), size: 12),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful billing calculations and authorize checkout panel
  Widget _buildCheckoutPanel(AppStateProvider state) {
    final subtotal = state.getCartTotal();
    const delivery = 8.50;
    const auditFee = 0.00; // Z87 audit is free
    final total = subtotal + delivery + auditFee;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.9),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Price breakdowns
              _buildSummaryRow('EQUIPMENT SUB-TOTAL', '\$${subtotal.toStringAsFixed(2)}', false),
              const SizedBox(height: 8),
              _buildSummaryRow('SECURED DISPATCH & INSURED', '\$${delivery.toStringAsFixed(2)}', false),
              const SizedBox(height: 8),
              _buildSummaryRow('COMPLIANCE & Z87 AUDITING', 'FREE', true),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white10, height: 1),
              ),
              _buildSummaryRow('TOTAL COST', '\$${total.toStringAsFixed(2)}', false, isTotal: true),
              const SizedBox(height: 18),

              // Glowing Checkout Action button
              GestureDetector(
                onTap: _triggerCheckout,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9E00), Color(0xFFFFB703)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9E00).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: Colors.black, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'AUTHORIZE SECURE DISPATCH',
                          style: GoogleFonts.orbitron(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val, bool highlightVal, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white38,
            fontSize: isTotal ? 12 : 10,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            color: highlightVal
                ? const Color(0xFFFF9E00)
                : (isTotal ? const Color(0xFFFF9E00) : Colors.white),
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 11,
          ),
        ),
      ],
    );
  }

  // Empty cart visual layout
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: Colors.white24,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'CART IS CURRENTLY DEVOID OF GEAR',
            style: GoogleFonts.orbitron(
              textStyle: const TextStyle(
                color: Colors.white30,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select and customize safety eyewear from the catalog',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
