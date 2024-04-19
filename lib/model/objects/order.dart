class Order {
  final int id;
  final DateTime createTime;
  final double total;

  Order({
    required this.id,
    required this.createTime,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final createTimeList = json['createTime'] as List<dynamic>;
    final createTime = DateTime(
      createTimeList[0],
      createTimeList[1],
      createTimeList[2],
      createTimeList[3],
      createTimeList[4],
      createTimeList[5],
    );

    return Order(
      id: json['id'],
      createTime: createTime,
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createTime': [
        createTime.year,
        createTime.month,
        createTime.day,
        createTime.hour,
        createTime.minute,
        createTime.second,
      ],
      'total': total,
    };
  }
}