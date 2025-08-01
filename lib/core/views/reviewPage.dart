import 'package:event_session/core/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

import '../../config/app_assets.dart';
import '../../config/themes/app_themes.dart';
import '../widgets/custom_text.dart';
import '../widgets/ratingSheet.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: CustomText(
          text: 'Reviews',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.bg),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //   const Color(0xFFF5F1E8).withOpacity(0.85),
            //   BlendMode.overlay,
            // ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section note globale
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Note principale
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          RatingBar(
                            initialRating: 3,
                            itemSize: 24,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Image.asset(
                                AppAssets.starFill,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              half: Image.asset(
                                AppAssets.starFill,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              empty: Image.asset(
                                AppAssets.starFillEmpty,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),

                      SizedBox(width: 30),

                      // Barres de progression
                      Expanded(
                        child: Column(
                          children: [
                            _buildRatingBar(5, 0.9),
                            SizedBox(height: 8),
                            _buildRatingBar(4, 0.7),
                            SizedBox(height: 8),
                            _buildRatingBar(3, 0.3),
                            SizedBox(height: 8),
                            _buildRatingBar(2, 0.15),
                            SizedBox(height: 8),
                            _buildRatingBar(1, 0.05),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                _buildReviewCard(
                  name: 'Daniel Hamilton',
                  avatar:
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
                  rating: 5,
                  timeAgo: '3 days ago',
                  review:
                      'Lorem ipsum dolor sit amet consectetur. Est pharetra dui interdum lacus varius vulputate scelerisque nec. Orci duis mattis lacus faucibus porta gravida urna sed tempus.',
                  hasImages: true,
                  showLess: true,
                ),
                _buildReviewCard(
                  name: 'Kevin O\'connell',
                  avatar:
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
                  rating: 5,
                  timeAgo: '7 days ago',
                  review:
                      'Lorem ipsum dolor sit amet consectetur. Ligula sagittis sapien mauris parturient nec risus ultrices morbi consequat. Posuere ultrices ut nec risus non et semper vel. Sem vitae nunc eget in tempor. Diam amet vitae in accumsan eget.',
                  hasImages: false,
                  showLess: false,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: EdgeInsets.only(left: 24, right: 24, top: 16),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "Write reviews",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) {
                      return RatingBottomSheet(businessName: "Saurabh Kumar");
                    },
                  );
                },
                color: AppThemes.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double progress) {
    return SizedBox(
      height: 15,
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppThemes.primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String avatar,
    required int rating,
    required String timeAgo,
    required String review,
    required bool hasImages,
    required bool showLess,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec avatar, nom et étoiles
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatar)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        RatingBar(
                          initialRating: 3,
                          itemSize: 16,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset(
                              AppAssets.starFill,
                              height: 16,
                              width: 16,
                              fit: BoxFit.cover,
                            ),
                            half: Image.asset(
                              AppAssets.starFill,
                              height: 16,
                              width: 16,
                              fit: BoxFit.cover,
                            ),
                            empty: Image.asset(
                              AppAssets.starFillEmpty,
                              height: 16,
                              width: 16,
                              fit: BoxFit.cover,
                            ),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {},
                        ),
                        SizedBox(width: 8),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Texte de l'avis
          ReadMoreText(
            review,
            trimExpandedText: "Less",
            trimCollapsedText: "More",
            trimLength: 100,
            moreStyle: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black,
            ),
            lessStyle: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black,
            ),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          // Images si présentes
          if (hasImages) ...[
            SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
