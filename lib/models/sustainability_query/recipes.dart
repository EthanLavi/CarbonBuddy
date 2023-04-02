// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:graphql/client.dart';

recipeSearch(String name) async {
  final _httpLink = HttpLink(
    'https://production.suggestic.com/graphql',
  );

  final _authLink = AuthLink(
    getToken: () async => 'Token fadbbf24cf9e55b79d1ab2f25b404c1c1cb2bbaf',
  );

  Link _link = _authLink.concat(_httpLink);

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: _link,
  );

  String request =
      "{searchRecipeByNameOrIngredient(query: \"$name\") {onPlan {id}}}";

  final QueryOptions options = QueryOptions(document: gql(request));

  final QueryResult result = await client.query(options);

  if (result.hasException) {
    print(result.exception.toString());
  }

  return result.data!["searchRecipeByNameOrIngredient"]["onPlan"][0]["id"];
}

getIngredientListFromID(String id) async {
  final _httpLink = HttpLink(
    'https://production.suggestic.com/graphql',
  );

  final _authLink = AuthLink(
    getToken: () async => 'Token fadbbf24cf9e55b79d1ab2f25b404c1c1cb2bbaf',
  );

  Link _link = _authLink.concat(_httpLink);

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: _link,
  );

  String request = "{recipe(id: \"$id\") {ingredientLines}}";

  final QueryOptions options = QueryOptions(document: gql(request));

  final QueryResult result = await client.query(options);

  if (result.hasException) {
    print(result.exception.toString());
  }
  print(result.data!["recipe"]["ingredientLines"].runtimeType);

  return result.data!["recipe"]["ingredientLines"];
}

void main() async {
  getIngredientListFromID(await recipeSearch("menemen"));
}
