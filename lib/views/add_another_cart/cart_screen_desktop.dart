// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rubix/models/cart_list_model.dart';
// import '../../controllers/cartController.dart';
// import '../../widegts/black_bottom_footer.dart';
// import '../navigation_bar/navigation_bar_view.dart';
//
// class CartScreenDesktop extends StatelessWidget {
//   const CartScreenDesktop({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     CartController cartController = Get.find();
//     print(cartController.cartItem.isEmpty.toString());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBodyBehindAppBar: true,
//       appBar: PreferredSize(
//         preferredSize: Size(screenSize.width, screenSize.height * 3),
//         child: const NavigationBarView(),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: EdgeInsets.symmetric(
//                   horizontal: screenSize.width * 0.15,
//                   vertical: screenSize.height * 0.05),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Shopping cart',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold)),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     height: 45,
//                     color: Colors.grey[200],
//                     padding: const EdgeInsets.all(10),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Expanded(
//                             flex: 1,
//                             child: Text(' IMAGE',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold))),
//                         Expanded(
//                             flex: 1,
//                             child: Text('PRODUCT',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold))),
//                         Expanded(
//                             flex: 4,
//                             child: Text(
//                               'TOTAL',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.right,
//                             )),
//                       ],
//                     ),
//                   ),
//
//                   Container(
//                     height: screenSize.height * 0.7,
//                     child: Obx(
//                       () => cartController.cartItem.isEmpty
//                           ? const Center(
//                               child: Text(
//                               "your cart List is empty",
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 50),
//                             ))
//                           : ListView.builder(
//                               itemCount: cartController.cartItem.length,
//                               shrinkWrap: true,
//                               itemBuilder: (context, i) {
//                                 print(cartController.cartItem.length);
//                                 var currentItem = cartController.cartItem[i];
//                                 return Stack(
//                                   children: [
//                                     Card(
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Image.asset(
//                                             "${currentItem.products.imagePath}",
//                                             fit: BoxFit.cover,
//                                             height: 180,
//                                             width: 150,
//                                           ),
//                                           const SizedBox(
//                                             width: 35,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 20),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                     "${currentItem.products.title}",
//                                                     style: const TextStyle(
//                                                         fontSize: 20,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 Text(
//                                                     "\$ ${currentItem.products.price}",
//                                                     style: const TextStyle(
//                                                         fontSize: 15,
//                                                         color: Colors.green,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 const SizedBox(
//                                                   height: 15,
//                                                 ),
//                                                 Text(
//                                                     "Quantity ${currentItem.quantity}",
//                                                     style: const TextStyle(
//                                                         fontSize: 15,
//                                                         color: Colors.green,
//                                                         fontWeight:
//                                                             FontWeight.bold))
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Positioned(
//                                       right: 15,
//                                       top: 10,
//                                       child: IconButton(
//                                         onPressed: () {
//                                           cartController.removeItemFromCartList(
//                                               currentItem);
//                                         },
//                                         icon: const Icon(
//                                           Icons.cancel_outlined,
//                                           color: Colors.black,
//                                           size: 30,
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               }),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Obx(() => Text(
//                           "Total Quantity : ${cartController.totalQuantity.value.toString()}",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ))),
//                       Obx(() => Text(
//                           "Total Amount : ${cartController.totalAmount.value.toString()} \$",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ))),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             BlackFooter(screenSize: screenSize),
//           ],
//         ),
//       ),
//     );
//   }
// }
