part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartProductAdded extends CartEvent {
  final Product product;

  const CartProductAdded(this.product);

  @override
  List<Object> get props => [product];
}

class CartProductRemoved extends CartEvent {
  final Product product;

  const CartProductRemoved(this.product);

  @override
  List<Object> get props => [product];
}

class CartProductQuantityIncreased extends CartEvent {
  final Product product;

  const CartProductQuantityIncreased(this.product);

  @override
  List<Object> get props => [product];
}

class CartProductQuantityDecreased extends CartEvent {
  final Product product;

  const CartProductQuantityDecreased(this.product);

  @override
  List<Object> get props => [product];
}

