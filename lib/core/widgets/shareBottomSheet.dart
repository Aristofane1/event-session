import 'package:event_session/config/app_assets.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Share with friends',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Search bar
          SizedBox(
            height: 55,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20,
                ),
                suffixIcon: Image.asset(
                  AppAssets.userPlus,
                  color: Colors.grey[600],
                  height: 20,
                  width: 20,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),

          // First row of contacts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) =>
                  _buildContactItem("${user.firstname}", "${user.photo}"),
            ),
          ),
          const SizedBox(height: 40),

          // Social media options
          SizedBox(
            height: 65,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSocialOption(
                  icon: AppAssets.copyIcon,
                  label: 'Copy Link',
                ),
                _buildSocialOption(
                  icon: AppAssets.facebookIcon,
                  label: 'Facebook',
                ),
                _buildSocialOption(
                  icon: AppAssets.instagramIcon,
                  label: 'Instagram',
                ),
                _buildSocialOption(
                  icon: AppAssets.messengerIcon,
                  label: 'Messenger',
                ),
                _buildSocialOption(
                  icon: AppAssets.iconMessage,
                  label: 'Message',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialOption({required String icon, required String label}) {
    return Container(
      height: 63,
      width: 53,
      margin: EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Image.asset(icon, height: 45, width: 45, fit: BoxFit.cover),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8F8D8A)),
          ),
        ],
      ),
    );
  }
}
