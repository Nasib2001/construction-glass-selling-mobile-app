import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_card.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'bot',
      'text': 'SentrySafe AI Agent active. Welcome to the Compliance & Occupational Safety Hub. How can I assist you with your Z87+ safety gear or worksite regulations today?',
      'time': 'Just now',
    }
  ];

  final List<String> _quickPrompts = [
    'What does Z87+ mean?',
    'Clean laminated glass?',
    'Report broken frame',
    'Ballistic velocity ratings',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'time': 'Just now',
      });
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Trigger bot automated response
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String botReply = 'I am scanning the OSHA safety database for your query. For direct human support, please trigger the site emergency radio.';
      
      final lowerText = text.toLowerCase();
      if (lowerText.contains('z87')) {
        botReply = 'Z87+ represents the High-Velocity Impact Certification standard. The plus (+) sign indicates that the safety eyewear has been tested and certified under ballistic high-velocity impact requirements, ensuring absolute protection from rapid flying debris.';
      } else if (lowerText.contains('laminated') || lowerText.contains('clean')) {
        botReply = 'Laminated Construction Safety Glass consists of multi-layer cohesive chemical bonds. Clean only with neutral water, mild soap, and the enclosed microfiber cloth. Never use high-acid, alcohol, or industrial solvents, as they will degrade the cohesive anti-fragmentation film.';
      } else if (lowerText.contains('break') || lowerText.contains('broken') || lowerText.contains('damage')) {
        botReply = 'ALERT: Shattered or damaged frames lose Z87+ compliance rating instantly. Cease active operations immediately. Contact your site compliance inspector, and place a new Z87 Emergency Dispatch through the SentrySafe portal.';
      } else if (lowerText.contains('ballistic') || lowerText.contains('velocity')) {
        botReply = 'Our Z87+ Ballistic safety glasses (like the IronClad Z87 Pro) are rated under military MIL-PRF-32432 standards, capable of absorbing impacts from projectile speeds exceeding 250 mph without lens breakage or frame failure.';
      }

      setState(() {
        _isTyping = false;
        _messages.add({
          'sender': 'bot',
          'text': botReply,
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AI Header banner
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: 16,
            fillGradientStart: Colors.white.withOpacity(0.04),
            fillGradientEnd: Colors.white.withOpacity(0.01),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9E00).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.4)),
                      ),
                      child: const Center(
                        child: Icon(Icons.psychology_rounded, color: Color(0xFFFF9E00), size: 22),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.greenAccent,
                        child: Container(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SENTRYSAFE AI COMPLIANCE',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Text(
                        'Automated occupational safety assistant',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quick prompts suggestions carousel
        Container(
          height: 38,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _quickPrompts.length,
            itemBuilder: (context, idx) {
              return GestureDetector(
                onTap: () => _handleSendMessage(_quickPrompts[idx]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Center(
                    child: Text(
                      _quickPrompts[idx],
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Chat messages log viewport
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isBot = msg['sender'] == 'bot';

              return Align(
                alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    borderRadius: 16,
                    fillGradientStart: isBot ? Colors.white.withOpacity(0.04) : const Color(0xFFFF9E00).withOpacity(0.08),
                    fillGradientEnd: isBot ? Colors.white.withOpacity(0.01) : const Color(0xFFFF9E00).withOpacity(0.02),
                    border: Border.all(
                      color: isBot ? Colors.white.withOpacity(0.05) : const Color(0xFFFF9E00).withOpacity(0.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            color: isBot ? Colors.white70 : Colors.white,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isBot ? 'SENTRY_AI' : 'SUPERVISOR',
                              style: TextStyle(
                                color: isBot ? const Color(0xFFFF9E00).withOpacity(0.8) : Colors.cyanAccent.withOpacity(0.8),
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Bot Typing Indicator bubble
        if (_isTyping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9E00)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI safety scanner executing...',
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),

        // Text input dock bar sticky at bottom
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.6),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _handleSendMessage,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Query safety standard or Z87 guidelines...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send Action Button
              GestureDetector(
                onTap: () => _handleSendMessage(_textController.text),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9E00).withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.4)),
                  ),
                  child: const Center(
                    child: Icon(Icons.send_rounded, color: Color(0xFFFF9E00), size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
