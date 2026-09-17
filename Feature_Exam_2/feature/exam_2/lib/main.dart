import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF161213),
        useMaterial3: true,
      ),
      home: const SocialPage(),
    );
  }
}



class Friend {
  final String name;
  final String status;
  final String game;
  final bool online;
  final bool playing;
  final bool mobile;
  final String lastMessage;
  final String date;

  const Friend({
    required this.name,
    required this.status,
    required this.game,
    required this.online,
    required this.playing,
    required this.mobile,
    required this.lastMessage,
    required this.date,
  });
}



class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() {
    return _SocialPageState();
  }
}

class _SocialPageState extends State<SocialPage> {
  final String pageTitle = 'Social';

  final String friendsTab = 'Friends';
  final String messagesTab = 'Messages';
  final String requestsTab = 'Requests';

  final String searchHint = 'Search';

  final String valorantName = 'VALORANT';
  final int valorantCount = 3;

  final String onlineTitle = 'Online';
  final int onlineCount = 2;


  final List<Friend> valorantFriends = [
    Friend(
      name: 'MissYouLikeKrazy',
      status: 'Online',
      game: 'VALORANT',
      online: true,
      playing: false,
      mobile: false,
      lastMessage: 'Hey!',
      date: 'Today',
    ),
    Friend(
      name: 'bread',
      status: 'Playing',
      game: 'VALORANT',
      online: true,
      playing: true,
      mobile: false,
      lastMessage: 'Wanna play?',
      date: 'Today',
    ),
    Friend(
      name: 'The14th',
      status: 'Playing',
      game: 'VALORANT',
      online: true,
      playing: true,
      mobile: false,
      lastMessage: 'Let us play!',
      date: 'Last Year',
    ),
  ];



  final List<Friend> onlineFriends = [
    Friend(
      name: 'Carlvendish',
      status: 'Away',
      game: 'Riot Mobile',
      online: false,
      playing: false,
      mobile: true,
      lastMessage: 'Hello',
      date: 'Yesterday',
    ),
    Friend(
      name: 'D1yah',
      status: 'Away',
      game: 'Riot Mobile',
      online: false,
      playing: false,
      mobile: true,
      lastMessage: 'See you later',
      date: 'Today',
    ),
  ];



  void openChat(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChatScreen(friend: friend);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161213),

