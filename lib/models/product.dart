class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isFeatured = false,
  });

  // Factory constructor to create a Product from a Map (useful for JSON parsing)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'],
      category: map['category'],
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  // Method to convert a Product to a Map (useful for JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isFeatured': isFeatured,
    };
  }
}
List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'Premium Dog Food',
    description: 'High-quality, balanced nutrition for adult dogs.',
    price: 29.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTONPFnUBI4_6pdQhGktUYaMZ9NWI46-7caiw&s',
    category: 'Dog Food',
    isFeatured: true,
  ),
  Product(
    id: '2',
    name: 'Interactive Cat Toy',
    description: 'Engaging toy to keep your cat entertained for hours.',
    price: 14.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuz77kGow6RitKOOQVWu9PmBhukiX8YpirUg&s',
    category: 'Cat Toys',
    isFeatured: true,
  ),
  Product(
    id: '3',
    name: 'Cozy Pet Bed',
    description: 'Soft and comfortable bed suitable for cats and small dogs.',
    price: 39.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2bOMEgRym0gZw52v-bglo5hS0wUAyCreLcw&s',
    category: 'Bedding',
    isFeatured: true,
  ),
  Product(
    id: '4',
    name: 'Aquarium Starter Kit',
    description: '10-gallon aquarium with essential accessories for beginners.',
    price: 79.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFqV1whYhPd7mcwZoXU3pO9XXrQX1DKWtHIQ&s',
    category: 'Fish Supplies',
    isFeatured: true,
  ),
  Product(
    id: '5',
    name: 'Bird Cage',
    description: 'Spacious cage for small to medium-sized birds.',
    price: 49.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKwiOc1gbd1yZdA5ypxNgSd5i5qaKBHS-OrQ&s',
    category: 'Bird Supplies',
  ),
  Product(
    id: '6',
    name: 'Hamster Exercise Wheel',
    description: 'Silent spinner wheel for hamsters and other small rodents.',
    price: 9.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzETpDQaTNI6gSEbDaPSZ1yjS3UnCjKgSPxA&s',
    category: 'Small Pet Supplies',
  )
];
