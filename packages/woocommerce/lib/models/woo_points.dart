class WooPoints {
  final int? count;
  final List<WooPointsEvent>? events;
  final int? page;
  final int? pointsBalance;
  final String? pointsLabel;

  const WooPoints({
    this.count,
    this.events,
    this.page,
    this.pointsBalance,
    this.pointsLabel,
  });

  factory WooPoints.fromJson(Map<String, dynamic> json) {
    return WooPoints(
      count: json['count'],
      events: json['events'] != null
          ? (json['events'] as List)
              .map((i) => WooPointsEvent.fromJson(i))
              .toList()
          : <WooPointsEvent>[],
      page: json['page'],
      pointsBalance: json['points_balance'],
      pointsLabel: json['points_label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['page'] = page;
    data['points_balance'] = pointsBalance;
    data['points_label'] = pointsLabel;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WooPointsEvent {
  final String? adminUserId;
  final String? date;
  final String? dateDisplay;
  final String? dateDisplayHuman;
  final String? description;
  final String? id;
  final String? orderId;
  final String? points;
  final String? type;
  final String? userId;
  final String? userPointsId;

  const WooPointsEvent({
    this.adminUserId,
    this.date,
    this.dateDisplay,
    this.dateDisplayHuman,
    this.description,
    this.id,
    this.orderId,
    this.points,
    this.type,
    this.userId,
    this.userPointsId,
  });

  factory WooPointsEvent.fromJson(Map<String, dynamic> json) {
    return WooPointsEvent(
      adminUserId: json['admin_user_id'],
      date: json['date'],
      dateDisplay: json['date_display'],
      dateDisplayHuman: json['date_display_human'],
      description: json['description'],
      id: json['id'],
      orderId: json['order_id'],
      points: json['points'],
      type: json['type'],
      userId: json['user_id'],
      userPointsId: json['user_points_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['admin_user_id'] = adminUserId;
    map['date'] = date;
    map['date_display'] = dateDisplay;
    map['date_display_human'] = dateDisplayHuman;
    map['description'] = description;
    map['id'] = id;
    map['order_id'] = orderId;
    map['points'] = points;
    map['type'] = type;
    map['user_id'] = userId;
    map['user_points_id'] = userPointsId;
    return map;
  }
}
