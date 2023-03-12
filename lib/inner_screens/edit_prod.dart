// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kami_saiyo_admin_panel/providers/dark_theme_provider.dart';
import 'package:kami_saiyo_admin_panel/screens/loading_manager.dart';
import 'package:kami_saiyo_admin_panel/services/global_methods.dart';
import 'package:kami_saiyo_admin_panel/services/utils.dart';
import 'package:kami_saiyo_admin_panel/widgets/buttons_widget.dart';
import 'package:kami_saiyo_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';
  const EditProductScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.price,
      required this.productCat,
      required this.imageUrl,
      required this.isPiece,
      required this.isOnSale,
      required this.stock,
      required this.salePrice});
  final String id, title, price, productCat, imageUrl;
  final bool isPiece, isOnSale, stock;
  final double salePrice;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController, _priceController;
// Category
  late String _catValue;
  late String _stockValue;
  // Sale
  String? _salePercent;
  late String percToShow;
  late double _salePrice;
  late bool _isOnSale;
  late bool _stock;
  // Image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  // kg or Piece,
  late int val;
  late bool _isPiece;
  // while loading
  bool _isLoading = false;
  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);
    // Set the variables
    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;
    _isPiece = widget.isPiece;
    _stock = widget.stock;
    val = _isPiece ? 1 : 1;
    _imageUrl = widget.imageUrl;
    // Calculate the percentage
    percToShow = (100 -
                (_salePrice * 100) /
                    int.parse(
                        widget.price)) // WIll be the price instead of 1.88
            .round()
            .toStringAsFixed(1) +
        '%';
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controllers
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage != null) {
          fb.StorageReference storageRef = fb
              .storage()
              .ref()
              .child('productsImages')
              .child(widget.id + 'jpg');
          final fb.UploadTaskSnapshot uploadTaskSnapshot =
              await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
          imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': _titleController.text,
          'price': _priceController.text,
          'salePrice': _salePrice,
          'imageUrl':
              _pickedImage == null ? widget.imageUrl : imageUri.toString(),
          'productCategoryName': _catValue,
          'isOnSale': _isOnSale,
          'isPiece': _isPiece,
          'stock': _stock,
        });
        await Fluttertoast.showToast(
            msg: "Produk telah diperbarui",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2);
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final themeState = Provider.of<DarkThemeProvider>(context);
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Produk',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: themeState.getDarkTheme ? Colors.black : Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: color)),
      ),
      // key: context.read<MenuController>().getEditProductscaffoldKey,
      // drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Header(
                //   showTexField: false,
                //   fct: () {
                //     context
                //         .read<MenuController>()
                //         .controlEditProductsMenu();
                //   },
                //   title: 'Edit this product',
                // ),
                Container(
                  width: size.width > 650 ? 650 : size.width,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextWidget(
                          text: 'Nama Produk',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey('Title'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Title';
                            }
                            return null;
                          },
                          decoration: inputDecoration,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: 'Harga Rp.',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: _priceController,
                                        key: const ValueKey('Price Rp'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Price is missed';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        decoration: inputDecoration,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextWidget(
                                      text: 'Kategori Produk',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      color: _scaffoldColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: catDropDownWidget(color),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: 'Satuan',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextWidget(text: 'Pcs', color: color),
                                        Radio(
                                          value: 1,
                                          groupValue: val,
                                          onChanged: (value) {
                                            setState(() {
                                              val = 1;
                                              _isPiece = true;
                                            });
                                          },
                                          activeColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _stock,
                                          onChanged: (newValuee) {
                                            setState(() {
                                              _stock = newValuee!;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextWidget(
                                          text: 'Stock',
                                          color: color,
                                          isTitle: true,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isOnSale,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _isOnSale = newValue!;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextWidget(
                                          text: 'Sale',
                                          color: color,
                                          isTitle: true,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(seconds: 1),
                                      child: !_isOnSale
                                          ? Container()
                                          : Row(
                                              children: [
                                                TextWidget(
                                                    text: "Rp" +
                                                        _salePrice
                                                            .toStringAsFixed(2),
                                                    color: color),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                salePourcentageDropDownWidget(
                                                    color),
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: size.width > 650
                                      ? 350
                                      : size.width * 0.45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: _pickedImage == null
                                        ? Image.network(_imageUrl)
                                        : (kIsWeb)
                                            ? Image.memory(
                                                webImage,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                _pickedImage!,
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: TextButton(
                                        onPressed: () {
                                          _pickImage();
                                        },
                                        child: TextWidget(
                                          text: 'Perbarui gambar',
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonsWidget(
                                onPressed: () async {
                                  GlobalMethods.warningDialog(
                                      title: 'Hapus?',
                                      subtitle: 'Tekan ok untuk konfirmasi',
                                      fct: () async {
                                        await FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(widget.id)
                                            .delete();
                                        await Fluttertoast.showToast(
                                          msg: "Produk telah diperbarui",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                        );
                                        while (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      context: context);
                                },
                                text: 'Hapus',
                                icon: IconlyBold.danger,
                                backgroundColor: Colors.red.shade700,
                              ),
                              ButtonsWidget(
                                onPressed: () {
                                  _updateProduct();
                                },
                                text: 'Perbarui',
                                icon: IconlyBold.setting,
                                backgroundColor: Colors.blue,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text('10%'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('15%'),
            value: '15',
          ),
          DropdownMenuItem<String>(
            child: Text('25%'),
            value: '25',
          ),
          DropdownMenuItem<String>(
            child: Text('50%'),
            value: '50',
          ),
          DropdownMenuItem<String>(
            child: Text('75%'),
            value: '75',
          ),
          DropdownMenuItem<String>(
            child: Text('0%'),
            value: '0',
          ),
        ],
        onChanged: (value) {
          if (value == '0') {
            return;
          } else {
            setState(() {
              _salePercent = value;
              _salePrice = double.parse(widget.price) -
                  (double.parse(value!) * double.parse(widget.price) / 100);
            });
          }
        },
        hint: Text(_salePercent ?? percToShow),
        value: _salePercent,
      ),
    );
  }

  DropdownButtonHideUnderline stockCheck(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: const [
          DropdownMenuItem<String>(
            child: Text('Kosong'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _stockValue = value!;
          });
        },
      ),
    );
  }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text('Nasi & Lauk Pauk'),
            value: 'Nasi & Lauk Pauk',
          ),
          DropdownMenuItem<String>(
            child: Text('Lauk Pauk'),
            value: 'Lauk Pauk',
          ),
          DropdownMenuItem<String>(
            child: Text('Kerupuk'),
            value: 'Kerupuk',
          ),
          DropdownMenuItem<String>(
            child: Text('Minuman'),
            value: 'Minuman',
          ),
          DropdownMenuItem<String>(
            child: Text('Lainnya'),
            value: 'Lainnya',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('Pilih Kategori'),
        value: _catValue,
      ),
    );
  }

  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log('Tidak ada yang dipilih');
        // showToast("Tidak ada yang dipilih");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log('Tidak ada yang dipilih');
      }
    } else {
      log('Perm not granted');
    }
  }
}
