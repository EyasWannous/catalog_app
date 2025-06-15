import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalog_app/core/constants/api_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}'.tr())),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.category == null && _imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an image'.tr())));
      return;
    }

    final cubit = context.read<CategoriesCubit>();
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (widget.category == null) {
      cubit.createCategory(name, description, _imageFile!);
    } else {
      cubit.updateCategory(
        widget.category!.id,
        name,
        description,
        _imageFile!, // Can be null to keep existing image
      );
    }
  }

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_imageFile!, fit: BoxFit.cover),
              )
            : (widget.category?.imagePath != null &&
                  widget.category!.imagePath.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: ApiConstants.baseImageUrl + widget.category!.imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => _buildPlaceholderIcon(),
                ),
              )
            : _buildPlaceholderIcon(),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.image, size: 50, color: Colors.grey),
        const SizedBox(height: 8),
        Text(
          (widget.category?.imagePath != null &&
                  widget.category!.imagePath.isNotEmpty)
              ? 'Change Image'.tr()
              : 'Add Image'.tr(),
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Image Options'.tr()),
        actions: [
          if (_imageFile != null ||
              (widget.category?.imagePath != null &&
                  widget.category!.imagePath.isNotEmpty))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _imageFile = null;
                });
              },
              child: Text(
                'Remove Image'.tr(),
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: Text('Camera'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: Text('Gallery'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesFormSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Success!'.tr())));
          Navigator.pop(context, true);
        } else if (state is CategoriesFormError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category == null
                ? 'Add Category'.tr()
                : 'Edit Category'.tr(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'.tr()),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a name'.tr()
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'.tr()),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'.tr()
                        : null,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      final isLoading = state is CategoriesFormSubmitting;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                widget.category == null
                                    ? 'Create'.tr()
                                    : 'Update'.tr(),
                              ),
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
