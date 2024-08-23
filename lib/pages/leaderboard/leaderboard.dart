import 'package:figenie/consts.dart';
import 'package:figenie/pages/another_user_profile/another_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:figenie/model/user.dart';
import 'package:figenie/services/user_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final UserService _userService = UserService();
  List<User> _userItems = [];
  List<User> otherUsers = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      // print('Error fetching user: $e');
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userService.getAllUsers();
      users.sort((a, b) => b.points.compareTo(a.points));
      setState(() {
        _userItems = users;
        otherUsers = users.length > 3 ? users.sublist(3) : [];
      });
    } catch (e) {
      // print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final topUsers = _userItems.take(3).toList();
    return Scaffold(
      body: Stack(
        children: [
          Container(color: backgroundColor),
          Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Leaderboard",
                style: TextStyle(color: textColor, fontSize: 28),
              ),
              const SizedBox(height: 16),
              ThreeBlocksRow(
                topUsers: topUsers,
                currentUser: _currentUser,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: otherUsers.length,
                      itemBuilder: (context, index) {
                        final item = otherUsers[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AnotherUserProfile(user: item),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 14, left: 22, right: 22, bottom: 14),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 4}',
                                  style: const TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: secondaryColor,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        NetworkImage(item.profilePicture),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  item.username,
                                  style: const TextStyle(
                                    color: textLightColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (item.id == _currentUser?.id)
                                  const Text(
                                    " (you)",
                                    style: TextStyle(
                                      color: textLighterColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                const Spacer(),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.points.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThreeBlocksRow extends StatelessWidget {
  final List<User> topUsers;
  final User? currentUser;

  const ThreeBlocksRow({super.key, required this.topUsers, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (topUsers.isNotEmpty)
          Container(
            width: 110,
            height: 190,
            decoration: const BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/crownSilver.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                const SizedBox(height: 5),
                CircleAvatar(
                  backgroundColor: silverColor,
                  radius: 35,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(topUsers[1].profilePicture),
                    radius: 33,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnotherUserProfile(user: topUsers[1]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  topUsers[1].username,
                  style: const TextStyle(
                    color: silverColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (topUsers[1].id == currentUser?.id)
                  const Text(
                    "(you)",
                    style: TextStyle(
                      color: textLighterColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 3),
                Container(
                  width: 65,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      topUsers[1].points.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: silverColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (topUsers.length > 1)
          Container(
            width: 140,
            height: 260,
            decoration: const BoxDecoration(
              color: foregroundColorLighter,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/crown.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 6),
                CircleAvatar(
                  backgroundColor: goldColor,
                  radius: 50,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(topUsers[0].profilePicture),
                    radius: 47,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnotherUserProfile(user: topUsers[0]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  topUsers[0].username,
                  style: const TextStyle(
                    color: goldColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (topUsers[0].id == currentUser?.id)
                  const Text(
                    "(you)",
                    style: TextStyle(
                      color: textLighterColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 5),
                Container(
                  width: 65,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      topUsers[0].points.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: goldColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (topUsers.length > 2)
          Container(
            width: 110,
            height: 190,
            decoration: const BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/crownBronze.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                const SizedBox(height: 5),
                CircleAvatar(
                  backgroundColor: bronzeColor,
                  radius: 35,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(topUsers[2].profilePicture),
                    radius: 33,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnotherUserProfile(user: topUsers[1]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  topUsers[2].username,
                  style: const TextStyle(
                    color: bronzeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (topUsers[2].id == currentUser?.id)
                  const Text(
                    "(you)",
                    style: TextStyle(
                      color: textLighterColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 3),
                Container(
                  width: 65,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      topUsers[2].points.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: bronzeColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
