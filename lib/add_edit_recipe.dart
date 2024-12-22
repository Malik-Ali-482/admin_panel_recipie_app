import 'package:flutter/material.dart';
import 'models/recipe.dart'; // Import your Recipe model
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe; // Pass `null` for adding a new recipe
  const AddEditRecipeScreen({Key? key, this.recipe}) : super(key: key);

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _reviewsController = TextEditingController();
  final _timeController = TextEditingController();
  final _typeController = TextEditingController();
  final _calController = TextEditingController();
  final _imgController = TextEditingController();

  // Lists for dynamic form fields
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _instructionControllers = [];

  List<Ingredient> ingredients = [];
  List<Instruction> instructions = [];

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _populateExistingRecipeData();
    }
  }

  void _populateExistingRecipeData() {
    _nameController.text = widget.recipe!.name;
    _ratingController.text = widget.recipe!.rating;
    _reviewsController.text = widget.recipe!.reviews;
    _timeController.text = widget.recipe!.time;
    _typeController.text = widget.recipe!.type;
    _calController.text = widget.recipe!.cal;
    _imgController.text = widget.recipe!.img;

    for (var ingredient in widget.recipe!.ingredients) {
      _addIngredient(ingredient: ingredient);
    }
    for (var instruction in widget.recipe!.instructions) {
      _addInstruction(instruction: instruction);
    }
  }

  @override
  void dispose() {
    _disposeControllers([
      _nameController,
      _ratingController,
      _reviewsController,
      _timeController,
      _typeController,
      _calController,
      _imgController,
      ..._ingredientControllers,
      ..._instructionControllers,
    ]);
    super.dispose();
  }

  void _disposeControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void _addIngredient({Ingredient? ingredient}) {
    setState(() {
      final newIngredient = ingredient ?? Ingredient(name: '', quantity: '', type: '', image: '');
      ingredients.add(newIngredient);
      _ingredientControllers.addAll([
        TextEditingController(text: newIngredient.name),
        TextEditingController(text: newIngredient.quantity),
        TextEditingController(text: newIngredient.type),
        TextEditingController(text: newIngredient.image),
      ]);
    });
  }

  void _addInstruction({Instruction? instruction}) {
    setState(() {
      final newInstruction = instruction ?? Instruction(title: '', description: '', time: '');
      instructions.add(newInstruction);
      _instructionControllers.addAll([
        TextEditingController(text: newInstruction.title),
        TextEditingController(text: newInstruction.description),
        TextEditingController(text: newInstruction.time),
      ]);
    });
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      try {
        final recipeData = {
          'name': _nameController.text,
          'rating': _ratingController.text,
          'reviews': _reviewsController.text,
          'time': _timeController.text,
          'type': _typeController.text,
          'cal': _calController.text,
          'img': _imgController.text,
          'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
          'instructions': instructions.map((instruction) => instruction.toMap()).toList(),
        };

        final firestore = FirebaseFirestore.instance;

        if (widget.recipe == null) {
          // Add new recipe
          await firestore.collection('recipe_data').add(recipeData);
        } else {
          // Update existing recipe
          await firestore.collection('recipe_data').doc(widget.recipe!.docId).update(recipeData);
        }

        // Go back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        _showErrorSnackbar('Error saving recipe: $e');
      }
    }
  }


  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildIngredientForm(Ingredient ingredient, int index) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildTextField(
                  controller: _ingredientControllers[index * 4],
                  label: 'Ingredient Name',
                  onChanged: (value) => ingredients[index].name = value,
                ),
                _buildTextField(
                  controller: _ingredientControllers[index * 4 + 1],
                  label: 'Quantity',
                  onChanged: (value) => ingredients[index].quantity = value,
                ),
                _buildTextField(
                  controller: _ingredientControllers[index * 4 + 2],
                  label: 'Type',
                  onChanged: (value) => ingredients[index].type = value,
                ),
                _buildTextField(
                  controller: _ingredientControllers[index * 4 + 3],
                  label: 'Image URL',
                  onChanged: (value) => ingredients[index].image = value,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                ingredients.removeAt(index);
                _ingredientControllers.removeRange(index * 4, index * 4 + 4);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionForm(Instruction instruction, int index) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildTextField(
                  controller: _instructionControllers[index * 3],
                  label: 'Step ${index + 1} Title',
                  onChanged: (value) => instructions[index].title = value,
                ),
                _buildTextField(
                  controller: _instructionControllers[index * 3 + 1],
                  label: 'Description',
                  onChanged: (value) => instructions[index].description = value,
                ),
                _buildTextField(
                  controller: _instructionControllers[index * 3 + 2],
                  label: 'Time',
                  onChanged: (value) => instructions[index].time = value,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                instructions.removeAt(index);
                _instructionControllers.removeRange(index * 3, index * 3 + 3);
              });
            },
          ),
        ],
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(controller: _nameController, label: 'Recipe Name', onChanged: (_) {}),
              _buildTextField(controller: _ratingController, label: 'Rating', onChanged: (_) {}),
              _buildTextField(controller: _reviewsController, label: 'Reviews', onChanged: (_) {}),
              _buildTextField(controller: _timeController, label: 'Time (minutes)', onChanged: (_) {}),
              _buildTextField(controller: _typeController, label: 'Type', onChanged: (_) {}),
              _buildTextField(controller: _calController, label: 'Calories', onChanged: (_) {}),
              _buildTextField(controller: _imgController, label: 'Image URL', onChanged: (_) {}),
              const SizedBox(height: 20.0),
              const Text("Ingredients", style: TextStyle(fontSize: 20.0)),
              ...List.generate(
                ingredients.length,
                    (index) => _buildIngredientForm(ingredients[index], index),
              ),
              ElevatedButton(onPressed: () => _addIngredient(), child: const Text('Add Ingredient')),
              const SizedBox(height: 20.0),
              const Text("Instructions", style: TextStyle(fontSize: 20.0)),
              ...List.generate(
                instructions.length,
                    (index) => _buildInstructionForm(instructions[index], index),
              ),
              ElevatedButton(onPressed: () => _addInstruction(), child: const Text('Add Instruction')),
              ElevatedButton(
                onPressed: () {
                  _saveRecipe();
                  Navigator.pop(context);
                },
                child: Text(widget.recipe == null ? 'Add Recipe' : 'Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
