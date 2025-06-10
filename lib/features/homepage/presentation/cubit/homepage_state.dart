abstract class HomepageState {
  const HomepageState();
}

class HomepageInitial extends HomepageState {}

class HomepageLoading extends HomepageState {}

class HomepageLoaded extends HomepageState {
  final List<String> offers;
  final List<Map<String, String>> categories;
  final List<String> productImages;
  final int currentCarouselIndex;

  const HomepageLoaded({
    required this.offers,
    required this.categories,
    required this.productImages,
    this.currentCarouselIndex = 0,
  });

  HomepageLoaded copyWith({
    List<String>? offers,
    List<Map<String, String>>? categories,
    List<String>? productImages,
    int? currentCarouselIndex,
  }) {
    return HomepageLoaded(
      offers: offers ?? this.offers,
      categories: categories ?? this.categories,
      productImages: productImages ?? this.productImages,
      currentCarouselIndex: currentCarouselIndex ?? this.currentCarouselIndex,
    );
  }
}

class HomepageError extends HomepageState {
  final String message;

  const HomepageError(this.message);
}
