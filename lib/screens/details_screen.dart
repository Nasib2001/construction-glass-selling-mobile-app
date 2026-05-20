import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../providers/app_state_provider.dart';
import '../widgets/glass_card.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  bool _isTryOnMode = false;
  late AnimationController _tryOnController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tryOnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _tryOnController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _tryOnController.dispose();
    super.dispose();
  }

  void _toggleTryOn(bool active) {
    setState(() {
      _isTryOnMode = active;
    });
    if (active) {
      _tryOnController.forward(from: 0.0);
    } else {
      _tryOnController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final isFav = state.isInWishlist(widget.product.id);
    final isConstruction = widget.product.category == 'Construction';
    final accentColor = isConstruction ? const Color(0xFFFF9E00) : const Color(0xFF00F0FF);

    return Scaffold(
      body: Stack(
        children: [
          // Background Color and subtle cyber glow
          Container(
            color: const Color(0xFF070B13),
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  left: -50,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.06),
                          blurRadius: 150,
                          spreadRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
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
                        'DEVICE PREVIEW',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          state.toggleWishlist(widget.product.id);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF1E293B),
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                isFav ? '${widget.product.name} removed from wishlist' : '${widget.product.name} added to wishlist',
                                style: const TextStyle(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.redAccent : Colors.white,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.04),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Primary Interactive Viewer (Standard Showcase OR Virtual Try-on)
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: _buildStandardShowcase(),
                          secondChild: _buildVirtualTryOnSimulator(state),
                          crossFadeState: _isTryOnMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        ),

                        // Interactive Try-On Trigger Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isTryOnMode ? 'VIRTUAL TRY-ON ACTIVE' : '3D PERSPECTIVE PREVIEW',
                                    style: TextStyle(
                                      color: accentColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _isTryOnMode ? 'Overlaying safety frame on template' : 'Explore high resolution details',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              // Glass-Style Toggle Switch
                              GestureDetector(
                                onTap: () => _toggleTryOn(!_isTryOnMode),
                                child: Container(
                                  width: 140,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: accentColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedAlign(
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeInOutCubic,
                                        alignment: _isTryOnMode ? Alignment.centerRight : Alignment.centerLeft,
                                        child: Container(
                                          width: 72,
                                          height: 38,
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: accentColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(color: accentColor, width: 1.5),
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 14),
                                          child: Text(
                                            'Spec',
                                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 14),
                                          child: Text(
                                            'Try-On',
                                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Specs/Ratings badges grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SAFETY SPECIFICATIONS',
                                style: GoogleFonts.orbitron(
                                  textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                childAspectRatio: 2.2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                children: [
                                  _buildSpecCard('BALLISTIC CERT', widget.product.specs[0], Icons.gavel_rounded, accentColor),
                                  _buildSpecCard('LENS TECHNOLOGY', widget.product.lensType.split(' ')[0], Icons.remove_red_eye_rounded, accentColor),
                                  _buildSpecCard('WEIGHT RATING', widget.product.weight, Icons.scale_rounded, accentColor),
                                  _buildSpecCard('FRAME MATERIAL', widget.product.frameMaterial.split(' ')[0], Icons.construction_rounded, accentColor),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Product Title, Description & features
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GlassCard(
                            fillGradientStart: Colors.white.withOpacity(0.04),
                            fillGradientEnd: Colors.white.withOpacity(0.01),
                            borderRadius: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.product.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 12),
                                          SizedBox(width: 4),
                                          Text(
                                            'IN STOCK',
                                            style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.product.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'CERTIFIED SAFEGUARD FEATURES',
                                  style: GoogleFonts.orbitron(
                                    textStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...widget.product.features.map((feature) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: accentColor.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.shield_rounded, color: accentColor, size: 12),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),

                        // Bottom Spacer
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar (Sticky at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.8),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'PROTECTION UNIT COST',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            state.addToCart(widget.product);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xFFFF9E00),
                                behavior: SnackBarBehavior.floating,
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${widget.product.name} dispatched to cart!',
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [accentColor, accentColor.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_shopping_cart_rounded, color: Colors.black, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'DISPATCH TO CART',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Standard Product View Gallery
  Widget _buildStandardShowcase() {
    return Container(
      height: 310,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'product-img-${widget.product.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.network(
                widget.product.imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Z87 specs overlay tag
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFFFF9E00), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    widget.product.specs[0],
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Live Virtual Try-On Simulator
  Widget _buildVirtualTryOnSimulator(AppStateProvider state) {
    final activeFace = state.faceModels[state.selectedFaceIndex];

    return Container(
      height: 310,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.3), width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selected Face Image background
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.network(
              activeFace['url']!,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // High-Tech Scanning Overlay Grid
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFF9E00).withOpacity(0.08),
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Real-time Glasses Fit Overlay
          ScaleTransition(
            scale: _scaleAnimation,
            child: _TryOnOverlay(productId: widget.product.id),
          ),

          // Scanning Tech indicator
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.redAccent, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'SIMULATION ACTIVE',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),

          // Face Selector Horizontal Carousel (Sticky overlay at bottom)
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: state.faceModels.length,
                itemBuilder: (context, idx) {
                  final isSel = idx == state.selectedFaceIndex;
                  return GestureDetector(
                    onTap: () {
                      state.setSelectedFaceIndex(idx);
                      _tryOnController.forward(from: 0.0);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFFF9E00).withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? const Color(0xFFFF9E00) : Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          state.faceModels[idx]['name']!.split(' ')[0],
                          style: TextStyle(
                            color: isSel ? const Color(0xFFFF9E00) : Colors.white70,
                            fontSize: 10,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Spec helper widget
  Widget _buildSpecCard(String label, String val, IconData icon, Color accent) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 14,
      fillGradientStart: Colors.white.withOpacity(0.04),
      fillGradientEnd: Colors.white.withOpacity(0.01),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white30, fontSize: 8, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  val,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Glassmorphic Safety Frame Overlay for Face Modeling
class _TryOnOverlay extends StatelessWidget {
  final String productId;

  const _TryOnOverlay({required this.productId});

  @override
  Widget build(BuildContext context) {
    if (productId == 'c1') {
      // IronClad Z87 Pro (Dark wrap-around temples with side shields)
      return SizedBox(
        width: 160,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left & Right Lenses (Transparent clear grey with glowing outline)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLens(left: true, color: Colors.white.withOpacity(0.12), borderColor: Colors.white.withOpacity(0.4)),
                const SizedBox(width: 6),
                _buildLens(left: false, color: Colors.white.withOpacity(0.12), borderColor: Colors.white.withOpacity(0.4)),
              ],
            ),
            // Bold black frame top bridge
            Positioned(
              top: 8,
              child: Container(
                width: 148,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1),
                ),
              ),
            ),
            // Nosepad bridge
            Positioned(
              bottom: 12,
              child: Container(
                width: 16,
                height: 10,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 2),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ),
            ),
            // Sporty wrap-around side shields
            Positioned(
              left: 0,
              child: _buildSideShield(left: true, color: const Color(0xFFFF9E00).withOpacity(0.25)),
            ),
            Positioned(
              right: 0,
              child: _buildSideShield(left: false, color: const Color(0xFFFF9E00).withOpacity(0.25)),
            ),
          ],
        ),
      );
    } else if (productId == 'c2') {
      // Sentinel Anti-Glare Shield (Amber-tinted semi-rimless)
      return SizedBox(
        width: 155,
        height: 54,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Amber Lenses
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLens(left: true, color: const Color(0xFFFF9E00).withOpacity(0.32), borderColor: const Color(0xFFFF9E00).withOpacity(0.5)),
                const SizedBox(width: 4),
                _buildLens(left: false, color: const Color(0xFFFF9E00).withOpacity(0.32), borderColor: const Color(0xFFFF9E00).withOpacity(0.5)),
              ],
            ),
            // Thin safety amber top bridge
            Positioned(
              top: 6,
              child: Container(
                width: 136,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9E00),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9E00).withOpacity(0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (productId == 'c3') {
      // Titan Over-Specs Goggles (Massive clear protective goggle wrap)
      return SizedBox(
        width: 174,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Massive outer shield mask
            Container(
              width: 166,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white10, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                      Container(width: 1, color: Colors.white10),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.white10],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Thick black gasket frame border
            Container(
              width: 172,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withOpacity(0.75), width: 3),
              ),
            ),
            // Elastic strap ends visible
            Positioned(
              left: -1,
              child: Container(width: 5, height: 16, color: Colors.black),
            ),
            Positioned(
              right: -1,
              child: Container(width: 5, height: 16, color: Colors.black),
            ),
          ],
        ),
      );
    } else {
      // SentrySafe Laminated Pro (c4) - Matte Carbon fiber top bridge, glowing teal/neon-green laminated lens
      return SizedBox(
        width: 162,
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Laminated double-glass teal/blue glowing lenses
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLens(
                  left: true,
                  color: const Color(0xFF00F0FF).withOpacity(0.16),
                  borderColor: const Color(0xFF00F0FF).withOpacity(0.65),
                ),
                const SizedBox(width: 5),
                _buildLens(
                  left: false,
                  color: const Color(0xFF00F0FF).withOpacity(0.16),
                  borderColor: const Color(0xFF00F0FF).withOpacity(0.65),
                ),
              ],
            ),
            // Heavy carbon-fiber top brow bar
            Positioned(
              top: 4,
              child: Container(
                width: 152,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
              ),
            ),
            // Central nose guard highlight
            Positioned(
              bottom: 10,
              child: Container(
                width: 14,
                height: 9,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.4), width: 1),
                ),
              ),
            ),
            // High visibility safety accents
            Positioned(
              left: 4,
              top: 12,
              child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFFF9E00), shape: BoxShape.circle)),
            ),
            Positioned(
              right: 4,
              top: 12,
              child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFFF9E00), shape: BoxShape.circle)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildLens({required bool left, required Color color, required Color borderColor}) {
    return Container(
      width: 68,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: left ? const Radius.circular(16) : const Radius.circular(6),
          topRight: left ? const Radius.circular(6) : const Radius.circular(16),
          bottomLeft: const Radius.circular(16),
          bottomRight: const Radius.circular(16),
        ),
        border: Border.all(color: borderColor, width: 1.5),
      ),
    );
  }

  Widget _buildSideShield({required bool left, required Color color}) {
    return Container(
      width: 12,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: left ? const Radius.circular(8) : Radius.zero,
          bottomLeft: left ? const Radius.circular(8) : Radius.zero,
          topRight: left ? Radius.zero : const Radius.circular(8),
          bottomRight: left ? Radius.zero : const Radius.circular(8),
        ),
      ),
    );
  }
}
