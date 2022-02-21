class ProfileModel {
  Img img;
  String sId;
  String username;
  String name;
  String profession;
  String titleline;
  int iV;
  String dOB;
  String about;

  ProfileModel(
      {this.img,
      this.sId,
      this.username,
      this.name,
      this.profession,
      this.titleline,
      this.iV,
      this.dOB,
      this.about});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    img = json['img'] != null ? new Img.fromJson(json['img']) : null;
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
    profession = json['profession'];
    titleline = json['titleline'];
    iV = json['__v'];
    dOB = json['DOB'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.img != null) {
      data['img'] = this.img.toJson();
    }
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['name'] = this.name;
    data['profession'] = this.profession;
    data['titleline'] = this.titleline;
    data['__v'] = this.iV;
    data['DOB'] = this.dOB;
    data['about'] = this.about;
    return data;
  }
}

class Img {
  String url;
  String publicId;

  Img({this.url, this.publicId});

  Img.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['public_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['public_id'] = this.publicId;
    return data;
  }
}