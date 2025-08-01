class ReservationModel {
  String? promoCode;
  String? paymentMethod;
  int? quantity;
  String? friendname;
  int? eventId;
  int? userId;

  ReservationModel({
    this.promoCode,
    this.paymentMethod,
    this.quantity,
    this.friendname,
    this.eventId,
    this.userId,
  });

  ReservationModel.fromJson(Map<String, dynamic> json) {
    promoCode = json['promo_code'];
    paymentMethod = json['paymentMethod'];
    quantity = json['quantity'];
    friendname = json['friendname'];
    eventId = json['event_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promo_code'] = promoCode;
    data['paymentMethod'] = paymentMethod;
    data['quantity'] = quantity;
    data['friendname'] = friendname;
    data['event_id'] = eventId;
    data['user_id'] = userId;
    return data;
  }
}
