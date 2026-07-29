class ListResponse<T> {
  final bool status;
  final List<T> items;
  final String? message;

  ListResponse({
    required this.status,
    required this.items,
    this.message,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return ListResponse(
      status: json['status'] == true || json['status'] == 'success',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => fromItem(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['msg'] as String? ?? json['message'] as String?,
    );
  }
}
