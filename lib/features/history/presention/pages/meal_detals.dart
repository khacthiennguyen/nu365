// filepath: d:\nu365\lib\features\history\presention\pages\meal_detals.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nu365/features/history/logic/history_bloc.dart';
import 'package:nu365/features/history/logic/history_event.dart';
import 'package:nu365/features/history/logic/history_state.dart';
import 'package:nu365/features/history/models/meal.dart';
import 'package:nu365/features/history/presention/widgets/index.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  const MealDetailsScreen({super.key, required this.mealId});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadMealDetailEvent(mealId: widget.mealId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is MealDetailLoaded) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDeleteMeal(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is MealDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealDetailLoaded) {
            return _buildMealDetails(context, state.meal);
          } else if (state is MealDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoryBloc>().add(
                            LoadMealDetailEvent(mealId: widget.mealId),
                          );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No meal details available'));
          }
        },
      ),
    );
  }

  Widget _buildMealDetails(BuildContext context, MealModel meal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal date and time - chuyển từ UTC sang thời gian địa phương
          Text(
            '${DateFormat('EEEE, MMMM d, yyyy').format(meal.meal_time.toLocal())} at ${DateFormat('h:mm a').format(meal.meal_time.toLocal())}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),

          // Meal image if available
          if (meal.image_url != null && meal.image_url!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                meal.image_url!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 48, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Meal note
          if (meal.note != null && meal.note!.isNotEmpty) ...[
            Text(
              'Note:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              meal.note!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
          ],

          // Nutritional summary
          NutritionalSummary(meal: meal),

          const SizedBox(height: 24),

          // Food items
          Text(
            'Food Items',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          if (meal.food_items == null || meal.food_items!.isEmpty)
            const Text('No food items recorded for this meal.')
          else
            ...meal.food_items!
                .map((food) => FoodItemCard(food: food))
                .toList(),
        ],
      ),
    );
  }

  void _confirmDeleteMeal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteMealDialog(
        onDelete: () {
          context
              .read<HistoryBloc>()
              .add(DeleteMealEvent(mealId: widget.mealId));
          Navigator.pop(context); // Go back to history screen
        },
      ),
    );
  }
}
