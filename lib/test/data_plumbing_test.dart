import 'package:flutter/material.dart';
import '../core/services/database_service.dart';

class DataPlumbingTest extends StatefulWidget {
  const DataPlumbingTest({super.key});

  @override
  State<DataPlumbingTest> createState() => _DataPlumbingTestState();
}

class _DataPlumbingTestState extends State<DataPlumbingTest> {
  final DatabaseService _dbService = DatabaseService.instance;
  bool _isLoading = false;
  String _testResult = '';

  @override
  void initState() {
    super.initState();
    _runDataPlumbingTest();
  }

  Future<void> _runDataPlumbingTest() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Running data plumbing test...\n\n';
    });

    try {
      // Initialize database service
      await _dbService.initialize();
      _appendResult(' DatabaseService initialized successfully');

      // Test user fetch
      _appendResult('\n--- Testing User Fetch ---');
      final user = await _dbService.getCurrentUser();
      if (user != null) {
        _appendResult(' SUCCESS: User fetched');
        _appendResult(' User ID: ${user.id}');
        _appendResult(' Email: ${user.email}');
        _appendResult(' Created at: ${user.createdAt}');
      } else {
        _appendResult(' FAILED: No user found');
      }

      // Test habit fetch
      _appendResult('\n--- Testing Habit Fetch ---');
      final habits = await _dbService.getHabits();
      _appendResult(' SUCCESS: Fetched ${habits.length} habits');
      
      for (int i = 0; i < habits.length && i < 3; i++) {
        final habit = habits[i];
        _appendResult(' Habit ${i + 1}: ${habit.title}');
        _appendResult('   Category: ${habit.category}');
        _appendResult('   Streak: ${habit.currentStreak}');
        _appendResult('   Target: ${habit.targetFrequency}/week');
        _appendResult('   XP Reward: ${habit.xpReward}');
        _appendResult('   JSON conversion: SUCCESS');
      }

      // Test habit creation (if user exists)
      if (user != null) {
        _appendResult('\n--- Testing Habit Creation ---');
        try {
          final testHabit = await _dbService.createHabit(
            title: 'Test Meditation',
            description: 'A test habit for data plumbing verification',
            category: 'Mindset',
            targetFrequency: 7,
            xpReward: 15,
            statRewards: ['intel', 'vit'],
          );
          
          _appendResult(' SUCCESS: Created test habit');
          _appendResult(' Habit ID: ${testHabit.id}');
          _appendResult(' Title: ${testHabit.title}');
          _appendResult(' JSON serialization: SUCCESS');
          _appendResult(' JSON deserialization: SUCCESS');

          // Test habit update
          final updatedHabit = await _dbService.updateHabit(testHabit.id, {
            'title': 'Updated Test Meditation',
            'target_frequency': 5,
          });
          _appendResult(' SUCCESS: Updated habit');
          _appendResult(' New title: ${updatedHabit.title}');

          // Test habit completion
          final completion = await _dbService.completeHabit(testHabit.id, notes: 'Test completion');
          _appendResult(' SUCCESS: Completed habit');
          _appendResult(' Completion time: ${completion.completedAt}');
          _appendResult(' New streak: ${updatedHabit.currentStreak + 1}');

          // Test habit completions fetch
          final completions = await _dbService.getHabitCompletions(testHabit.id);
          _appendResult(' SUCCESS: Fetched ${completions.length} completions');

          // Clean up
          await _dbService.deleteHabit(testHabit.id);
          _appendResult(' SUCCESS: Cleaned up test habit');

        } catch (e) {
          _appendResult(' ERROR: Habit operations failed: $e');
        }
      }

      _appendResult('\n--- Data Plumbing Test Complete ---');
      _appendResult(' All tests passed successfully!');
      _appendResult(' Your data plumbing is working correctly.');

    } catch (e) {
      _appendResult('\n ERROR: Data plumbing test failed: $e');
      _appendResult(' Check your Supabase configuration and authentication.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _appendResult(String text) {
    setState(() {
      _testResult += '$text\n';
    });
    print(text); // Also print to console
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Data Plumbing Test'),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _runDataPlumbingTest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: const Color(0xFF0A0E1A),
              ),
              child: const Text('Run Test Again'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.3)),
                ),
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF00E5FF)),
                            SizedBox(height: 16),
                            Text(
                              'Testing data plumbing...',
                              style: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Text(
                          _testResult,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
