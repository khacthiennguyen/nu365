import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nu365/features/history/logic/history_bloc.dart';
import 'package:nu365/features/history/logic/history_event.dart';
import 'package:nu365/features/history/logic/history_state.dart';
import 'package:nu365/features/history/models/meal.dart';
import 'package:nu365/features/history/presention/pages/meal_detals.dart';
import 'package:nu365/features/history/presention/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc()..add(const LoadHistoryEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lịch sử bữa ăn đã lưu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context
                        .read<HistoryBloc>()
                        .add(const RefreshHistoryEvent());
                  },
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HistoryBloc>().add(const RefreshHistoryEvent());
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoading) {
                // Replace CircularProgressIndicator with Skeletonizer
                return Skeletonizer(
                  enabled: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 3, // Số ngày giả lập
                    itemBuilder: (context, dateIndex) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Loading date...',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          // Hiển thị 2 meal skeleton cho mỗi ngày
                          ...List.generate(
                            2,
                            (index) => MealCard(
                              meal: MealModel(
                                meal_id: 'skeleton-$index',
                                meal_time: DateTime.now(),
                              ),
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                );
              } else if (state is HistoryLoaded) {
                if (state.meals.isEmpty) {
                  return const Center(
                    child: Text('No meals recorded yet'),
                  );
                }

                // Group meals by date
                final Map<String, List<MealModel>> groupedMeals = {};
                for (var meal in state.meals) {
                  final dateStr =
                      DateFormat('yyyy-MM-dd').format(meal.meal_time);
                  if (!groupedMeals.containsKey(dateStr)) {
                    groupedMeals[dateStr] = [];
                  }
                  groupedMeals[dateStr]!.add(meal);
                }

                // Sort dates in descending order (newest first)
                final sortedDates = groupedMeals.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final dateStr = sortedDates[index];
                    final meals = groupedMeals[dateStr]!;

                    // Parse date for header formatting
                    final date = DateTime.parse(dateStr);
                    final dateHeader =
                        DateFormat('EEEE, MMMM d, yyyy').format(date);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            dateHeader,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ...meals
                            .map((meal) => MealCard(
                                  meal: meal,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<HistoryBloc>(),
                                          child: MealDetailsScreen(
                                              mealId: meal.meal_id),
                                        ),
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                );
              } else if (state is HistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<HistoryBloc>()
                              .add(const LoadHistoryEvent());
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No history available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
