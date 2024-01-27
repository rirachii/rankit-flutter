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

  factory UserListRanking.fromMap(Map<String, dynamic> map) {
    return UserListRanking(
      userId: map['userId'],
      listId: map['listId'],
      visibility: map['visibility'],
      ranks: map['ranks'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'listId': listId,
      'visibility': visibility,
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