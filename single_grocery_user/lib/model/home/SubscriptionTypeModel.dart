class SubscriptionType {
  int? status;
  List<Data>? data;

  SubscriptionType({this.status, this.data});

  SubscriptionType.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? sId;
  String? subsType;
  int? isAvailable;
  String? updatedAt;

  Data({this.sId, this.subsType, this.isAvailable, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['s_id'];
    subsType = json['subs_type'];
    isAvailable = json['is_available'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['s_id'] = this.sId;
    data['subs_type'] = this.subsType;
    data['is_available'] = this.isAvailable;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}