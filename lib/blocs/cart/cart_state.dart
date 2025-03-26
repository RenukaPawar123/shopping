part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final double totalAmount;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const <CartItem>[],
    this.totalAmount = 0.0,
  });

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    double? totalAmount,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object> get props => [status, items, totalAmount];
}

