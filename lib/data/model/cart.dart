class CartItem {
  final String foodId;
  int quantity;
  int price;

  CartItem({
    required this.foodId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      foodId: map['foodId'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
