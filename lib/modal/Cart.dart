class Cart {
  String id;
  String image;
  String title;
  String price;
  String quantity;
  String q;

  Cart({this.id, this.image, this.title, this.price, this.quantity, this.q});

  Cart.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.image = map['image'];
    this.title = map['title'];
    this.price = map['price'];
    this.quantity = map['quantity'];
    this.q = map['q'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['image'] = image;
    map['title'] = title;
    map['price'] = price;
    map['quantity'] = quantity;
    map['q'] = q;

    return map;
  }
}
