class UserProfile {
  const UserProfile({
    this.fullName = '',
    this.headline = '',
    this.email = '',
    this.phone = '',
    this.location = '',
    this.website = '',
    this.linkedIn = '',
    this.summary = '',
  });

  final String fullName;
  final String headline;
  final String email;
  final String phone;
  final String location;
  final String website;
  final String linkedIn;
  final String summary;

  UserProfile copyWith({
    String? fullName,
    String? headline,
    String? email,
    String? phone,
    String? location,
    String? website,
    String? linkedIn,
    String? summary,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      headline: headline ?? this.headline,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      website: website ?? this.website,
      linkedIn: linkedIn ?? this.linkedIn,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fullName': fullName,
        'headline': headline,
        'email': email,
        'phone': phone,
        'location': location,
        'website': website,
        'linkedIn': linkedIn,
        'summary': summary,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        fullName: (json['fullName'] as String?) ?? '',
        headline: (json['headline'] as String?) ?? '',
        email: (json['email'] as String?) ?? '',
        phone: (json['phone'] as String?) ?? '',
        location: (json['location'] as String?) ?? '',
        website: (json['website'] as String?) ?? '',
        linkedIn: (json['linkedIn'] as String?) ?? '',
        summary: (json['summary'] as String?) ?? '',
      );
}
