import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/custom_text_form_field.dart';
import '../../../../core/shared_widgets/form_submit_button.dart';
import '../../domain/entities/category.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../widgets/image_picker_section.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;
  final int? parentId; // ✅ NEW: Support for hierarchical categories

  const CategoryFormScreen({super.key, this.category, this.parentId});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

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

  void _onImageChanged(File? imageFile) {
    setState(() {
      _imageFile = imageFile;
    });
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
      cubit.createCategory(
        name,
        description,
        _imageFile!,
        parentId: widget.parentId,
      );
    } else {
      cubit.updateCategory(
        widget.category!.id,
        name,
        description,
        _imageFile!, // Can be null to keep existing image
        parentId: widget.parentId ?? widget.category!.parentId,
      );
    }
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
                  ImagePickerSection(
                    initialImageFile: _imageFile,
                    initialImageUrl: widget.category?.imagePath,
                    onImageChanged: _onImageChanged,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Name',
                    validator: FormValidators.required('name'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    maxLines: 3,
                    validator: FormValidators.required('description'),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      final isLoading = state is CategoriesFormSubmitting;
                      return widget.category == null
                          ? FormSubmitButtonVariants.create(
                              onPressed: isLoading ? null : _submit,
                              isLoading: isLoading,
                            )
                          : FormSubmitButtonVariants.update(
                              onPressed: isLoading ? null : _submit,
                              isLoading: isLoading,
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
