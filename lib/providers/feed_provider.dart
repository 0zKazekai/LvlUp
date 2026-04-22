import 'package:flutter/material.dart';
import '../entities/proof_post.dart';

class FeedProvider extends ChangeNotifier {
  List<ProofPost> _posts = [];

  List<ProofPost> get posts => _posts;

  FeedProvider() {
    // Initialize with sample posts
    _posts = ProofPost.samples();
  }

  void addPost(ProofPost post) {
    _posts.insert(0, post); // Add to beginning of feed
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final updatedPost = ProofPost(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userAvatarUrl: post.userAvatarUrl,
        questTitle: post.questTitle,
        questArc: post.questArc,
        questRank: post.questRank,
        imagePath: post.imagePath,
        caption: post.caption,
        xpEarned: post.xpEarned,
        likes: post.isLikedByMe ? post.likes - 1 : post.likes + 1,
        createdAt: post.createdAt,
        isLikedByMe: !post.isLikedByMe,
      );
      _posts[index] = updatedPost;
      notifyListeners();
    }
  }

  void removePost(String postId) {
    _posts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }

  void refreshFeed() {
    // Could be used to fetch new posts from API
    notifyListeners();
  }

  int get postCount => _posts.length;

  List<ProofPost> getPostsByUser(String userId) {
    return _posts.where((post) => post.userId == userId).toList();
  }

  List<ProofPost> getPostsByArc(String arc) {
    return _posts.where((post) => post.questArc.toLowerCase() == arc.toLowerCase()).toList();
  }

  List<ProofPost> getPostsByRank(String rank) {
    return _posts.where((post) => post.questRank.toUpperCase() == rank.toUpperCase()).toList();
  }
}
