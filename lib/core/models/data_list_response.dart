class DataListResponse<T> {
  final String status;
  final List<T> items;

  DataListResponse({
    required this.status,
    required this.items,
  });

  factory DataListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final data = json['data'] as Map<String, dynamic>?;
    return DataListResponse(
      status: json['status'] as String? ?? '',
      items: (data?['items'] as List<dynamic>?)
              ?.map((e) => fromItem(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
