import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String? docId;
  final String name, rating, reviews, time, type, cal, img;
  final List<Ingredient> ingredients;
  final List<Instruction> instructions;

  Recipe({
    this.docId,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.time,
    required this.type,
    required this.cal,
    required this.img,
    required this.ingredients,
    required this.instructions,
  });

  // Factory to convert Firestore document to Recipe object
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    var ingredientList = (data['ingredients'] as List?)?.map((item) => Ingredient.fromMap(item)).toList() ?? [];
    var instructionList = (data['instructions'] as List?)?.map((item) => Instruction.fromMap(item)).toList() ?? [];

    return Recipe(
      docId: doc.id,
      name: data['name'] ?? '',
      rating: data['rating'] ?? '0',
      reviews: data['reviews'] ?? '0',
      time: data['time'] ?? '',
      type: data['type'] ?? '',
      cal: data['cal'] ?? '0',
      img: data['img'] ?? '',
      ingredients: ingredientList,
      instructions: instructionList,
    );
  }
}

class Ingredient {
  String image, name, quantity, type;

  Ingredient({
    required this.image,
    required this.name,
    required this.quantity,
    required this.type,
  });

  factory Ingredient.fromMap(Map<String, dynamic> data) {
    return Ingredient(
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? '',
      type: data['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'quantity': quantity,
      'type': type,
    };
  }
}

class Instruction {
  String title, description, time;

  Instruction({
    required this.title,
    required this.description,
    required this.time,
  });


  factory Instruction.fromMap(Map<String, dynamic> data) {
    return Instruction(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      time: data['time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': time,
    };
  }
}

extension RecipeExtensions on Recipe {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'reviews': reviews,
      'time': time,
      'type': type,
      'cal': cal,
      'img': img,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'instructions': instructions.map((e) => e.toMap()).toList(),
    };
  }
}
