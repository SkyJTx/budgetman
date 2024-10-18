part of 'budget_bloc.dart';

class BudgetErrorObject extends Equatable {
  final int code;
  final String message;

  const BudgetErrorObject({
    this.code = -1,
    required this.message,
  });

  BudgetErrorObject copyWith({
    int? code,
    String? message,
  }) {
    return BudgetErrorObject(
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'Error $code: $message';
  }

  @override
  List<Object> get props => [code, message];
}