      body: SafeArea(
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.only(
                left: 21,
                top: 9,
                right: 21,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    pageTitle.isEmpty ? 'Social' : pageTitle,

                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [

                      _tab(friendsTab, true),

                      const SizedBox(width: 34),

                      _tab(messagesTab, false),

                      const SizedBox(width: 34),

                      _tab(requestsTab, false),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: 1,
                    color: const Color(0xFF352F30),
                  ),
                ],
              ),
            ),


            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 17,
                  bottom: 30,
                ),

                children: [



                  Container(
                    height: 51,

                    decoration: BoxDecoration(
                      color: const Color(0xFF231F20),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: const TextField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),

                      decoration: InputDecoration(
                        hintText: 'Search',

                        hintStyle: TextStyle(
                          color: Color(0xFFAAA5A6),
                          fontSize: 17,
                        ),

                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFAAA5A6),
                          size: 28,
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 23),


                  Row(
                    children: [


                      const Icon(
                        Icons.person,
                        color: Color(0xFFFFD54F),
                        size: 27,
                      ),

                      const SizedBox(width: 16),

                      Text(
                        valorantName.isEmpty
                            ? 'Unknown Game'
                            : valorantName,

                        style: const TextStyle(
                          color: Color(0xFFB9B5B6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        valorantCount.toString(),

                        style: const TextStyle(
                          color: Color(0xFF777273),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),



                  SizedBox(
                    height: valorantFriends.length * 75.0,

                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: valorantFriends.length,

                      itemBuilder: (context, index) {

                        Friend friend = valorantFriends[index];

                        return FriendTile(
                          friend: friend,
                          onTap: () {
                            openChat(friend);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),


                  Padding(
                    padding: const EdgeInsets.only(
                      left: 13,
                    ),

                    child: Row(
                      children: [

                        Text(
                          onlineTitle.isEmpty
                              ? 'Online'
                              : onlineTitle,

                          style: const TextStyle(
                            color: Color(0xFFB9B5B6),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 9),

                        Text(
                          onlineCount.toString(),

                          style: const TextStyle(
                            color: Color(0xFF777273),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: onlineFriends.length * 75.0,

                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: onlineFriends.length,

                      itemBuilder: (context, index) {

                        Friend friend = onlineFriends[index];

                        return FriendTile(
                          friend: friend,
                          onTap: () {
                            openChat(friend);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _tab(
      String text,
      bool selected,
      )
  {
    return Column(
      children: [

        Text(
          text.isEmpty ? 'Tab' : text,

          style: TextStyle(
            color: selected
                ? const Color(0xFFE6E1E2)
                : const Color(0xFFAAA5A6),

            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 13),

        Container(
          width: selected ? 40 : 0,
          height: 2,

          color: selected
              ? const Color(0xFFFF4655)
              : Colors.transparent,
        ),
      ],
    );
  }
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  const FriendTile({
    super.key,
    required this.friend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {



    final String name = friend.name.isEmpty
        ? 'Unknown User'
        : friend.name;

    final String status = friend.status.isEmpty
        ? 'Unknown'
        : friend.status;

    final String game = friend.game.isEmpty
        ? 'No Game'
        : friend.game;

    return InkWell(
      onTap: onTap,

      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,

        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 12,
          ),

          child: Row(
            children: [


              Stack(
                clipBehavior: Clip.none,

                children: [

                  Container(
                    width: 52,
                    height: 52,

                    decoration: const BoxDecoration(
                      color: Color(0xFF211E1F),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.person,
                      size: 31,

                      color: friend.online
                          ? const Color(0xFFFF4655)
                          : Colors.white,
                    ),
                  ),


                  Positioned(
                    right: -2,
                    bottom: 1,

                    child: friend.playing

                        ? const Icon(
                      Icons.play_circle,
                      size: 18,
                      color: Color(0xFF00AEEF),
                    )

                        : Container(
                      width: 16,
                      height: 16,

                      decoration: BoxDecoration(
                        color: friend.online
                            ? const Color(0xFF0BA66A)
                            : const Color(0xFFFFC20A),

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: const Color(0xFF161213),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      name,

                      style: const TextStyle(
                        color: Color(0xFFE7E2E3),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [

                        Icon(
                          friend.mobile
                              ? Icons.phone_android
                              : Icons.desktop_windows,

                          size: 17,

                          color: const Color(0xFFAAA5A6),
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            '$status - $game',

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Color(0xFFAAA5A6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Text(
                friend.date.isEmpty
                    ? 'No date'
                    : friend.date,

                style: const TextStyle(
                  color: Color(0xFF777273),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final Friend friend;

  const ChatScreen({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {

    final String name = friend.name.isEmpty
        ? 'Unknown User'
        : friend.name;

    final String message = friend.lastMessage.isEmpty
        ? 'No messages yet.'
        : friend.lastMessage;

    return Scaffold(
      backgroundColor: const Color(0xFF161213),

      appBar: AppBar(
        backgroundColor: const Color(0xFF231F20),

        title: Row(
          children: [

            const Icon(
              Icons.person,
              color: Color(0xFFFF4655),
            ),

            const SizedBox(width: 10),

            Text(name),
          ],
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),

              children: [

                Align(
                  alignment: Alignment.centerLeft,

                  child: Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: const Color(0xFF292425),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Text(
                      message,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  friend.date.isEmpty
                      ? 'Unknown date'
                      : friend.date,

                  style: const TextStyle(
                    color: Color(0xFF777273),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(12),

            child: Row(
              children: [

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF231F20),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Type daw Og message',

                        hintStyle: TextStyle(
                          color: Color(0xFF777273),
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message sent!'),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFFFF4655),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}