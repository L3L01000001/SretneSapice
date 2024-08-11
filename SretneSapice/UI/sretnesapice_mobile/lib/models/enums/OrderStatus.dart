enum OrderStatus { InCart, Paid, Processing, Shipped, Cancelled }

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.InCart:
        return 'InCart';
      case OrderStatus.Paid:
        return 'Paid';
      case OrderStatus.Processing:
        return 'Processing';
      case OrderStatus.Shipped:
        return 'Shipped';
      case OrderStatus.Cancelled:
        return 'Cancelled';
    }
  }
}
