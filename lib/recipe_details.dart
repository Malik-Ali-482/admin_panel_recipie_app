import 'package:flutter/material.dart';
import 'models/recipe.dart'; // Import your Recipe model

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Center(
              child: Image.network(
                recipe.img,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),

            // Recipe Name and Info
            Text(
              recipe.name,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Rating: ${recipe.rating} | Reviews: ${recipe.reviews} | Time: ${recipe.time} mins",
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Type: ${recipe.type} | Calories: ${recipe.cal} kcal",
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const Divider(height: 32.0, thickness: 1.0),

            // Ingredients Section
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipe.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = recipe.ingredients[index];
                return ListTile(
                  leading: Image.network(
                    ingredient.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(ingredient.name),
                  subtitle: Text("${ingredient.quantity} ${ingredient.type}"),
                );
              },
            ),
            const Divider(height: 32.0, thickness: 1.0),

            // Instructions Section
            const Text(
              "Instructions",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipe.instructions.length,
              itemBuilder: (context, index) {
                final instruction = recipe.instructions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ${instruction.title}",
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        instruction.description,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "Time: ${instruction.time}",
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
