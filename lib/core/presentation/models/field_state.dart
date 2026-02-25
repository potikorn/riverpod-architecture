class FieldState<T> {
  final T value;
  final T initialValue;
  final bool isTouched;

  const FieldState({
    required this.value,
    required this.initialValue,
    this.isTouched = false,
  });

  bool get isDirty => value != initialValue; // ค่าเปลี่ยนไปจากตอนแรกมั้ย?

  FieldState<T> copyWith({T? value, bool? isTouched}) {
    return FieldState<T>(
      value: value ?? this.value,
      initialValue: initialValue,
      isTouched: isTouched ?? this.isTouched,
    );
  }
}