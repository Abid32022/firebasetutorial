class CollectionModel{
  String image;
  int productsQuantity;
  String title;
  CollectionModel({required this.title,required this.image,required this.productsQuantity});
}

List<CollectionModel> collectionsItems = [
  CollectionModel(title: 'CHAIRS', image: 'assets/collection1.png', productsQuantity: 17),
  CollectionModel(title: 'Lighting Lamp', image: 'assets/collection2.png', productsQuantity: 12),
  CollectionModel(title: 'Décor Art', image: 'assets/collection3.png', productsQuantity: 22),
  CollectionModel(title: 'Clothes', image: 'assets/collection4.png', productsQuantity: 34),
  CollectionModel(title: 'Hanging Egg Chairs', image: 'assets/collection5.png', productsQuantity: 12),
  CollectionModel(title: 'Sports Items', image: 'assets/collection6.png', productsQuantity: 56),
];
