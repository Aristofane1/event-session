class ReviewModel {
  int? rate;
  String? description;
  List<String>? photos;
  int? userId;

  ReviewModel({this.rate, this.description, this.photos, this.userId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    description = json['description'];
    photos = json['photos'].cast<String>();
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['description'] = description;
    data['photos'] = photos;
    data['user_id'] = userId;
    return data;
  }
}
