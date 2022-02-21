class BlogModel {
  CoverImage coverImage;
  int likes;
  List<String> likedUsers;
  int dislikes;
  List<String> dislikedUsers;
  List<String> comments;
  String sId;
  String user;
  String title;
  String body;
  String createdAt;
  String updatedAt;
  int iV;

  BlogModel(
      {this.coverImage,
      this.likes,
      this.likedUsers,
      this.dislikes,
      this.dislikedUsers,
      this.comments,
      this.sId,
      this.user,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.iV});

  BlogModel.fromJson(Map<String, dynamic> json) {
    coverImage = json['coverImage'] != null
        ? new CoverImage.fromJson(json['coverImage'])
        : null;
    likes = json['likes'];
    likedUsers = json['likedUsers'].cast<String>();
    dislikes = json['dislikes'];
    dislikedUsers = json['dislikedUsers'].cast<String>();
    comments = json['comments'].cast<String>();
    sId = json['_id'];
    user = json['user'];
    title = json['title'];
    body = json['body'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coverImage != null) {
      data['coverImage'] = this.coverImage.toJson();
    }
    data['likes'] = this.likes;
    data['likedUsers'] = this.likedUsers;
    data['dislikes'] = this.dislikes;
    data['dislikedUsers'] = this.dislikedUsers;
    data['comments'] = this.comments;
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['title'] = this.title;
    data['body'] = this.body;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class CoverImage {
  String url;
  String publicId;

  CoverImage({this.url, this.publicId});

  CoverImage.fromJson(Map<String, dynamic> json) {
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
