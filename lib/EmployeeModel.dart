class EmployeeModel {
  List<Users>? users;

  EmployeeModel(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((mapObj) {
        Users obj = Users(mapObj);
        users!.add(obj);
      });
    }
  }
}

class Users {
  int? id;
  String? firstName;
  String? lastName;
  String? maidenName;
  int? age;
  String? gender;
  String? image;
  Address? address;
  Company? company;

  Users(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    maidenName = json['maidenName'];
    age = json['age'];
    gender = json['gender'];
    image = json['image'];

  // Initializing Address object if address data is available
    address = json['address'] != null ? Address(json['address']) : null;

// Initializing Company object if company data is available
    company = json['company'] != null ? Company(json['company']) : null;
  }
}

class Address {
  String? state;
  String? country;
  Address(Map<String, dynamic> json) {
    state = json['state'];
    country = json['country'];
  }
}

class Company {
  String? title;

  Company(Map<String, dynamic> json) {
    title = json['title'];
  }
}
