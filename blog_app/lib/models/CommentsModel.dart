class CommentsModel {
  String sId;
  User user;
  String blog;
  String content;
  String createdAt;
  String updatedAt;
  int iV;

  CommentsModel(
      {this.sId,
      this.user,
      this.blog,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    blog = json['blog'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['blog'] = this.blog;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String sId;
  String username;

  User({this.sId, this.username});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    return data;
  }
}
