abstract class CategoriesState {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Map<String, dynamic>> categories;

  const CategoriesLoaded({required this.categories});
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);
}
