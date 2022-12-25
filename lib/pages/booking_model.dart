class BookingModel {
  String? bookType;
  String? buyerEmail;
  String? ownerId;
  String? buyerPhone;
  String? buyerName;
  String? videochat;
  String? bookId;
  String? buyerId;
  String? propertyId;
  String? date;
  String? pimage;
  bool? isExpired;
  String? status;

  BookingModel(
      {this.bookType,
      this.buyerEmail,
      this.ownerId,
      this.buyerPhone,
      this.buyerName,
      this.videochat,
      this.bookId,
      this.buyerId,
      this.propertyId,
      this.date,
      this.pimage,
      this.isExpired,
      this.status});

  BookingModel.fromJson(Map<String, dynamic> json) {
    bookType = json['book_type'];
    buyerEmail = json['buyer_email'];
    ownerId = json['owner_id'];
    buyerPhone = json['buyer_phone'];
    buyerName = json['buyer_name'];
    videochat = json['videochat'];
    bookId = json['book_id'];
    buyerId = json['buyer_id'];
    propertyId = json['property_id'];
    date = json['Date'];
    pimage = json['Pimage'];
    isExpired = json['isExpired'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_type'] = this.bookType;
    data['buyer_email'] = this.buyerEmail;
    data['owner_id'] = this.ownerId;
    data['buyer_phone'] = this.buyerPhone;
    data['buyer_name'] = this.buyerName;
    data['videochat'] = this.videochat;
    data['book_id'] = this.bookId;
    data['buyer_id'] = this.buyerId;
    data['property_id'] = this.propertyId;
    data['Date'] = this.date;
    data['Pimage'] = this.pimage;
    data['isExpired'] = this.isExpired;
    data['status'] = this.status;
    return data;
  }
}

