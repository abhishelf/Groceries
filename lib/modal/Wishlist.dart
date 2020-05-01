class Wishlist{

  String id;
  String image;
  String title;
  String price;
  String quantity;

  Wishlist({this.id, this.image, this.title, this.price, this.quantity});

  Wishlist.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.image = map['image'];
    this.title = map['title'];
    this.price = map['price'];
    this.quantity = map['quantity'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['image'] = image;
    map['title'] = title;
    map['price'] = price;
    map['quantity'] = quantity;

    return map;
  }
}