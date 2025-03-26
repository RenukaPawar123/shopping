import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/product.dart';
import '../../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final int _productsPerPage = 10;

  ProductBloc({required this.productRepository}) : super(const ProductState()) {
    on<ProductFetched>(_onProductFetched);
    on<ProductLoadMore>(_onProductLoadMore);
  }

  Future<void> _onProductFetched(
      ProductFetched event,
      Emitter<ProductState> emit,
      ) async {
    if (state.status == ProductStatus.initial) {
      emit(state.copyWith(status: ProductStatus.loading));
      try {
        final products = await productRepository.fetchProducts(
          limit: _productsPerPage,
          skip: 0,
        );
        final totalProducts = await productRepository.getTotalProducts();
        final hasReachedMax = products.length >= totalProducts;

        emit(state.copyWith(
          status: ProductStatus.success,
          products: products,
          hasReachedMax: hasReachedMax,
          page: 0,
        ));
      } catch (_) {
        emit(state.copyWith(status: ProductStatus.failure));
      }
    }
  }

  Future<void> _onProductLoadMore(
      ProductLoadMore event,
      Emitter<ProductState> emit,
      ) async {
    if (state.hasReachedMax) return;

    try {
      final nextPage = state.page + 1;
      final skip = nextPage * _productsPerPage;

      final newProducts = await productRepository.fetchProducts(
        limit: _productsPerPage,
        skip: skip,
      );

      final totalProducts = await productRepository.getTotalProducts();
      final hasReachedMax = state.products.length + newProducts.length >= totalProducts;

      emit(state.copyWith(
        status: ProductStatus.success,
        products: List.of(state.products)..addAll(newProducts),
        hasReachedMax: hasReachedMax,
        page: nextPage,
      ));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}

