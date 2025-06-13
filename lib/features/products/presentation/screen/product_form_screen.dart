import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/product.dart';
import '../cubit/products_cubit.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final List<XFile> _images = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _categoryIdController.text = widget.product!.categoryId.toString();
      // If product has existing images, you can handle them too
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<ProductsCubit>();
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final categoryId = int.tryParse(_categoryIdController.text.trim()) ?? 0;

    if (widget.product == null) {
      cubit.createProduct(name, description, categoryId);
    } else {
      cubit.updateProduct(widget.product!.id, name, description, categoryId);
    }

    // TODO: You can handle image upload here if you want to send them
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Success!')),
          );
          Navigator.pop(context, state.product);
        } else if (state is ProductFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ✅ Images list preview
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _images.length) {
                          return GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.all(8),
                              color: Colors.grey[300],
                              child: const Icon(Icons.add_a_photo),
                            ),
                          );
                        } else {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.all(8),
                            child: Image.file(
                              File(_images[index].path),
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryIdController,
                    decoration: const InputDecoration(labelText: 'Category ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter category ID' : null,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      final isLoading = state is ProductFormSubmitting;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(widget.product == null ? 'Create' : 'Update'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
