import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_buy/features/cart/data/models/cart_item_model.dart';
import 'package:quick_buy/features/cart/data/repositories/cart_repository.dart';




class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await cartRepository.fetchCartItems();
        emit(CartLoaded(cartItems: items));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });
  }
}





abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}





abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  const CartLoaded({required this.cartItems});

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String message;
  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}