class Post {
  bool active;
  String city;
  String description;
  String experienceYears;
  String jobTitle;
  String major;
  String timestamp;
  String uid;

  Post({
    required this.active,
    required this.city,
    required this.description,
    required this.experienceYears,
    required this.jobTitle,
    required this.major,
    required this.timestamp,
    required this.uid,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      active: data['active'],
      city: data['city'],
      description: data['descreption'],
      experienceYears: data['experience_years'],
      jobTitle: data['job_title'],
      major: data['major'],
      timestamp: data['timestamp'],
      uid: data['uid'],
    );
  }
}
