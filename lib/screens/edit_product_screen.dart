import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import '../shared/validators.dart';

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

  // varibles for handling form inputs
  String title = "";
  String price = "";
  String description = "";

  //other properties of product
  String? productId = "";
  bool isFavorite = false;

  EditingMode editingMode = EditingMode.add;

  bool _isInit = true;
  bool _isLoading = false;

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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        editingMode = EditingMode.edit;
        Product editedProduct = Provider.of<Products>(context, listen: false).findById(productId!);
        title = editedProduct.title;
        description = editedProduct.description;
        price = editedProduct.price.toString();
        _imageUrlController.text = editedProduct.imageUrl;
        isFavorite = editedProduct.isFavorite;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    final urlLostFocus = !_imageUrlFocusNode.hasFocus;
    final imageUrlIsValid = Validators.url(_imageUrlController.text);
    if (urlLostFocus && imageUrlIsValid) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    final products = Provider.of<Products>(context, listen: false);
    Product saveProduct = Product(
      id: productId,
      title: title,
      description: description,
      imageUrl: _imageUrlController.text,
      price: double.parse(price),
    );
    switch (editingMode) {
      case EditingMode.add:
        products.addProduct(saveProduct).catchError((error) {
          return showDialog<Null>(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('An error occured'),
                    content: Text('Something went wrong'),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.of(ctx).pop();
                      }, child: Text('Okay'))
                    ],
                  ));
        }).then((_) {
          Navigator.of(context).pop();
          setState(() {
            _isLoading = false;
          });
        });
        break;
      case EditingMode.edit:
        products.updateProduct(saveProduct);
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
        break;
    }
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: title,
                      decoration: InputDecoration(label: Text('Title')),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        title = value ?? "";
                      },
                      validator: (String? value) {
                        String? errorMessage;
                        if (Validators.required(value)) {
                          errorMessage = 'Please provide a value';
                        }
                        return errorMessage;
                      },
                    ),
                    TextFormField(
                      initialValue: price,
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        price = value ?? "";
                      },
                      validator: (String? value) {
                        String? errorMessage;
                        if (Validators.required(value)) {
                          errorMessage = "Please enter a value";
                        } else if (Validators.isNumber(value)) {
                          errorMessage = "Please enter a number";
                        } else if (Validators.minNumber(value, 0)) {
                          errorMessage = "Please enter a number greater than 0.";
                        }
                        return errorMessage;
                      },
                    ),
                    TextFormField(
                      initialValue: description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        description = value ?? "";
                      },
                      validator: (String? value) {
                        String? errorMessage;
                        int minLength = 20;
                        if (Validators.required(value)) {
                          errorMessage = "Please enter a value";
                        } else if (Validators.minLength(value, 20)) {
                          errorMessage = "Please add at least $minLength characters";
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
                                : FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.contain)),
                        Expanded(
                            child: TextFormField(
                                decoration: InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                validator: (String? value) {
                                  String? errorMessage;
                                  if (Validators.required(value)) {
                                    errorMessage = 'Please enter a value';
                                  } else if (Validators.url(value)) {
                                    errorMessage = 'Please enter a valid url';
                                  }

                                  return errorMessage;
                                }))
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          _saveForm();
                        },
                        child: const Text(
                          'SEND',
                          style: TextStyle(),
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}

enum EditingMode { add, edit }
