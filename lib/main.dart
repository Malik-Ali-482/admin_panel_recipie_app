import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database_helper.dart';
import 'models/recipe.dart';
import 'recipe_details.dart'; // A screen to display recipe details
import 'add_edit_recipe.dart'; // A screen to add or edit a recipe

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Admin Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: dbHelper.getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: Image.network(recipe.img, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(recipe.name),
                subtitle: Text('Rating: ${recipe.rating}, Time: ${recipe.time} mins'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailsScreen(recipe: recipe),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditRecipeScreen(recipe: recipe),
                          ),
                        ).then((value) => setState(() {})); // Refresh on return
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await dbHelper.deleteRecipe(recipe.docId!); // Assuming `docId` is stored in Recipe
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditRecipeScreen()),
          ).then((value) => setState(() {})); // Refresh on return
        },
      ),
    );
  }
}
