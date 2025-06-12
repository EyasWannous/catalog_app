import 'package:catalog_app/features/categroy/domain/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required int page,
    required int totalCount,
    required int resultCount,
    required int resultsPerPage,
  }) : super(
          page: page,
          totalCount: totalCount,
          resultCount: resultCount,
          resultsPerPage: resultsPerPage,
        );

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'],
      totalCount: json['totalCount'],
      resultCount: json['resultCount'],
      resultsPerPage: json['resultsPerPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'totalCount': totalCount,
      'resultCount': resultCount,
      'resultsPerPage': resultsPerPage,
    };
  }
}