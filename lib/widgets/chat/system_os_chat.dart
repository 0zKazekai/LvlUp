import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ChatMessage {
  final String text;
  final bool isSystem;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSystem,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class SystemOSChat extends StatefulWidget {
  const SystemOSChat({Key? key}) : super(key: key);

  @override
  State<SystemOSChat> createState() => _SystemOSChatState();
}

class _SystemOSChatState extends State<SystemOSChat> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addSystemMessage('System OS initialized. How can I assist you today?');
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addSystemMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isSystem: true));
    });
    _scrollToBottom();
  }

  void _addPlayerMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isSystem: false));
    });
    _scrollToBottom();
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

  String _generateSystemReply(String playerMessage) {
    final lowerMessage = playerMessage.toLowerCase();
    
    // Quest-related responses
    if (lowerMessage.contains('quest')) {
      if (lowerMessage.contains('daily')) {
        return 'Daily quests reset at midnight. Current daily quests available: 3. Complete them to maintain your streak!';
      } else if (lowerMessage.contains('complete')) {
        return 'Quest completion rewards XP and stat points. Submit proof through the quest card to verify completion.';
      } else {
        return 'You have 5 active quests. 2 daily, 3 weekly. Focus on higher rank quests for better rewards.';
      }
    }
    
    // Level-related responses
    if (lowerMessage.contains('level')) {
      if (lowerMessage.contains('next')) {
        return 'You need 75 more XP to reach the next level. Focus on A-rank quests for faster progression.';
      } else if (lowerMessage.contains('up')) {
        return 'Level up grants stat points and unlocks new features. Current level: 12.';
      } else {
        return 'Your current level is 12 with 325/400 XP. Keep completing quests to progress!';
      }
    }
    
    // XP-related responses
    if (lowerMessage.contains('xp')) {
      if (lowerMessage.contains('how') || lowerMessage.contains('earn')) {
        return 'Earn XP by completing quests. Daily quests: 25-50 XP, Weekly: 75-150 XP, Main: 100-300 XP.';
      } else {
        return 'Total XP earned: 2,450. Current XP: 325/400 to next level.';
      }
    }
    
    // Stat-related responses
    if (lowerMessage.contains('stat')) {
      if (lowerMessage.contains('str') || lowerMessage.contains('strength')) {
        return 'STR: 14/20. Focus on Body arc quests to increase strength. Current bonus: +7 damage.';
      } else if (lowerMessage.contains('vit') || lowerMessage.contains('vitality')) {
        return 'VIT: 12/20. Complete physical challenges to boost vitality. Current bonus: +15 HP.';
      } else if (lowerMessage.contains('int') || lowerMessage.contains('intelligence')) {
        return 'INT: 16/20. Mind arc quests increase intelligence. Current bonus: +8 skill XP.';
      } else if (lowerMessage.contains('cha') || lowerMessage.contains('charisma')) {
        return 'CHA: 11/20. Social quests boost charisma. Current bonus: +5 guild reputation.';
      } else {
        return 'Your stats: STR 14, VIT 12, INT 16, CHA 11. Total stat points: 53/80.';
      }
    }
    
    // Guild-related responses
    if (lowerMessage.contains('guild')) {
      if (lowerMessage.contains('join')) {
        return 'Guilds unlock at level 15. You\'re close! Current progress: 12/15.';
      } else if (lowerMessage.contains('benefit')) {
        return 'Guilds provide daily bonuses, group quests, and exclusive rewards. Join at level 15.';
      } else {
        return 'Guild system available at level 15. Keep progressing to unlock this feature!';
      }
    }
    
    // Default responses
    final defaultResponses = [
      'I can help with quests, levels, XP, stats, and guild information. What do you need?',
      'Try asking about "daily quests", "next level", "XP rewards", or "stat training".',
      'System OS ready. Available commands: quest status, level progress, stat info, guild details.',
      'Need assistance? I can provide information about your progression and available activities.',
    ];
    
    return defaultResponses[(DateTime.now().millisecond) % defaultResponses.length];
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _addPlayerMessage(text);
    _textController.clear();

    // Show typing indicator
    setState(() {
      _isTyping = true;
    });

    // Simulate system response delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        final reply = _generateSystemReply(text);
        _addSystemMessage(reply);
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.cyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'SYSTEM OS',
                  style: AppTextStyles.terminal.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'ONLINE',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.rankC,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Messages area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    // Typing indicator
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'System is typing',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.cyan,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final message = _messages[index];
                  final isSystem = message.isSystem;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: isSystem
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        if (isSystem) ...[
                          // System message (left aligned)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.cyan.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: AppTextStyles.terminal.copyWith(
                                  fontSize: 13,
                                  color: AppColors.cyan,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Player message (right aligned)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cyan.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.cyan.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border(
                top: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask about quests, level, XP, stats...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.cyan,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _handleSendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.cyan,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.cyan.withOpacity(0.1),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
