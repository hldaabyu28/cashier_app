import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/core/services/auth_service.dart';
import 'package:casier_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosProfilePage extends StatelessWidget {
  const PosProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header with back icon & settings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Avatar + name
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.secondary, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primary.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sarah J.',
                    style: AppTextStyle.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'instacart-customer',
                    style: AppTextStyle.caption.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'October 2021',
                    style: AppTextStyle.caption.copyWith(color: Colors.grey[400]),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Promo banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D1C2E), Color(0xFF1A3050)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You could save Rp14rb a month',
                              style: AppTextStyle.subtitle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Unlock unlimited free delivery and more.',
                              style: AppTextStyle.caption.copyWith(
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Here's Free",
                                style: AppTextStyle.caption.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.local_offer_rounded,
                        size: 50,
                        color: AppColor.secondary.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Shortcut metrics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _MetricCard(
                      icon: Icons.local_shipping_outlined,
                      label: 'Free delivery',
                      sublabel: 'on orders 35rb+',
                    ),
                    const SizedBox(width: 10),
                    _MetricCard(
                      icon: Icons.percent_rounded,
                      label: 'Reduced',
                      sublabel: 'service fees',
                    ),
                    const SizedBox(width: 10),
                    _MetricCard(
                      icon: Icons.credit_card_rounded,
                      label: 'Me credit',
                      sublabel: 'per pickup',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildSectionLabel('Account'),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'Your orders',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.manage_accounts_outlined,
                      label: 'Account settings',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Promos & cards'),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.card_giftcard_outlined,
                      label: 'Invite friends: get 50rb',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    // Sign out
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        title: Text(
                          'Sign Out',
                          style: AppTextStyle.subtitle.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text('Are you sure you want to sign out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    AuthService.to.setToken(null);
                                    Get.offAllNamed(AppRoutes.login);
                                  },
                                  child: const Text('Sign Out',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(
          color: Colors.grey[400],
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColor.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyle.caption.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: AppTextStyle.caption.copyWith(
                color: Colors.grey[400],
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColor.primary, size: 20),
        title: Text(
          label,
          style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey[300],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
