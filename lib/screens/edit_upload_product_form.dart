// lib/screens/edit_upload_product_form.dart
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_smart/consts/app_constants.dart';
import 'package:shop_smart/consts/validater.dart';
import 'package:shop_smart/helpers/cloudinary_upload.dart';
import 'package:shop_smart/helpers/web_file_picker.dart';
import 'package:shop_smart/models/product_model.dart';
import 'package:shop_smart/services/my_app_functions.dart';
import 'package:shop_smart/widgets/subtitle_text.dart';
import 'package:shop_smart/widgets/title_text.dart';
import 'package:uuid/uuid.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';

  const EditOrUploadProductScreen({super.key, this.productModel});
  final ProductModel? productModel;

  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  Uint8List? _webImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;

  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }
    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController =
        TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController =
        TextEditingController(text: widget.productModel?.productQuantity);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      _webImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> localImagePicker() async {
    if (kIsWeb) {
      final pickedFile = await WebFilePicker.pickFile();
      if (pickedFile != null) {
        setState(() {
          _webImage = pickedFile;
          _pickedImage = null;
        });
      }
      return;
    }

    final picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: removePickedImage,
    );
  }

  Future<void> _uploadProduct() async {
    if (_pickedImage == null && _webImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please pick an image",
        fct: () {},
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    try {
      String? imageUrl;
      if (kIsWeb && _webImage != null) {
        imageUrl = await CloudinaryService.uploadImageBytes(_webImage!);
      } else if (!kIsWeb && _pickedImage != null) {
        imageUrl = await CloudinaryService.uploadImage(file: File(_pickedImage!.path));
      }

      if (imageUrl == null) throw "Image upload failed";

      final String productId = const Uuid().v4();

      final productData = {
        "productId": productId,
        "productTitle": _titleController.text.trim(),
        "productPrice": _priceController.text.trim(),
        "productCategory": _categoryValue ?? "Uncategorized",
        "productDescription": _descriptionController.text.trim(),
        "productImage": imageUrl,
        "productQuantity": _quantityController.text.trim(),
        "createdAt": Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection("products").doc(productId).set(productData);
      clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product uploaded successfully!")),
      );
    } catch (e) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    }
  }

  Future<void> _editProduct() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    try {
      String imageUrl = productNetworkImage ?? "";

      if (kIsWeb && _webImage != null) {
        final uploadedUrl = await CloudinaryService.uploadImageBytes(_webImage!);
        if (uploadedUrl != null) imageUrl = uploadedUrl;
      } else if (!kIsWeb && _pickedImage != null) {
        final uploadedUrl = await CloudinaryService.uploadImage(file: File(_pickedImage!.path));
        if (uploadedUrl != null) imageUrl = uploadedUrl;
      }

      await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.productModel!.productId)
          .update({
        "productTitle": _titleController.text.trim(),
        "productPrice": _priceController.text.trim(),
        "productCategory": _categoryValue ?? "Uncategorized",
        "productDescription": _descriptionController.text.trim(),
        "productImage": imageUrl,
        "productQuantity": _quantityController.text.trim(),
        "updatedAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully!")),
      );
    } catch (e) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear", style: TextStyle(fontSize: 20)),
                  onPressed: clearForm,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.upload),
                  label: Text(isEditing ? "Edit Product" : "Upload Product"),
                  onPressed: () {
                    if (isEditing) {
                      _editProduct();
                    } else {
                      _uploadProduct();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: TitlesTextWidget(
            label: isEditing ? "Edit Product" : "Upload a new product",
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (isEditing && productNetworkImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      productNetworkImage!,
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  )
                else if (_pickedImage == null && _webImage == null)
                  SizedBox(
                    width: size.width * 0.4 + 10,
                    height: size.width * 0.4,
                    child: DottedBorder(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image_outlined,
                                size: 80, color: Colors.blue),
                            TextButton(
                              onPressed: localImagePicker,
                              child: const Text("Pick Product Image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb && _webImage != null
                        ? Image.memory(
                            _webImage!,
                            height: size.width * 0.5,
                            alignment: Alignment.center,
                          )
                        : Image.file(
                            File(_pickedImage!.path),
                            height: size.width * 0.5,
                            alignment: Alignment.center,
                          ),
                  ),
                if (_pickedImage != null || productNetworkImage != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: localImagePicker,
                        child: const Text("Pick another image"),
                      ),
                      TextButton(
                        onPressed: removePickedImage,
                        child: const Text("Remove image",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                const SizedBox(height: 25),
                // ✅ Corrected Category Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    value: _categoryValue,
                    hint: const Text("Choose a Category"),
                    isExpanded: true,
                    items: AppConstants.CategoriesList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() => _categoryValue = value);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey('Title'),
                          maxLength: 80,
                          maxLines: 2,
                          decoration:
                              const InputDecoration(hintText: 'Product Title'),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                              value: value,
                              toBeReturnedString: "Please enter a valid title",
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _priceController,
                                key: const ValueKey('Price \$'),
                                keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Price',
                                  prefix: SubtitleTextWidget(
                                    label: "\$ ",
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString: "Price is missing",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: TextFormField(
                                controller: _quantityController,
                                key: const ValueKey('Quantity'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(hintText: 'Qty'),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString: "Quantity is missed",
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _descriptionController,
                          key: const ValueKey('Description'),
                          minLines: 5,
                          maxLines: 8,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Product description',
                          ),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                              value: value,
                              toBeReturnedString: "Description is missed",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kBottomNavigationBarHeight + 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
