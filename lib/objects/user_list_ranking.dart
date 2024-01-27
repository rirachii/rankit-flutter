class UserListRanking {
  String userId;
  String listId;
  String visibility;
  Map<String, int> ranks;


  UserListRanking({
    required this.userId,
    required this.listId,
    required this.visibility,
    required this.ranks,
  });

  // ...

  Map<String, dynamic> toMap() {
    // Sort the ranks map by value
    // var sortedRanks = ranks.entries.toList()
    //   ..sort((a, b) => a.value.compareTo(b.value));

    return {
      'userId': userId,
      'listId': listId,
      'ranks': ranks,
    };
  }
}


// {
//   "userId": "user1",
//   "listId": "list1",
//   "ranks": {
//     "item1": 1,
//     "item2": 2,
//     // More ranks...
//   }
// }