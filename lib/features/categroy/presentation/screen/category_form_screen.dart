import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;

  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<CategoriesCubit>();
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (widget.category == null) {
      cubit.createCategory(name, description);
    } else {
      cubit.updateCategory(widget.category!.id, name, description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Success!'.tr())),
          );
          Navigator.pop(context, state.category);
        } else if (state is CategoriesFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category == null ? 'Add Category'.tr() : 'Edit Category'.tr()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ✅ Placeholder for image
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('Image Placeholder'),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'.tr()),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a name'.tr() : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'.tr()),
                  maxLines: 3,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a description'.tr() : null,
                ),
                const SizedBox(height: 20),
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    final isLoading = state is CategoriesFormSubmitting;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(widget.category == null ? 'Create'.tr() : 'Update'.tr()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
