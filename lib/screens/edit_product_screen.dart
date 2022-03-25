import 'package:flutter/material.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const String routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    final urlLostFocus = !_imageUrlFocusNode.hasFocus;
    final imageUrl = _imageUrlController.text;
    final imageUrlIsValid = imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        (imageUrl.endsWith('.jpg') || imageUrl.endsWith('.jpeg') || imageUrl.endsWith('.png'));
    if (urlLostFocus && imageUrlIsValid) {
      setState(() {}) ;
    }
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text('Title')),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value!,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (String? value) {
                  String? errorMessage;
                  value ??= "";
                  if (value.isEmpty) {
                    errorMessage = 'Please provide a value';
                  }
                  return errorMessage;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    price: double.parse(value!),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (String? value) {
                  String? errorMessage;
                  double? numberValue = double.tryParse(value ?? "");
                  if (numberValue == null) {
                    errorMessage = "Please enter a number";
                  } else if (numberValue <= 0) {
                    errorMessage = "Please enter a number greater than 0.";
                  }
                  return errorMessage;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    description: value!,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (String? value) {
                  String? errorMessage;
                  value ??= "";
                  if (value.length < 20) {
                    errorMessage = 'Please write at least 20 characters';
                  }
                  return errorMessage;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.cover)),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        id: _editedProduct.id,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        imageUrl: value!,
                      );
                    },
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (String? value) {
                      String? errorMessage;
                      value ??= "";
                      if (value.isEmpty) {
                        errorMessage = 'Please provide a value';
                      } else if (!value.startsWith('http')) {
                        errorMessage = 'Please enter a url';
                      } else if (!value.endsWith('.jpg') && !value.endsWith('.jpeg') && !value.endsWith('.png')) {
                        errorMessage = 'Please enter an image url';
                      }
                      return errorMessage;
                    },
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
