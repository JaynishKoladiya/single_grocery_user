// ignore_for_file: file_names, camel_case_types, prefer_collection_literals

class order_summary_model {
  dynamic status;
  dynamic message;
  Summery? summery;
  List<Data>? data;

  order_summary_model({this.status, this.message, this.summery, this.data});

  order_summary_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    summery =
        json['summery'] != null ? Summery.fromJson(json['summery']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (summery != null) {
      data['summery'] = summery!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'order_summary_model{status: $status, message: $message, summery: $summery, data: $data}';
  }
}

class Summery {
  dynamic orderTotal;
  dynamic tax;

  Summery({this.orderTotal, this.tax});

  Summery.fromJson(Map<String, dynamic> json) {
    orderTotal = json['order_total'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_total'] = orderTotal;
    data['tax'] = tax;
    return data;
  }

  @override
  String toString() {
    return 'Summery{orderTotal: $orderTotal, tax: $tax}';
  }
}

class Data {
  dynamic id;
  dynamic itemId;
  dynamic itemName;
  dynamic itemType;
  dynamic variationId;
  dynamic variation;
  dynamic addonsId;
  dynamic addonsName;
  dynamic addonsPrice;
  dynamic addonsTotalPrice;
  dynamic itemImage;
  dynamic itemPrice;
  dynamic qty;
  dynamic totalPrice;
  dynamic subscription_id;
  dynamic start_date;
  dynamic end_date;
  dynamic custom_day;

  Data(
      {this.id,
      this.itemId,
      this.itemName,
      this.itemType,
      this.variationId,
      this.variation,
      this.addonsId,
      this.addonsName,
      this.addonsPrice,
      this.addonsTotalPrice,
      this.itemImage,
      this.itemPrice,
      this.qty,
      this.totalPrice,
      this.subscription_id,
      this.start_date,
      this.end_date,
      this.custom_day,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    variationId = json['variation_id'];
    variation = json['variation'];
    addonsId = json['addons_id'];
    addonsName = json['addons_name'];
    addonsPrice = json['addons_price'];
    addonsTotalPrice = json['addons_total_price'];
    itemImage = json['item_image'];
    subscription_id = json['subscription_id'];
    start_date = json['start_date'];
    end_date = json['end_date'];
    custom_day = json['custom_day'];
    itemPrice = json['item_price'];
    qty = json['qty'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_type'] = itemType;
    data['variation_id'] = variationId;
    data['variation'] = variation;
    data['addons_id'] = addonsId;
    data['addons_name'] = addonsName;
    data['addons_price'] = addonsPrice;
    data['addons_total_price'] = addonsTotalPrice;
    data['item_image'] = itemImage;
    data['item_price'] = itemPrice;
    data['qty'] = qty;
    data['total_price'] = totalPrice;
    return data;
  }

  @override
  String toString() {
    return 'Data{id: $id, itemId: $itemId, itemName: $itemName, itemType: $itemType, variationId: $variationId, variation: $variation, addonsId: $addonsId, addonsName: $addonsName, addonsPrice: $addonsPrice, addonsTotalPrice: $addonsTotalPrice, itemImage: $itemImage, itemPrice: $itemPrice, qty: $qty, totalPrice: $totalPrice}';
  }
}
