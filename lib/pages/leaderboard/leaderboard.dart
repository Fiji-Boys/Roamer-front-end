import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';
import 'package:figenie/model/user.dart' as fiji_user;
import 'package:figenie/services/user_service.dart';
import 'package:flutter/widgets.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final UserService _userService = UserService();
  List<fiji_user.User> _userItems = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userService.getAllUsers();
      users.sort((a, b) => b.points.compareTo(a.points));
      setState(() {
        _userItems = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              "assets/leaderboard.png",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.15,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _userItems.length,
                    itemBuilder: (context, index) {
                      final item = _userItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 15),
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(item.profilePicture),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
