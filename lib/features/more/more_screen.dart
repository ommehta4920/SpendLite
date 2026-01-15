// lib/features/more/more_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PREMIUM CARD
          _buildPremiumCard(context),

          const SizedBox(height: 24),

          // GENERAL SECTION
          _buildSectionTitle('General'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                // Navigate to settings
              },
            ),
            _SettingsItem(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: 'Dark mode',
              onTap: () {
                // Navigate to appearance settings
              },
            ),
            _SettingsItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                // Navigate to notification settings
              },
            ),
          ]),

          const SizedBox(height: 24),

          // SUPPORT SECTION
          _buildSectionTitle('Support'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.help_outline,
              title: 'Help & FAQ',
              onTap: () {
                // Navigate to help
              },
            ),
            _SettingsItem(
              icon: Icons.mail_outline,
              title: 'Contact Us',
              onTap: () {
                // Open email
              },
            ),
            _SettingsItem(
              icon: Icons.bug_report_outlined,
              title: 'Report a Bug',
              onTap: () {
                // Report bug
              },
            ),
          ]),

          const SizedBox(height: 24),

          // SHARE SECTION
          _buildSectionTitle('Share'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.share_outlined,
              title: 'Invite a Friend',
              onTap: () {
                // Share app
              },
            ),
            _SettingsItem(
              icon: Icons.star_outline,
              title: 'Rate Us',
              subtitle: 'Love the app? Leave a review!',
              onTap: () {
                // Open store
              },
            ),
          ]),

          const SizedBox(height: 24),

          // ABOUT SECTION
          _buildSectionTitle('About'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                // Open privacy policy
              },
            ),
            _SettingsItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {
                // Open terms
              },
            ),
            _SettingsItem(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: '1.0.0',
              showArrow: false,
              onTap: null,
            ),
          ]),

          const SizedBox(height: 32),

          // LOGOUT BUTTON (Optional)
          _buildLogoutButton(context),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ---------------- PREMIUM CARD ----------------
  Widget _buildPremiumCard(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Navigate to premium screen
          _showPremiumSheet(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.2),
                AppColors.primary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: AppColors.accent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Text
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Go Premium',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unlock advanced features & analytics',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SECTION TITLE ----------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.mutedText,
        ),
      ),
    );
  }

  // ---------------- SETTINGS CARD ----------------
  Widget _buildSettingsCard(List<_SettingsItem> items) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColors.text,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                ),
                subtitle: item.subtitle != null
                    ? Text(
                  item.subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedText,
                  ),
                )
                    : null,
                trailing: item.showArrow
                    ? const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.mutedText,
                  size: 16,
                )
                    : null,
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                  color: AppColors.background,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ---------------- LOGOUT BUTTON ----------------
  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.logout,
            color: Colors.red,
            size: 20,
          ),
        ),
        title: const Text(
          'Clear All Data',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
        subtitle: const Text(
          'Delete all expenses and budgets',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedText,
          ),
        ),
        onTap: () => _showClearDataDialog(context),
      ),
    );
  }

  // ---------------- DIALOGS ----------------
  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mutedText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Premium icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: AppColors.accent,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'SpendLite Premium',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),

            // Features list
            _buildPremiumFeature(Icons.analytics_outlined, 'Advanced Analytics'),
            _buildPremiumFeature(Icons.cloud_outlined, 'Cloud Backup'),
            _buildPremiumFeature(Icons.category_outlined, 'Custom Categories'),
            _buildPremiumFeature(Icons.receipt_long_outlined, 'Export Reports'),

            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clear All Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to delete all your expenses and budgets? This action cannot be undone.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),

            // Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Clear all Hive boxes
                  // Hive.box<Expense>('expenses').clear();
                  // Hive.box<MonthlyBudget>('budgets').clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data cleared'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: const Text('Delete All Data'),
              ),
            ),
            const SizedBox(height: 8),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SETTINGS ITEM MODEL ----------------
class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.showArrow = true,
    this.onTap,
  });
}