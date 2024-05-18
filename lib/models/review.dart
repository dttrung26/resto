class Review {
  final int reviewId;
  final String reviewContent;
  final int star;
  final int restaurantId;
  final int userId;

  Review({
    required this.reviewId,
    required this.reviewContent,
    required this.star,
    required this.restaurantId,
    required this.userId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'] as int,
      reviewContent: json['reviewContent'] as String,
      star: json['star'] as int,
      restaurantId: json['resturantID'] as int,
      userId: json['userID'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'reviewContent': reviewContent,
      'star': star,
      'resturantID': restaurantId,
      'userID': userId,
    };
  }
}
