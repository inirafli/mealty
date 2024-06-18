class CartItem {
  final String id;
  final String name;
  final int price;
  final String image;
  final int stock; // Add the stock field
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stock,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'stock': stock,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      stock: map['stock'],
      quantity: map['quantity'],
    );
  }
}