import 'package:uuid/uuid.dart';

class CertificationItem {
  CertificationItem({
    String? id,
    this.name = '',
    this.issuer = '',
    this.issueDate = '',
    this.expiryDate = '',
    this.credentialId = '',
    this.url = '',
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final String issuer;
  final String issueDate;
  final String expiryDate;
  final String credentialId;
  final String url;

  CertificationItem copyWith({
    String? name,
    String? issuer,
    String? issueDate,
    String? expiryDate,
    String? credentialId,
    String? url,
  }) {
    return CertificationItem(
      id: id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'issuer': issuer,
        'issueDate': issueDate,
        'expiryDate': expiryDate,
        'credentialId': credentialId,
        'url': url,
      };

  factory CertificationItem.fromJson(Map<String, dynamic> json) =>
      CertificationItem(
        id: json['id'] as String?,
        name: (json['name'] as String?) ?? '',
        issuer: (json['issuer'] as String?) ?? '',
        issueDate: (json['issueDate'] as String?) ?? '',
        expiryDate: (json['expiryDate'] as String?) ?? '',
        credentialId: (json['credentialId'] as String?) ?? '',
        url: (json['url'] as String?) ?? '',
      );
}
