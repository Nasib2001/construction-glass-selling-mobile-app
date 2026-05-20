import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state_provider.dart';
import '../widgets/glass_card.dart';

class LensSimulatorScreen extends StatefulWidget {
  final Product product;

  const LensSimulatorScreen({super.key, required this.product});

  @override
  State<LensSimulatorScreen> createState() => _LensSimulatorScreenState();
}

class _LensSimulatorScreenState extends State<LensSimulatorScreen> with TickerProviderStateMixin {
  late Product _currentProduct;
  String _activeEnvironment = 'Welding Sparks'; // Welding Sparks, Low-light Fog, Solar Glare, Dust Masonry
  double _splitRatio = 0.5; // Drag position (0.0 to 1.0)
  
  // Lens color tints
  late Color _lensTint;
  late Color _lensBorderColor;
  late String _tintDescription;

  // Particle systems for sparks and dust
  final List<_Particle> _particles = [];
  late AnimationController _animationController;
  late Timer _sparkTimer;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    _updateLensTint();

    // Loop for particle simulation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _animationController.addListener(() {
      _updateParticles();
    });

    _sparkTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (_activeEnvironment == 'Welding Sparks' && _particles.length < 40) {
        _spawnSpark();
      } else if (_activeEnvironment == 'Dust Masonry' && _particles.length < 50) {
        _spawnDust();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sparkTimer.cancel();
    super.dispose();
  }

  void _updateLensTint() {
    setState(() {
      if (_currentProduct.id == 'c1') {
        _lensTint = Colors.white.withOpacity(0.08);
        _lensBorderColor = Colors.white.withOpacity(0.5);
        _tintDescription = 'Clear Z87+ Anti-Fog Optical Shield';
      } else if (_currentProduct.id == 'c2') {
        _lensTint = const Color(0xFFFF9E00).withOpacity(0.24);
        _lensBorderColor = const Color(0xFFFF9E00).withOpacity(0.7);
        _tintDescription = 'Amber Gold High-Contrast Anti-Glare tint';
      } else if (_currentProduct.id == 'c3') {
        _lensTint = Colors.blue.withOpacity(0.12);
        _lensBorderColor = Colors.blue.withOpacity(0.6);
        _tintDescription = 'High-Contrast Extreme Impact Goggle Wrap';
      } else {
        _lensTint = const Color(0xFF00F0FF).withOpacity(0.16);
        _lensBorderColor = const Color(0xFF00F0FF).withOpacity(0.75);
        _tintDescription = 'Laminated Polarized Teal Shatterproof Shield';
      }
    });
  }

  void _spawnSpark() {
    // Generate sparks centered slightly to the left (unfiltered side)
    double startX = MediaQuery.of(context).size.width * 0.25;
    double startY = 150 + _random.nextDouble() * 60;
    
    setState(() {
      _particles.add(
        _Particle(
          x: startX,
          y: startY,
          vx: (_random.nextDouble() - 0.5) * 6,
          vy: -_random.nextDouble() * 5 - 2,
          color: _random.nextBool() ? const Color(0xFFFF6B00) : const Color(0xFFFFD000),
          radius: _random.nextDouble() * 3.5 + 1.5,
          life: 1.0,
          decay: _random.nextDouble() * 0.04 + 0.02,
          isSpark: true,
        ),
      );
    });
  }

  void _spawnDust() {
    double screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _particles.add(
        _Particle(
          x: _random.nextDouble() * screenWidth,
          y: _random.nextDouble() * 260,
          vx: (_random.nextDouble() - 0.5) * 1.5,
          vy: _random.nextDouble() * 1.2 + 0.4,
          color: Colors.grey.withOpacity(0.4),
          radius: _random.nextDouble() * 5 + 2,
          life: 1.0,
          decay: _random.nextDouble() * 0.02 + 0.005,
          isSpark: false,
        ),
      );
    });
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        _particles[i].x += _particles[i].vx;
        _particles[i].y += _particles[i].vy;
        
        if (_particles[i].isSpark) {
          // Gravity pull on hot sparks
          _particles[i].vy += 0.15; 
        }

        _particles[i].life -= _particles[i].decay;
        if (_particles[i].life <= 0 || _particles[i].y > 300 || _particles[i].x < 0 || _particles[i].x > MediaQuery.of(context).size.width) {
          _particles.removeAt(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic cyber backdrop
          Positioned.fill(
            child: Container(
              color: const Color(0xFF060913),
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    right: -100,
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9E00).withOpacity(0.04),
                            blurRadius: 160.0,
                            spreadRadius: 40.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main scrolling viewport
          SafeArea(
            child: Column(
              children: [
                // Top controls bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                        'Z87+ LENS CALIBRATOR',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9E00).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.lens_blur_rounded, color: Color(0xFFFF9E00), size: 18),
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
                        // Brief tag introduction
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DYNAMIC FILTER COMPARISON',
                                style: TextStyle(
                                  color: const Color(0xFFFF9E00),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Test safety lens performance directly in simulated environments. Drag the Z87 slider key to contrast unfiltered threats with optimized, clear safeguard vision.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 11,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Interactive Before / After Visual Simulator Card
                        _buildVisualComparisonCard(size),

                        // Workplace conditions tabs selector
                        _buildEnvironmentTabs(),

                        // Dynamic explanation card
                        _buildExplanationCard(state),

                        // Spec highlight panels
                        _buildSpecsPanel(),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom sticky purchase/dispatch bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomStickyPanel(context, state),
          ),
        ],
      ),
    );
  }

  // Visual drag comparison simulator
  Widget _buildVisualComparisonCard(Size size) {
    double containerHeight = 280;

    return Container(
      height: containerHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // -------------------------------------------------------------
            // LAYER 1: Raw Unfiltered Hazard State (Full Background)
            // -------------------------------------------------------------
            Positioned.fill(child: _buildUnfilteredBackground()),

            // -------------------------------------------------------------
            // LAYER 2: Z87 Protected Safeguard Filtered State (Clipped right side)
            // -------------------------------------------------------------
            Positioned.fill(
              child: ClipPath(
                clipper: _HorizontalSplitClipper(_splitRatio),
                child: Stack(
                  children: [
                    // Z87 Filtered workspace background
                    _buildFilteredBackground(),
                    // Highlight Z87+ laser watermark
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9E00).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFF9E00), width: 1),
                        ),
                        child: const Text(
                          'Z87+ OPTICAL COATING ACTIVE',
                          style: TextStyle(color: Color(0xFFFF9E00), fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -------------------------------------------------------------
            // LAYER 3: Particles overlays (sparks/dust)
            // -------------------------------------------------------------
            CustomPaint(
              size: Size(double.infinity, containerHeight),
              painter: _ParticlePainter(particles: _particles, splitRatio: _splitRatio),
            ),

            // -------------------------------------------------------------
            // LAYER 4: Interactive drag divider caliper bar
            // -------------------------------------------------------------
            Positioned(
              top: 0,
              bottom: 0,
              left: (size.width - 40) * _splitRatio,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  double screenWidth = size.width - 40;
                  setState(() {
                    _splitRatio = (details.localPosition.dx / screenWidth).clamp(0.02, 0.98);
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 3,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9E00),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9E00).withOpacity(0.8),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    // Centered high-tech handle grip
                    Positioned(
                      child: Container(
                        width: 32,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFF9E00), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9E00).withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.swap_horizontal_circle_outlined,
                            color: Color(0xFFFF9E00),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Holographic before/after indicator texts
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                color: Colors.black45,
                child: const Text('HAZARD ZONE', style: TextStyle(color: Colors.redAccent, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                color: Colors.black45,
                child: const Text('Z87+ COATING', style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Raw, hazardous unfiltered view
  Widget _buildUnfilteredBackground() {
    switch (_activeEnvironment) {
      case 'Welding Sparks':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.centerLeft,
              radius: 1.2,
              colors: [
                Color(0xFFFF9E00),
                Color(0xFF1E293B),
                Color(0xFF0F172A),
              ],
            ),
          ),
          child: const Center(
            child: Icon(Icons.flash_on_rounded, color: Colors.yellow, size: 48),
          ),
        );
      case 'Low-light Fog':
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: const Color(0xFF334155),
            child: Center(
              child: Icon(Icons.visibility_off_rounded, color: Colors.white.withOpacity(0.4), size: 48),
            ),
          ),
        );
      case 'Solar Glare':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.4, -0.4),
              radius: 1.0,
              colors: [
                Colors.white,
                Color(0xFFFFEEB2),
                Color(0xFF1E293B),
              ],
            ),
          ),
          child: const Center(
            child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 70),
          ),
        );
      case 'Dust Masonry':
        return Container(
          color: const Color(0xFF451A03),
          child: Center(
            child: Icon(Icons.blur_linear_rounded, color: Colors.white.withOpacity(0.2), size: 48),
          ),
        );
      default:
        return Container(color: Colors.grey);
    }
  }

  // Z87 protected filtered view
  Widget _buildFilteredBackground() {
    Widget coreBackground;

    switch (_activeEnvironment) {
      case 'Welding Sparks':
        // Extremely filtered green/gold contrast, sparks are dimmed down to non-blinding shapes
        coreBackground = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1B4D3E).withOpacity(0.8),
                const Color(0xFF022C22).withOpacity(0.9),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, color: Colors.greenAccent.withOpacity(0.6), size: 40),
                const SizedBox(height: 4),
                const Text(
                  'Auto-Dim Arc Suppressed',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        break;
      case 'Low-light Fog':
        // Crisp clarity, zero blur, high-contrast yellow tint
        coreBackground = Container(
          color: const Color(0xFF0F172A),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.remove_red_eye_rounded, color: Colors.amberAccent, size: 36),
                const SizedBox(height: 4),
                const Text(
                  'Condensation Shield Active',
                  style: TextStyle(color: Colors.amberAccent, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        break;
      case 'Solar Glare':
        // Polarized tint reduces glare reflection
        coreBackground = Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A0E1A),
                Color(0xFF1E293B),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.brightness_low_rounded, color: const Color(0xFF00F0FF).withOpacity(0.8), size: 36),
                const SizedBox(height: 4),
                const Text(
                  'Anti-UV Polarized Filter',
                  style: TextStyle(color: Color(0xFF00F0FF), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        break;
      case 'Dust Masonry':
        // Zero dust visual block, crystal clear seal
        coreBackground = Container(
          color: const Color(0xFF020617),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gavel_rounded, color: const Color(0xFFFF9E00).withOpacity(0.8), size: 36),
                const SizedBox(height: 4),
                const Text(
                  'Hermetic Sealed Air Gasket',
                  style: TextStyle(color: Color(0xFFFF9E00), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        break;
      default:
        coreBackground = Container(color: Colors.grey);
    }

    // Apply the active physical safety lens tint overlay over the environment
    return Stack(
      children: [
        Positioned.fill(child: coreBackground),
        // Active safety glass lens tint
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: _lensTint,
              border: Border.all(color: _lensBorderColor.withOpacity(0.2), width: 1),
            ),
          ),
        ),
      ],
    );
  }

  // Worksite environments tabs bar selector
  Widget _buildEnvironmentTabs() {
    final list = [
      {'name': 'Welding Sparks', 'icon': Icons.flash_on_rounded},
      {'name': 'Low-light Fog', 'icon': Icons.blur_linear_rounded},
      {'name': 'Solar Glare', 'icon': Icons.wb_sunny_rounded},
      {'name': 'Dust Masonry', 'icon': Icons.engineering_rounded},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: list.map((env) {
          final isSel = _activeEnvironment == env['name'];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeEnvironment = env['name'] as String;
                  _particles.clear(); // Flush previous system
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFFFF9E00).withOpacity(0.12) : Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSel ? const Color(0xFFFF9E00).withOpacity(0.6) : Colors.white.withOpacity(0.06),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(env['icon'] as IconData, color: isSel ? const Color(0xFFFF9E00) : Colors.white60, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      env['name'] as String,
                      style: TextStyle(
                        color: isSel ? const Color(0xFFFF9E00) : Colors.white70,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Explanation description
  Widget _buildExplanationCard(AppStateProvider state) {
    String highlightTitle;
    String highlightDesc;

    switch (_activeEnvironment) {
      case 'Welding Sparks':
        highlightTitle = 'ARC-FLASH & FLAME SHIELDING';
        highlightDesc = 'Filters out intense ultraviolet (UV) radiation and blinding visible light generated by welding arcs. Prevents arc-eye damage while retaining perfect worksite peripheral vision.';
        break;
      case 'Low-light Fog':
        highlightTitle = 'ANTI-CONDENSATION DE-MIST';
        highlightDesc = 'Super-hydrophobic double-layered coating prevents moisture buildup and steam aggregation in dark, underground, or poorly ventilated basements.';
        break;
      case 'Solar Glare':
        highlightTitle = 'POLARIZED HIGH-GLARE UV400';
        highlightDesc = 'Cancels reflections off steel, concrete, and water surfaces. Blocks 99.9% of harmful UVA/UVB rays for supervisors inspecting site work in direct sunlight.';
        break;
      case 'Dust Masonry':
        highlightTitle = 'AIRBORNE PARTICLE SEALING';
        highlightDesc = 'Protects against masonry concrete dust, timber chips, and micro-metals. Side-shields are reinforced to deflect flying particles traveling up to 250 mph.';
        break;
      default:
        highlightTitle = 'Z87+ OPTICAL COATINGS';
        highlightDesc = 'High-velocity certified protection layers.';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GlassCard(
        borderRadius: 24,
        fillGradientStart: Colors.white.withOpacity(0.04),
        fillGradientEnd: Colors.white.withOpacity(0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9E00).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline_rounded, color: Color(0xFFFF9E00), size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  highlightTitle,
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              highlightDesc,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const Divider(color: Colors.white10, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TINT PROFILE:',
                  style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  _tintDescription.toUpperCase(),
                  style: const TextStyle(color: Color(0xFFFF9E00), fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Spec indicators
  Widget _buildSpecsPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LENS PERFORMANCE AUDIT',
            style: GoogleFonts.orbitron(
              textStyle: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildAuditBadge('OPTICAL GRADE', 'CLASS 1', Icons.radar_rounded),
              const SizedBox(width: 10),
              _buildAuditBadge('UV PROTECTION', '99.9%', Icons.wb_sunny_rounded),
              const SizedBox(width: 10),
              _buildAuditBadge('VIBRATION RATIO', '0.04% HZ', Icons.vibration_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuditBadge(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFFF9E00), size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Sticky bottom checkout controller
  Widget _buildBottomStickyPanel(BuildContext context, AppStateProvider state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.85),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.5),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'CALIBRATING GLASS',
                    style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentProduct.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${_currentProduct.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xFFFF9E00), fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    state.addToCart(_currentProduct);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFFFF9E00),
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, color: Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_currentProduct.name} equipped to dispatch list!',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9E00), Color(0xFFFFB703)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9E00).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart_rounded, color: Colors.black, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'EQUIP AND ADD TO CART',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11),
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
    );
  }
}

// Clipper for horizontal dragging reveal
class _HorizontalSplitClipper extends CustomClipper<Path> {
  final double splitRatio;

  _HorizontalSplitClipper(this.splitRatio);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double splitX = size.width * splitRatio;
    path.moveTo(splitX, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(splitX, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HorizontalSplitClipper oldClipper) {
    return oldClipper.splitRatio != splitRatio;
  }
}

// Particle model
class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double radius;
  double life;
  double decay;
  bool isSpark;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.radius,
    required this.life,
    required this.decay,
    required this.isSpark,
  });
}

// Particle painter that renders hazard animations on the unfiltered side
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double splitRatio;

  _ParticlePainter({required this.particles, required this.splitRatio});

  @override
  void paint(Canvas canvas, Size size) {
    double boundaryX = size.width * splitRatio;

    for (var p in particles) {
      // Sparks are ONLY visible on the unfiltered hazard side (left of divider)
      if (p.x < boundaryX) {
        final paint = Paint()
          ..color = p.color.withOpacity(p.life)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return true;
  }
}
