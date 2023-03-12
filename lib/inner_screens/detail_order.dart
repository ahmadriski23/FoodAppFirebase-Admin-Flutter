import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = '/OrderDetails';

  const OrderDetails({Key? key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final orderProviders = Provider.of<OrdersProvider>(context);
    final getCurrentProduct = orderProviders.findProdById(productId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /* Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  getCurrentProduct.imageUrl,

                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ), */
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /* TextWidget(
                      text:
                          '${getCurrentProduct.quantity}X For Rp${getCurrentProduct.price}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ), */
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By',
                            color: Colors.blue,
                            textSize: 16,
                            isTitle: true,
                          ),
                          /* Text('  ${getCurrentProduct.userName}') */
                        ],
                      ),
                    ),
                    /* Text(
                      getCurrentProduct.orderDate.toString(),
                    ) */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
