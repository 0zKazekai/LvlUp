import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/feed_provider.dart';
import '../../widgets/feed/proof_post_card.dart';

class ProofFeedPage extends StatelessWidget {
  const ProofFeedPage({Key? key}) : super(key: key);

  Future<void> _refreshFeed(BuildContext context) async {
    final feedProvider = context.read<FeedProvider>();
    feedProvider.refreshFeed();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'PROOF FEED',
          style: AppTextStyles.terminal.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.cyan,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        leading: Container(),
        actions: [
          // Refresh button
          IconButton(
            onPressed: () => _refreshFeed(context),
            icon: const Icon(
              Icons.refresh,
              color: AppColors.cyan,
            ),
          ),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, feedProvider, child) {
          final posts = feedProvider.posts;

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feed_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No proof posts yet',
                    style: AppTextStyles.bodySecondary.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete quests and submit proof to see them here',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refreshFeed(context),
            color: AppColors.cyan,
            backgroundColor: AppColors.surface,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ProofPostCard(
                  post: post,
                  onLike: (postId) {
                    feedProvider.toggleLike(postId);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
