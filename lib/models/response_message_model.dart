class ResponseMessage {
  String? userQuery;
  String? chatId;
  String? data;

  ResponseMessage({this.userQuery, this.chatId, this.data});

  ResponseMessage.fromJson(Map<String, dynamic> json) {
    userQuery = json['userQuery'];
    chatId = json['chatId'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userQuery'] = userQuery;
    data['chatId'] = chatId;
    data['data'] = this.data;
    return data;
  }
}
