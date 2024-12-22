import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/recipe.dart'; // Assume Recipe, Ingredient, and Instruction classes are defined here

class DatabaseHelper {
  final CollectionReference _recipeCollection = FirebaseFirestore.instance.collection('recipe_data');

  // Fetch all recipes
  Future<List<Recipe>> getRecipes() async {
    try {
      final snapshot = await _recipeCollection.get();
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recipes: $e');
    }
  }

  // Add a recipe
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _recipeCollection.add(recipe.toMap());
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  // Update a recipe
  Future<void> updateRecipe(String docId, Recipe recipe) async {
    try {
      await _recipeCollection.doc(docId).update(recipe.toMap());
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  // Delete a recipe
  Future<void> deleteRecipe(String docId) async {
    try {
      await _recipeCollection.doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }

  // Fetch a single recipe by ID
  Future<Recipe> getRecipe(String docId) async {
    try {
      final snapshot = await _recipeCollection.doc(docId).get();
      if (snapshot.exists) {
        return Recipe.fromFirestore(snapshot);
      } else {
        throw Exception('Recipe not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
  }
}
