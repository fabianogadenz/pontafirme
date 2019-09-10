class Rating {
  int countLikes;
  int countDislikes;
  bool success;

  Rating({this.countLikes, this.countDislikes, this.success});

  Rating.fromJson(Map<String, dynamic> json) {
    countLikes = json['countLikes'];
    countDislikes = json['countDislikes'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countLikes'] = this.countLikes;
    data['countDislikes'] = this.countDislikes;
    data['success'] = this.success;
    return data;
  }
}