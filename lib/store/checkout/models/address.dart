class AddressModel {
  String? houseNumber;
  String? street;
  String? area;
  String? province;
  double? latitude;
  double?  longitude;
  String? floor;
  String? phone;
  bool? isDefault;

  AddressModel({
    this.houseNumber,
    this.street,
    this.area,
    this.province,
    this.latitude,
    this.longitude,
    this.floor,

  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    houseNumber = json['houseNumber'];
    street = json['street'];
    area = json['area'];
    province = json['province'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    floor = json['floor'];

  }

  Map<String, dynamic> toJson() {
    return {
      'houseNumber': houseNumber,
      'street': street,
      'area': area,
      'province': province,
      'latitude': latitude,
      'longitude': longitude,
      'floor': floor,

    };
  }


  toMap() {
    return {
      'houseNumber': houseNumber,
      'street': street,
      'area': area,
      'province': province,
      'latitude': latitude,
      'longitude': longitude,
      'floor': floor,
    };
  }
}