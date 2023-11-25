class Category {
  String title;
  String imageUrl;

  Category({
    required this.title,
    required this.imageUrl,
  });

  factory Category.fromJson(dynamic json) {
    return Category(title: json["title"], imageUrl: json["image"]);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['image'] = imageUrl;
    return map;
  }
}
