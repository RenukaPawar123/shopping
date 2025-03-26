part of 'product_bloc.dart';

enum ProductStatus { initial, success, failure, loading }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final bool hasReachedMax;
  final int page;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
    this.page = 0,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
    int? page,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, products, hasReachedMax, page];
}

