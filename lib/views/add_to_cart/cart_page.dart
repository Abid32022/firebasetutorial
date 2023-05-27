import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:start/views/add_to_cart/cartmodel.dart';
import 'package:start/widgets/custom_button.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Cart"),
          actions: <Widget>[

            custombutton2(text: "Clear",fontColor: Colors.white,ontap: () => ScopedModel.of<CartModel>(context).clearCart()),

          ],
        ),
        body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
            .cart
            .length ==
            0
            ? Center(
          child: Text("No items in Cart"),
        )
            : Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: ScopedModel.of<CartModel>(context,
                      rebuildOnChange: true)
                      .total,
                  itemBuilder: (context, index) {
                    return ScopedModelDescendant<CartModel>(
                      builder: (context, child, model) {
                        return ListTile(
                          title: Text(model.cart[index].title),
                          subtitle: Text(model.cart[index].qty.toString() +
                              " x " +
                              model.cart[index].price.toString() +
                              " = " +
                              (model.cart[index].qty *
                                  model.cart[index].price)
                                  .toString()),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    model.updateProduct(model.cart[index],
                                        model.cart[index].qty + 1);
                                    // model.removeProduct(model.cart[index]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    model.updateProduct(model.cart[index],
                                        model.cart[index].qty - 1);
                                    // model.removeProduct(model.cart[index]);
                                  },
                                ),
                              ]),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Total: \$ " +
                        ScopedModel.of<CartModel>(context,
                            rebuildOnChange: true)
                            .totalCartValue
                            .toString() +
                        "",
                    style: TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  )),
              custombutton2(
                text: "Buy Now",
                fontColor: Colors.white,
              ),
            ])));
  }
}
