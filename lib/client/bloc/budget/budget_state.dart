part of 'budget_bloc.dart';

class BudgetState extends Equatable {
  final bool isInitialized;
  final bool isReady;
  final bool isDeleted;
  final BudgetErrorObject? error;
  final Budget budget;
  final List<Category> categories;

  const BudgetState({
    this.isInitialized = false,
    this.isReady = false,
    this.isDeleted = false,
    required this.budget,
    required this.categories,
    this.error,
  });

  BudgetState copyWith({
    bool? isInitialized,
    bool? isReady,
    bool? isDeleted,
    Budget? budget,
    List<Category>? categories,
    BudgetErrorObject? error,
  }) {
    return BudgetState(
      isInitialized: isInitialized ?? this.isInitialized,
      isReady: isReady ?? this.isReady,
      budget: budget ?? this.budget,
      categories: categories ?? this.categories,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [isInitialized, isReady, isDeleted, budget, categories, if (error != null) error!];
}
