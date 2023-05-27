// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class ProductsDetailScreen extends StatefulWidget {
//   final Products productList;
//     ProductsDetailScreen({Key? key,required this.productList}) : super(key: key);
//
//   @override
//   State<ProductsDetailScreen> createState() => _ProductsDetailScreenState();
// }
//
// class _ProductsDetailScreenState extends State<ProductsDetailScreen> {
//   CartController cartController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//
//     return ResponsiveLayout(mobileBody: ProductDetailsMob(productList: widget.productList,), tabletBody:ProductDetailsMob(productList: widget.productList,), desktopBody: ProductDetailDesktop(productList: widget.productList,));
//   }
// }
//
//
//
//
// class ProductDetailDesktop extends StatefulWidget {
//   final Products productList;
//   const ProductDetailDesktop({Key? key,required this.productList}) : super(key: key);
//
//   @override
//   _ProductDetailDesktopState createState() => _ProductDetailDesktopState();
// }
//
// class _ProductDetailDesktopState extends State<ProductDetailDesktop> {
//   CartController cartController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBodyBehindAppBar: true,
//       appBar: PreferredSize(
//         preferredSize: Size(screenSize.width,screenSize.height*3),
//         child: NavigationBarView(),
//       ),
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     height: screenSize.height*0.6,
//                     margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.03,vertical:screenSize.height*0.1),
//                     decoration: BoxDecoration(
//                         color: Colors.yellow,
//                         image: DecorationImage(
//                             image: AssetImage(widget.productList.imagePath!),fit: BoxFit.cover
//                         )
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: screenSize.height*0.8,
//                     padding: EdgeInsets.symmetric(horizontal:  screenSize.width*0.03,vertical: screenSize.height*0.1),
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(widget.productList.title!,style: TextStyle(color: Colors.black,fontSize :25,fontWeight:FontWeight.bold ),),
//                         Row(
//                           children: [
//                             Row(
//                               children:const [
//                                 Icon(Icons.star,color: Colors.green,size: 15),
//                                 Icon(Icons.star,color: Colors.green,size: 15),
//                                 Icon(Icons.star,color: Colors.green,size: 15),
//                                 Icon(Icons.star,color: Colors.green,size: 15),
//                                 Icon(Icons.star,color: Colors.green,size: 15),
//                               ],
//                             ),
//                             Text("(2 reviews)",style: TextStyle(color: Colors.black,fontSize :10,fontWeight:FontWeight.normal ),),
//                           ],
//                         ),
//                         const    SizedBox(height: 20,),
//                         const   Text("Most of us are familiar with the iconic design of the egg shaped chair floating in the air. The\nHanging Egg Chair is a critically acclaimed design that has enjoyed praise worldwide ever since\nthe distinctive sculptural shape was created.",style: TextStyle(color: Colors.black,fontSize :20,fontWeight:FontWeight.normal ),),
//                         const   SizedBox(height: 20,),
//                         Row(
//                           children:const [
//                             Text("Colors:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                             Text("Yellow",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//
//                           ],
//                         ),
//                         const  SizedBox(height: 20,),
//                         Text("\$${widget.productList.price}",style: TextStyle(color: Colors.green,fontSize :20,fontWeight:FontWeight.bold ),),
//                         const SizedBox(height: 20,),
//                         Row(
//                           children: [
//                             Container(
//                               width: 100,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(color: Colors.black,width: 1)
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   InkWell(
//                                     onTap: (){
//                                       cartController.addItem();
//                                     },
//                                     child:Icon(Icons.add,color: Colors.black,size: 15),
//                                   ),
//
//                                   Obx(()=> Text(cartController.numOfItems.toString().padLeft(2,'0'),style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),),
//                                   InkWell(
//                                     onTap: (){
//                                       cartController.removeItem();
//                                     },
//                                     child:Icon(Icons.remove,color: Colors.black,size: 15),
//                                   ),
//
//                                 ],
//                               ),
//
//                             ),
//                             const  SizedBox(width: 20,),
//                             MyBlackBtn(color: Colors.black, text: 'Add to Cart', onTap: (){
//                               cartController.addItemInCart(Products(
//                                   title: widget.productList.title,
//                                   price: widget.productList.price,
//                                   imagePath: widget.productList.imagePath
//                               ));
//                               Navigator.push(context, MaterialPageRoute(builder: (ctx)=>CartScreen(),));
//                             }),
//                             const  SizedBox(width: 10,),
//                             MyBlackBtn(color: Colors.black, text: 'Buy Now', onTap: (){
//                               Get.to(()=>BuyScreen(products: widget.productList));
//                             }),
//                           ],
//                         ),
//                         const  SizedBox(height: 20,),
//                         Row(
//                           children:const [
//                             Text("Availability:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                             Text(" In stock",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                           ],
//                         ),
//                         const  SizedBox(height: 10,),
//                         Row(
//                           children:const [
//                             Text("Product type:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                             Text(" Demo Type",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                           ],
//                         ),
//                         const SizedBox(height: 10,),
//                         Row(
//                           children:const [
//                             Text("Vendor:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                             Text(" Demo Vender",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                           ],
//                         ),
//                         const SizedBox(height: 10,),
//                         Row(
//                           children:const [
//                             Text("SKU:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                             Text(" N/A",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                           ],
//                         ),
//                         const SizedBox(height: 10,),
//                         Row(
//                           children:const [
//                             Text("Categories:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                             Text(" Chairs, Decor Art, Furniture, Home page, Lighting Lamp, Sofas",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             BlackFooter(screenSize: screenSize)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
// class ProductDetailsMob extends StatefulWidget {
//   final Products productList;
//   const ProductDetailsMob({Key? key,required this.productList}) : super(key: key);
//
//   @override
//   _ProductDetailsMobState createState() => _ProductDetailsMobState();
// }
//
// class _ProductDetailsMobState extends State<ProductDetailsMob> {
//   CartController cartController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBodyBehindAppBar: true,
//       appBar: PreferredSize(
//         preferredSize: Size(screenSize.width,screenSize.height*3),
//         child: NavigationBarView(),
//       ),
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 25,),
//             Container(
//               height: screenSize.height*0.4,
//               margin: EdgeInsets.symmetric(horizontal: 35,vertical:screenSize.height*0.05),
//               decoration: BoxDecoration(
//                   color: Colors.yellow,
//                   image: DecorationImage(
//                       image: AssetImage(widget.productList.imagePath!),fit: BoxFit.cover
//                   )
//               ),
//             ),
//             Container(
//               height: screenSize.height*0.7,
//               padding: EdgeInsets.symmetric(horizontal: 25,vertical: screenSize.height*0.01),
//               child:  SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.productList.title!,style: TextStyle(color: Colors.black,fontSize :25,fontWeight:FontWeight.bold ),),
//                     Row(
//                       children: [
//                         Row(
//                           children:const [
//                             Icon(Icons.star,color: Colors.green,size: 15),
//                             Icon(Icons.star,color: Colors.green,size: 15),
//                             Icon(Icons.star,color: Colors.green,size: 15),
//                             Icon(Icons.star,color: Colors.green,size: 15),
//                             Icon(Icons.star,color: Colors.green,size: 15),
//                           ],
//                         ),
//                         Text("(2 reviews)",style: TextStyle(color: Colors.black,fontSize :10,fontWeight:FontWeight.normal ),),
//                       ],
//                     ),
//                     const    SizedBox(height: 20,),
//                     const   Text("Most of us are familiar with the iconic design of the egg shaped chair floating in the air. The\nHanging Egg Chair is a critically acclaimed design that has enjoyed praise worldwide ever since\nthe distinctive sculptural shape was created.",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.normal ),),
//                     const   SizedBox(height: 20,),
//                     Row(
//                       children:const [
//                         Text("Colors:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                         Text("Yellow",style: TextStyle(color: Colors.black,fontSize :13,fontWeight:FontWeight.bold ),),
//
//                       ],
//                     ),
//                     const  SizedBox(height: 20,),
//                     Text("\$${widget.productList.price}",style: TextStyle(color: Colors.green,fontSize :20,fontWeight:FontWeight.bold ),),
//                     const SizedBox(height: 20,),
//                     Row(
//                       children: [
//                         Container(
//                           width: 100,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black,width: 1)
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               InkWell(
//                                 onTap: (){
//                                   cartController.addItem();
//                                 },
//                                 child:Icon(Icons.add,color: Colors.black,size: 15),
//                               ),
//
//                               Obx(()=> Text(cartController.numOfItems.toString().padLeft(2,'0'),style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),),
//                               InkWell(
//                                 onTap: (){
//                                   cartController.removeItem();
//                                 },
//                                 child:Icon(Icons.remove,color: Colors.black,size: 15),
//                               ),
//
//                             ],
//                           ),
//
//                         ),
//                         const  SizedBox(width: 20,),
//                         Expanded(
//                           child: MyBlackBtn(color: Colors.black, text: 'Add to Cart', onTap: (){
//                             cartController.addItemInCart(Products(
//                                 title: widget.productList.title,
//                                 price: widget.productList.price,
//                                 imagePath: widget.productList.imagePath
//                             ));
//                             Navigator.push(context, MaterialPageRoute(builder: (ctx)=>CartScreen(),));
//                           }),
//                         ),
//                         const  SizedBox(width: 10,),
//                         Expanded(child: MyBlackBtn(color: Colors.black, text: 'Buy Now', onTap: (){
//                           Get.to(()=>BuyScreen(products: widget.productList));
//                         })),
//                       ],
//                     ),
//                     const  SizedBox(height: 20,),
//                     Row(
//                       children:const [
//                         Text("Availability:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                         Text(" In stock",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                       ],
//                     ),
//                     const  SizedBox(height: 10,),
//                     Row(
//                       children:const [
//                         Text("Product type:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                         Text(" Demo Type",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                       ],
//                     ),
//                     const SizedBox(height: 10,),
//                     Row(
//                       children:const [
//                         Text("Vendor:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                         Text(" Demo Vender",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                       ],
//                     ),
//                     const SizedBox(height: 10,),
//                     Row(
//                       children:const [
//                         Text("SKU:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                         Text(" N/A",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),),
//                       ],
//                     ),
//                     const SizedBox(height: 10,),
//                     Row(
//                       children:const [
//                         Text("Categories:",style: TextStyle(color: Colors.black,fontSize :15,fontWeight:FontWeight.bold ),),
//                         Expanded(child: Text("  Chairs, Decor Art, Furniture, Home page, Lighting Lamp, Sofas",style: TextStyle(color: Colors.green,fontSize :12,fontWeight:FontWeight.normal ),)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             BlackFooterMobAndTablet()
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
