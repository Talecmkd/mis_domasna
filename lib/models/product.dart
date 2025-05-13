class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isFeatured;
  final Map<String, double> userRatings; // Map of userId to rating
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isFeatured = false,
    Map<String, double>? userRatings,
  }) : this.userRatings = userRatings ?? {},
       this.rating = userRatings?.isNotEmpty == true 
         ? (userRatings?.values.fold(0.0, (a, b) => a + b) ?? 0.0) / (userRatings?.length ?? 1)
         : 0.0;

  // Factory constructor to create a Product from a Map (useful for JSON parsing)
  factory Product.fromMap(Map<String, dynamic> map) {
    final ratingsMap = (map['userRatings'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, (value is int ? value.toDouble() : value as double))
    ) ?? {};
        
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'],
      category: map['category'],
      isFeatured: map['isFeatured'] ?? false,
      userRatings: ratingsMap,
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
      'userRatings': userRatings,
    };
  }

  // Check if a user has already rated this product
  bool hasUserRated(String userId) {
    return userRatings.containsKey(userId);
  }

  // Get a user's rating for this product
  double? getUserRating(String userId) {
    return userRatings[userId];
  }

  // Method to add a new rating and get a new Product instance
  Product addRating(String userId, double newRating) {
    final newRatings = Map<String, double>.from(userRatings);
    newRatings[userId] = newRating;
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      category: category,
      isFeatured: isFeatured,
      userRatings: newRatings,
    );
  }

  // Get the number of ratings
  int get numberOfRatings => userRatings.length;
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
    userRatings: {
      'user1': 4.0,
      'user2': 5.0,
      'user3': 4.5,
      'user4': 4.5,
    },
  ),
  Product(
    id: '2',
    name: 'Interactive Cat Toy',
    description: 'Engaging toy to keep your cat entertained for hours.',
    price: 14.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuz77kGow6RitKOOQVWu9PmBhukiX8YpirUg&s',
    category: 'Cat Toys',
    isFeatured: true,
    userRatings: {
      'user1': 4.0,
      'user2': 4.0,
      'user3': 4.0,
    },
  ),
  Product(
    id: '3',
    name: 'Cozy Pet Bed',
    description: 'Soft and comfortable bed suitable for cats and small dogs.',
    price: 39.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2bOMEgRym0gZw52v-bglo5hS0wUAyCreLcw&s',
    category: 'Bedding',
    isFeatured: true,
    userRatings: {
      'user1': 4.0,
      'user2': 4.4,
      'user3': 4.2,
    },
  ),
  Product(
    id: '4',
    name: 'Aquarium Starter Kit',
    description: '10-gallon aquarium with essential accessories for beginners.',
    price: 79.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFqV1whYhPd7mcwZoXU3pO9XXrQX1DKWtHIQ&s',
    category: 'Fish Supplies',
    isFeatured: true,
    userRatings: {
      'user1': 5.0,
      'user2': 4.6,
      'user3': 4.8,
    },
  ),
  Product(
    id: '5',
    name: 'Bird Cage',
    description: 'Spacious cage for small to medium-sized birds.',
    price: 49.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKwiOc1gbd1yZdA5ypxNgSd5i5qaKBHS-OrQ&s',
    category: 'Bird Supplies',
    userRatings: {
      'user1': 4.0,
      'user2': 4.0,
    },
  ),
  Product(
    id: '6',
    name: 'Hamster Exercise Wheel',
    description: 'Silent spinner wheel for hamsters and other small rodents.',
    price: 9.99,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzETpDQaTNI6gSEbDaPSZ1yjS3UnCjKgSPxA&s',
    category: 'Small Pet Supplies',
    userRatings: {
      'user1': 4.3,
      'user2': 4.3,
    },
  )
];
