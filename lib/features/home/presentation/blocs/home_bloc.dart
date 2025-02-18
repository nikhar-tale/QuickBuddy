import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_buy/features/home/data/models/product_model.dart';
import 'package:quick_buy/features/home/data/repositories/product_repository.dart';




class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;

  HomeBloc({required this.productRepository}) : super(HomeInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        // Example call to your repository
        final products = await productRepository.fetchProducts(
          id: "gid://shopify/Collection/475105526067",
          filters: [],
          limit: 10,
          identifiers: [
            {"key": "quick_apps_mobile_banner", "namespace": "custom"},
            {"key": "demo_name", "namespace": "custom"},
          ],
          sortKey: "TITLE",
          reverse: true,
        );

        emit(HomeLoaded(products: products));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
  }
}




abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends HomeEvent {}

class AddToCartEvent extends HomeEvent {
  final Product product;
  const AddToCartEvent(this.product);

  @override
  List<Object?> get props => [product];
}



abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> products;

  const HomeLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
