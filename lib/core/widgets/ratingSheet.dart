import 'package:event_session/config/app_assets.dart';
import 'package:event_session/config/themes/app_themes.dart';
import 'package:event_session/core/widgets/customButton.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBottomSheet extends StatefulWidget {
  final String businessName;
  final double initialRating;

  const RatingBottomSheet({
    super.key,
    required this.businessName,
    this.initialRating = 0.0,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  final int _maxCharacters = 2000;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'How was your\nexperience in\n${widget.businessName}?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Rating section
            Row(
              children: [
                const Text(
                  'Your rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B445),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Stars rating
            RatingBar(
              initialRating: _rating,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: Image.asset(AppAssets.starFill),
                half: Image.asset(AppAssets.starFill),
                empty: Image.asset(AppAssets.starFillEmpty),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 24),

            // Comment section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Other',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Text field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                maxLength: _maxCharacters,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterText: '',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8),

            // Character counter
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_commentController.text.length}/$_maxCharacters maximum characters allowed',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),

            // Add photo button
            SizedBox(
              width: double.maxFinite,
              child: CustomButton(
                text: 'Add photo',
                onPressed: () {
                  filePicker().then((value) {
                    if (value != null && value.files.isNotEmpty) {
                      // Handle the selected files
                      print('Selected files: ${value.files.length}');
                    } else {
                      print('No files selected');
                    }
                  });
                },
                buttonStyle: ButtonStyle.outlined,
                color: AppThemes.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      // Handle save
                      Navigator.of(context).pop();
                    },
                    buttonStyle: ButtonStyle.outlined,
                    color: AppThemes.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Save',
                    onPressed: () {
                      // Handle save
                      Navigator.of(context).pop({
                        'rating': _rating,
                        'comment': _commentController.text,
                      });
                    },
                    color: AppThemes.secondaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    return result;
  }
}
