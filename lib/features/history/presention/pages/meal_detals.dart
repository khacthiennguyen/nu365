// filepath: d:\nu365\lib\features\history\presention\pages\meal_detals.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nu365/features/history/logic/history_bloc.dart';
import 'package:nu365/features/history/logic/history_event.dart';
import 'package:nu365/features/history/logic/history_state.dart';
import 'package:nu365/features/history/models/meal.dart';
import 'package:nu365/features/history/presention/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
            // Thay CircularProgressIndicator bằng Skeletonizer
            return Skeletonizer(
              enabled: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skeleton cho thời gian
                    Text(
                      '${DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now())} at ${DateFormat('h:mm a').format(DateTime.now())}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 16),

                    // Skeleton cho hình ảnh
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Skeleton cho ghi chú
                    Text(
                      'Note:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Loading meal notes...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 20),

                    // Skeleton cho bảng thông tin dinh dưỡng
                    Text(
                      'Nutritional Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Nutrient ${index + 1}'),
                                  Text('${index * 100} kcal'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Skeleton cho Food Items
                    Text(
                      'Food Items',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      3,
                      (index) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Food Item ${index + 1}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Calories:'),
                                  Text('${index * 200} kcal'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Protein:'),
                                  Text('${index * 10} g'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
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
