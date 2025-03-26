import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/cart_item.dart';
import '../../models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartProductAdded>(_onCartProductAdded);
    on<CartProductRemoved>(_onCartProductRemoved);
    on<CartProductQuantityIncreased>(_onCartProductQuantityIncreased);
    on<CartProductQuantityDecreased>(_onCartProductQuantityDecreased);
  }

  void _onCartProductAdded(
      CartProductAdded event,
      Emitter<CartState> emit,
      ) {
    final state = this.state;
    final product = event.product;

    try {
      final index = state.items.indexWhere(
            (item) => item.product.id == product.id,
      );

      List<CartItem> updatedItems;

      if (index >= 0) {
        // Product already in cart, increase quantity
        final item = state.items[index];
        final updatedItem = item.copyWith(quantity: item.quantity + 1);
        updatedItems = List.of(state.items);
        updatedItems[index] = updatedItem;
      } else {
        // Add new product to cart
        final newItem = CartItem(product: product, quantity: 1);
        updatedItems = List.of(state.items)..add(newItem);
      }

      final totalAmount = _calculateTotalAmount(updatedItems);

      emit(state.copyWith(
        status: CartStatus.success,
        items: updatedItems,
        totalAmount: totalAmount,
      ));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void _onCartProductRemoved(
      CartProductRemoved event,
      Emitter<CartState> emit,
      ) {
    final state = this.state;
    final product = event.product;

    try {
      final updatedItems = state.items.where(
            (item) => item.product.id != product.id,
      ).toList();

      final totalAmount = _calculateTotalAmount(updatedItems);

      emit(state.copyWith(
        status: CartStatus.success,
        items: updatedItems,
        totalAmount: totalAmount,
      ));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void _onCartProductQuantityIncreased(
      CartProductQuantityIncreased event,
      Emitter<CartState> emit,
      ) {
    final state = this.state;
    final product = event.product;

    try {
      final index = state.items.indexWhere(
            (item) => item.product.id == product.id,
      );

      if (index >= 0) {
        final item = state.items[index];
        final updatedItem = item.copyWith(quantity: item.quantity + 1);
        final updatedItems = List.of(state.items);
        updatedItems[index] = updatedItem;

        final totalAmount = _calculateTotalAmount(updatedItems);

        emit(state.copyWith(
          status: CartStatus.success,
          items: updatedItems,
          totalAmount: totalAmount,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void _onCartProductQuantityDecreased(
      CartProductQuantityDecreased event,
      Emitter<CartState> emit,
      ) {
    final state = this.state;
    final product = event.product;

    try {
      final index = state.items.indexWhere(
            (item) => item.product.id == product.id,
      );

      if (index >= 0) {
        final item = state.items[index];

        if (item.quantity > 1) {
          // Decrease quantity
          final updatedItem = item.copyWith(quantity: item.quantity - 1);
          final updatedItems = List.of(state.items);
          updatedItems[index] = updatedItem;

          final totalAmount = _calculateTotalAmount(updatedItems);

          emit(state.copyWith(
            status: CartStatus.success,
            items: updatedItems,
            totalAmount: totalAmount,
          ));
        } else {
          // Remove item if quantity becomes 0
          final updatedItems = List.of(state.items)..removeAt(index);

          final totalAmount = _calculateTotalAmount(updatedItems);

          emit(state.copyWith(
            status: CartStatus.success,
            items: updatedItems,
            totalAmount: totalAmount,
          ));
        }
      }
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  double _calculateTotalAmount(List<CartItem> items) {
    return items.fold(
      0.0,
          (total, item) => total + item.totalPrice,
    );
  }
}

