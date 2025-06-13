import 'package:flutter_bloc/flutter_bloc.dart';
import 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  HomepageCubit() : super(HomepageInitial());

  void loadHomepageData() {
    emit(HomepageLoading());

    try {
      final offers = [
        'https://picsum.photos/400/200?random=1',
        'https://picsum.photos/400/200?random=2',
        'https://picsum.photos/400/200?random=3',
      ];

      final categories = [
        {
          'icon': 'https://cdn-icons-png.flaticon.com/512/1085/1085949.png',
          'label': 'Body lotions',
        },
        {
          'icon': 'https://cdn-icons-png.flaticon.com/512/2920/2920322.png',
          'label': 'Skin care',
        },
        {
          'icon': 'https://cdn-icons-png.flaticon.com/512/891/891419.png',
          'label': 'Shampoo',
        },
        {
          'icon': 'https://cdn-icons-png.flaticon.com/512/1072/1072300.png',
          'label': 'Perfume',
        },
      ];

      final productImages = [
        'https://picsum.photos/200/300?random=4',
        'https://picsum.photos/200/300?random=5',
        'https://picsum.photos/200/300?random=6',
      ];

      emit(
        HomepageLoaded(
          offers: offers,
          categories: categories,
          productImages: productImages,
        ),
      );
    } catch (e) {
      emit(HomepageError('Failed to load homepage data: ${e.toString()}'));
    }
  }

  void updateCarouselIndex(int index) {
    final currentState = state;
    if (currentState is HomepageLoaded) {
      emit(currentState.copyWith(currentCarouselIndex: index));
    }
  }

  void refreshData() {
    loadHomepageData();
  }
}
