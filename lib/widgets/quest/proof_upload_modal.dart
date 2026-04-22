import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProofButton extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback? onPressed;

  const ProofButton({
    Key? key,
    required this.isCompleted,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.rankS.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.rankS,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: AppColors.rankS,
            ),
            const SizedBox(width: 4),
            Text(
              'Done',
              style: AppTextStyles.label.copyWith(
                color: AppColors.rankS,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cyan,
        foregroundColor: AppColors.bg,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Proof',
        style: AppTextStyles.label.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProofUploadModal extends StatelessWidget {
  final String questTitle;

  const ProofUploadModal({
    Key? key,
    required this.questTitle,
  }) : super(key: key);

  Future<String?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 80,
    );
    return pickedFile?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Terminal label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'SUBMIT PROOF',
                  style: AppTextStyles.terminal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quest title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              questTitle,
              style: AppTextStyles.sectionHeader.copyWith(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Camera option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildOption(
              context,
              icon: Icons.camera_alt,
              label: 'Camera',
              onTap: () async {
                final path = await _pickImage(ImageSource.camera);
                if (context.mounted) {
                  Navigator.of(context).pop(path);
                }
              },
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Gallery option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildOption(
              context,
              icon: Icons.photo_library,
              label: 'Gallery',
              onTap: () async {
                final path = await _pickImage(ImageSource.gallery);
                if (context.mounted) {
                  Navigator.of(context).pop(path);
                }
              },
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.cyan,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
