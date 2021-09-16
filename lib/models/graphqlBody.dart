class GraphqlBody {
  final String operationName;
  final String query;
  final Map<String,dynamic> variables;

  GraphqlBody({
    this.operationName,
    this.query,
    this.variables,
  });

  Map<String, dynamic> toJson() => {
        'operationName': operationName,
        'query': query,
        'variables': variables,
      };
}