import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../enums/pillar_type.dart';
import '../utils/constants.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    // Load all goals from Hive
    userController.loadGoals(); // we'll add this method to UserController
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Goals"),
        backgroundColor: const Color(0xFF2B2E5A),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          final goals = userController.goals.value;

          if (goals.isEmpty) {
            return const Center(
              child: Text(
                "No goals found. Add a new goal!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: goals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = goals[index];
              final pillar = pillarFromApi(goal.pillar ?? "health_fitness");

              // Determine scheduled time display
              final scheduledTime = goal.scheduledAt ??
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    goal.hour ?? 0,
                    goal.minute ?? 0,
                  );

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    backgroundImage: AssetImage(
                      "assets/images/power.png",
                    
                    ),
                  ),
                  title: Text(
                    goal.title ?? "Untitled",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "${AppConstant.formatGoalTime(scheduledTime)} | ${pillar.label}",
                  ),
                  trailing: Icon(
                    goal.active! ? Icons.check_circle : Icons.pause_circle,
                    color: goal.active! ? Colors.green : Colors.grey,
                  ),
                  onTap: () {
                    // TODO: Open goal details or edit
                  },
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add new goal page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
