import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kami_saiyo_admin_panel/services/utils.dart';
import '../widgets/text_widget.dart';

class OrdersDet extends StatefulWidget {
  const OrdersDet(
      {Key? key,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate})
      : super(key: key);
  final double price, totalPrice;
  final String productId, userId, imageUrl, userName;
  final int quantity;
  final Timestamp orderDate;
  @override
  _OrdersDetState createState() => _OrdersDetState();
}

class _OrdersDetState extends State<OrdersDet> {
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,

                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      // Rp${widget.price.toStringAsFixed(2)
                      text: 'Quantity: ${widget.quantity} X',
                      color: color,
                      textSize: 30,
                      isTitle: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      // Rp${widget.price.toStringAsFixed(2)
                      text: 'Price: Rp${widget.price.toStringAsFixed(2)}',
                      color: color,
                      textSize: 30,
                      isTitle: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By',
                            color: Colors.blue,
                            textSize: 30,
                            isTitle: true,
                          ),
                          Text(
                            '  ${widget.userName}',
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Order Date: ' + orderDateStr,
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    )
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
