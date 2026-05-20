import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state_provider.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final dispatches = state.dispatches;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Z87 Site Supervisor clearance ID Card
          _buildSupervisorIdCard(context, state),
          const SizedBox(height: 24),

          // Dispatch records / Order history title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DISPATCH RECORDS & LOGS',
                style: GoogleFonts.orbitron(
                  textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9E00).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${dispatches.length} DISPATCHES',
                  style: const TextStyle(
                    color: Color(0xFFFF9E00),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List of past dispatches
          if (dispatches.isEmpty)
            _buildEmptyDispatchState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dispatches.length,
              itemBuilder: (context, idx) {
                final dispatch = dispatches[idx];
                return _buildDispatchCard(dispatch);
              },
            ),

          const SizedBox(height: 20),

          // Auditing controls & safety settings
          Text(
            'Z87 AUDIT PREFERENCES',
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
          _buildSettingsSection(state),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Futuristic digital Z87 identification pass
  Widget _buildSupervisorIdCard(BuildContext context, AppStateProvider state) {
    return GlassCard(
      borderRadius: 24,
      fillGradientStart: Colors.white.withOpacity(0.05),
      fillGradientEnd: Colors.white.withOpacity(0.01),
      border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.3), width: 1.5),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: Color(0xFFFF9E00), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Z87 DIGITAL ACCESS PASS',
                    style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              // Glowing status dot
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'ACTIVE CLEARANCE',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Colors.white12, height: 1),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Digital supervisor ID avatar silhouette or QR
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Render dynamic bar-lines simulating a Z87 safety barcode
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 3, height: 35, color: Colors.white54),
                          const SizedBox(width: 2),
                          Container(width: 1, height: 35, color: Colors.white54),
                          const SizedBox(width: 2),
                          Container(width: 4, height: 35, color: Colors.white54),
                          const SizedBox(width: 2),
                          Container(width: 2, height: 35, color: Colors.white54),
                          const SizedBox(width: 2),
                          Container(width: 1, height: 35, color: Colors.white54),
                          const SizedBox(width: 2),
                          Container(width: 3, height: 35, color: Colors.white54),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.siteId,
                        style: const TextStyle(color: Colors.white30, fontSize: 7, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Credentials
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Specific compliance level pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9E00).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.safetyClearance,
                        style: const TextStyle(
                          color: Color(0xFFFF9E00),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Additional metadata (Employer & site ID)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildIdMeta('ORGANIZATION', state.companyName),
                ),
                Container(width: 1, height: 24, color: Colors.white12),
                Expanded(
                  child: _buildIdMeta('ACTIVE SITE ID', state.siteId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdMeta(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Individual order dispatch details
  Widget _buildDispatchCard(Map<String, dynamic> dispatch) {
    final List<Map<String, dynamic>> items = dispatch['items'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        fillGradientStart: Colors.white.withOpacity(0.04),
        fillGradientEnd: Colors.white.withOpacity(0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & status row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dispatch['orderId'],
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dispatch Date: ${dispatch['date']}',
                      style: const TextStyle(color: Colors.white30, fontSize: 10),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9E00).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.2)),
                  ),
                  child: Text(
                    dispatch['status'].toString().toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFF9E00),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 20),

            // Item descriptions
            ...items.map((item) {
              final prod = item['product'];
              final qty = item['quantity'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${prod.name} x $qty',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                    Text(
                      '\$${(prod.price * qty).toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),

            const Divider(color: Colors.white12, height: 20),
            // Total dispatch cost row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL DISPATCH VALUE',
                  style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                Text(
                  '\$${dispatch['total'].toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFFFF9E00), fontSize: 14, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Audits & general preferences list
  Widget _buildSettingsSection(AppStateProvider state) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 20,
      fillGradientStart: Colors.white.withOpacity(0.04),
      fillGradientEnd: Colors.white.withOpacity(0.01),
      child: Column(
        children: [
          _buildSettingsTile(Icons.notifications_active_outlined, 'Secure Safety Notifications', 'Notify when Z87 compliance expires', true),
          const Divider(color: Colors.white10, height: 1),
          _buildSettingsTile(Icons.sync_lock_rounded, 'Compliance Audit Syncing', 'Sync order certificates with state safety records', true),
          const Divider(color: Colors.white10, height: 1),
          // Logout Button tile
          ListTile(
            onTap: () {
              state.logoutUser();
            },
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            title: const Text(
              'REVOKE SECURITY CLEARANCE',
              style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            subtitle: const Text('Log out of this supervisor ID', style: TextStyle(color: Colors.white24, fontSize: 10)),
            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, bool showSwitch) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF9E00), size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white30, fontSize: 10)),
      trailing: showSwitch
          ? Switch(
              value: true,
              onChanged: (val) {},
              activeColor: const Color(0xFFFF9E00),
              activeTrackColor: const Color(0xFFFF9E00).withOpacity(0.2),
            )
          : const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }

  Widget _buildEmptyDispatchState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.analytics_outlined, color: Colors.white24, size: 36),
            const SizedBox(height: 12),
            Text(
              'NO DISPATCH HISTORY FOUND',
              style: GoogleFonts.orbitron(
                textStyle: const TextStyle(
                  color: Colors.white30,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Approve secure purchases from the Cart Screen',
              style: TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
