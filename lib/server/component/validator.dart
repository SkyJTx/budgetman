class Validator {
  static String? titleValidator(String? value) {
    final frontBackSpaceRegEx = RegExp(r'^\s+|\s+$');
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.length > 40) {
      return 'Title must be at most 40 characters';
    }
    if (frontBackSpaceRegEx.hasMatch(value)) {
      return 'Title must be different from the previous one';
    }
    return null;
  }

  static String? descriptionValidator(String? value) {
    final frontBackSpaceRegEx = RegExp(r'^\s+|\s+$');
    if (value == null) {
      return 'Description cannot be empty';
    }
    if (value.length > 100) {
      return 'Description must be at most 100 characters';
    }
    if (frontBackSpaceRegEx.hasMatch(value)) {
      return 'Description must be different from the previous one';
    }
    return null;
  }

  static String? priorityValidator(String? value) {
    final numValue = int.tryParse(value ?? '');
    if (numValue == null) {
      return 'Priority must be an integer';
    }
    if (numValue < 1) {
      return 'Priority must be at least 1';
    }
    return null;
  }

  static String? amountValidator(String? value) {
    final numValue = double.tryParse(value ?? '');
    if (numValue == null) {
      return 'Amount must be a number';
    }
    if (numValue < 0) {
      return 'Amount must be at least 0';
    }
    return null;
  }

  static String? routineIntervalSecondValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Routine interval must be an integer';
    }
    if (intValue < 60 * 60 * 24) {
      return 'Routine interval must be at least 1 day';
    }
    final duration = Duration(seconds: intValue);
    if (duration.inDays > 365.25 * 20) {
      return 'Routine interval must be at most 20 years';
    }
    return null;
  }

  static String? routineIntervalDayValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Routine interval day must be an integer';
    }
    if (intValue < 1) {
      return 'Routine interval day must be at least 1 day';
    }
    return null;
  }

  static get routineInterval => _RoutineInterval();
}

class _RoutineInterval {
  String? secondsValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Seconds interval must be an integer';
    }
    if (intValue < 0) {
      return 'Seconds interval cannot be negative';
    }
    if (intValue > 60) {
      return 'Seconds interval cannot be more than 60 seconds';
    }
    return null;
  }

  String? minutesValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Minutes interval must be an integer';
    }
    if (intValue < 0) {
      return 'Minutes interval cannot be negative';
    }
    if (intValue > 60) {
      return 'Minutes interval cannot be more than 60 minutes';
    }
    return null;
  }

  String? hoursValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Hours interval must be an integer';
    }
    if (intValue < 0) {
      return 'Hours interval cannot be negative';
    }
    if (intValue > 24) {
      return 'Hours interval cannot be more than 24 hours';
    }
    return null;
  }

  String? daysValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Days interval must be an integer';
    }
    if (intValue < 0) {
      return 'Days interval cannot be negative';
    }
    if (intValue > 365) {
      return 'Days interval cannot be more than 365 days';
    }
    return null;
  }

  String? yearValidator(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue == null) {
      return 'Year interval must be an integer';
    }
    if (intValue < 0) {
      return 'Year interval cannot be negative';
    }
    if (intValue > 20) {
      return 'Year interval cannot be more than 20 years';
    }
    return null;
  }
}
