class AccessToken {
  String accessToken;
  String apiKey;
  String type;

  AccessToken(this.accessToken, this.apiKey, this.type);

  AccessToken.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'] as String,
        apiKey = json['api_key'] as String,
        type = json['type'] as String;

  Map<String, dynamic> toJson() =>
      {'access_token': accessToken, 'api_key': apiKey, 'type': type};
}
