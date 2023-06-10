

import '../favorite/itemmodel.dart';


class itemdetailsmodel {
  int? status;
  String? message;
  Data? data;
  List<itemmodel>? relateditems;

  itemdetailsmodel({this.status, this.message, this.data, this.relateditems});

  itemdetailsmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['relateditems'] != null) {
      relateditems = <itemmodel>[];
      json['relateditems'].forEach((v) {
        relateditems!.add(new itemmodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.relateditems != null) {
      data['relateditems'] = this.relateditems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'itemdetailsmodel{status: $status, message: $message, data: $data, relateditems: $relateditems}';
  }
}

class Data {
  int? id;
  String? itemName;
  String? itemType;
  String? preparationTime;
  String? price;
  String? isFavorite;
  String? isCart;
  dynamic itemQty;
  String? tax;
  List<ItemImages>? itemImages;
  String? itemDescription;
  CategoryInfo? categoryInfo;
  SubcategoryInfo? subcategoryInfo;
  String? hasVariation;
  String? attribute;
  List<Variation>? variation;
  List<Addons>? addons;

  Data(
      {this.id,
        this.itemName,
        this.itemType,
        this.preparationTime,
        this.price,
        this.isFavorite,
        this.isCart,
        this.itemQty,
        this.tax,
        this.itemImages,
        this.itemDescription,
        this.categoryInfo,
        this.subcategoryInfo,
        this.hasVariation,
        this.attribute,
        this.variation,
        this.addons});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    preparationTime = json['preparation_time'];
    price = json['price'];
    isFavorite = json['is_favorite'];
    isCart = json['is_cart'];
    itemQty = json['item_qty'];
    tax = json['tax'];
    if (json['item_images'] != null) {
      itemImages = <ItemImages>[];
      json['item_images'].forEach((v) {
        itemImages!.add(new ItemImages.fromJson(v));
      });
    }
    itemDescription = json['item_description'];
    categoryInfo = json['category_info'] != null
        ? new CategoryInfo.fromJson(json['category_info'])
        : null;
    subcategoryInfo = json['subcategory_info'] != null
        ? SubcategoryInfo.fromJson(json['subcategory_info'])
        : null;
    hasVariation = json['has_variation'];
    attribute = json['attribute'];
    if (json['variation'] != null) {
      variation = <Variation>[];
      json['variation'].forEach((v) {
        variation!.add(new Variation.fromJson(v));
      });
    }
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(new Addons.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'Data{id: $id, itemName: $itemName, itemType: $itemType, preparationTime: $preparationTime, price: $price, isFavorite: $isFavorite, isCart: $isCart, itemQty: $itemQty, tax: $tax, itemImages: $itemImages, itemDescription: $itemDescription, categoryInfo: $categoryInfo, subcategoryInfo: $subcategoryInfo, hasVariation: $hasVariation, attribute: $attribute, variation: $variation, addons: $addons}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['item_type'] = this.itemType;
    data['preparation_time'] = this.preparationTime;
    data['price'] = this.price;
    data['is_favorite'] = this.isFavorite;
    data['is_cart'] = this.isCart;
    data['item_qty'] = this.itemQty;
    data['tax'] = this.tax;
    if (this.itemImages != null) {
      data['item_images'] = this.itemImages!.map((v) => v.toJson()).toList();
    }
    data['item_description'] = this.itemDescription;
    if (this.categoryInfo != null) {
      data['category_info'] = this.categoryInfo!.toJson();
    }
    if (subcategoryInfo != null) {
      data['subcategory_info'] = subcategoryInfo!.toJson();
    }
    data['has_variation'] = this.hasVariation;
    data['attribute'] = this.attribute;
    if (this.variation != null) {
      data['variation'] = this.variation!.map((v) => v.toJson()).toList();
    }
    if (this.addons != null) {
      data['addons'] = this.addons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemImages {
  int? id;
  String? imageName;
  int? itemId;
  String? imageUrl;

  ItemImages({this.id, this.imageName, this.itemId, this.imageUrl});

  ItemImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageName = json['image_name'];
    itemId = json['item_id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_name'] = this.imageName;
    data['item_id'] = this.itemId;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class CategoryInfo {
  int? id;
  String? categoryName;
  String? slug;
  String? imageUrl;

  CategoryInfo({this.id, this.categoryName, this.slug, this.imageUrl});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Variation {
  int? id;
  int? itemId;
  String? variation;
  String? productPrice;
  String? salePrice;
  int? availableQty;

  Variation(
      {this.id,
        this.itemId,
        this.variation,
        this.productPrice,
        this.salePrice,
        this.availableQty});

  Variation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    variation = json['variation'];
    productPrice = json['product_price'];
    salePrice = json['sale_price'];
    availableQty = json['available_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['variation'] = this.variation;
    data['product_price'] = this.productPrice;
    data['sale_price'] = this.salePrice;
    data['available_qty'] = this.availableQty;
    return data;
  }

  @override
  String toString() {
    return 'Variation{id: $id, itemId: $itemId, variation: $variation, productPrice: $productPrice, salePrice: $salePrice, availableQty: $availableQty}';
  }
}
//
// class itemmodel {
//   int? id;
//   String? itemName;
//   String? itemType;
//   String? preparationTime;
//   String? price;
//   String? availableQty;
//   String? isFavorite;
//   String? isCart;
//   String? itemQty;
//   String? tax;
//   String? imageName;
//   String? imageUrl;
//   String? itemDescription;
//   CategoryInfo? categoryInfo;
//   SubcategoryInfo? subcategoryInfo;
//   String? hasVariation;
//   String? attribute;
//   List<Variation>? variation;
//   List<Addons>? addons;
//
//   itemmodel(
//       {this.id,
//         this.itemName,
//         this.itemType,
//         this.preparationTime,
//         this.price,
//         this.availableQty,
//         this.isFavorite,
//         this.isCart,
//         this.itemQty,
//         this.tax,
//         this.imageName,
//         this.imageUrl,
//         this.itemDescription,
//         this.categoryInfo,
//         this.subcategoryInfo,
//         this.hasVariation,
//         this.attribute,
//         this.variation,
//         this.addons});
//
//   itemmodel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     itemName = json['item_name'];
//     itemType = json['item_type'];
//     preparationTime = json['preparation_time'];
//     price = json['price'];
//     availableQty = json['available_qty'];
//     isFavorite = json['is_favorite'];
//     isCart = json['is_cart'];
//     itemQty = json['item_qty'];
//     tax = json['tax'];
//     imageName = json['image_name'];
//     imageUrl = json['image_url'];
//     itemDescription = json['item_description'];
//     categoryInfo = json['category_info'] != null
//         ? new CategoryInfo.fromJson(json['category_info'])
//         : null;
//     subcategoryInfo = json['subcategory_info'] != null
//         ? new SubcategoryInfo.fromJson(json['subcategory_info'])
//         : null;
//     hasVariation = json['has_variation'];
//     attribute = json['attribute'];
//     if (json['variation'] != null) {
//       variation = <Variation>[];
//       json['variation'].forEach((v) {
//         variation!.add(new Variation.fromJson(v));
//       });
//     }
//     if (json['addons'] != null) {
//       addons = <Addons>[];
//       json['addons'].forEach((v) {
//         addons!.add(new Addons.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['item_name'] = this.itemName;
//     data['item_type'] = this.itemType;
//     data['preparation_time'] = this.preparationTime;
//     data['price'] = this.price;
//     data['available_qty'] = this.availableQty;
//     data['is_favorite'] = this.isFavorite;
//     data['is_cart'] = this.isCart;
//     data['item_qty'] = this.itemQty;
//     data['tax'] = this.tax;
//     data['image_name'] = this.imageName;
//     data['image_url'] = this.imageUrl;
//     data['item_description'] = this.itemDescription;
//     if (this.categoryInfo != null) {
//       data['category_info'] = this.categoryInfo!.toJson();
//     }
//     if (this.subcategoryInfo != null) {
//       data['subcategory_info'] = this.subcategoryInfo!.toJson();
//     }
//     data['has_variation'] = this.hasVariation;
//     data['attribute'] = this.attribute;
//     if (this.variation != null) {
//       data['variation'] = this.variation!.map((v) => v.toJson()).toList();
//     }
//     if (this.addons != null) {
//       data['addons'] = this.addons!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class SubcategoryInfo {
  int? id;
  String? subcategoryName;
  String? slug;

  SubcategoryInfo({this.id, this.subcategoryName, this.slug});

  SubcategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subcategoryName = json['subcategory_name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subcategory_name'] = this.subcategoryName;
    data['slug'] = this.slug;
    return data;
  }
}