import 'package:user_management/pages/user_detail.dart';

import 'add_user.dart';
import '../api/api_support.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> userList = [];

  UserApi _user = UserApi();

  bool _isLoading = true;


  Future<void> fetchUsers() async {
    if (_isFetchingMore || !_hasMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    final newUsers = await _user.getUserList(page: _currentPage, limit: _limit);

    setState(() {
      if (newUsers.length < _limit) _hasMore = false;

      userList.addAll(newUsers);
      _filteredUsers = List.from(userList);

      _currentPage++;
      _isFetchingMore = false;
      _isLoading = false;
    });
  }

  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredUsers = [];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _limit = 20;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
        !_isFetchingMore &&
        _hasMore) {
      fetchUsers(); // fetch next page
    }
  }


  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchUsers();
  }

  Future<void> _refreshUserList() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _hasMore = true;
      userList.clear();
      _filteredUsers.clear();
    });

    await fetchUsers();

    setState(() {
      _isLoading = false;
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4.0,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, _) {
              return Switch(
                value: currentMode == ThemeMode.dark,
                onChanged: (val) {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (query) {
                setState(() {
                  _filteredUsers = userList.where((user) {
                    final fullName = '${user['firstName']} ${user['lastName']}'.toLowerCase();
                    return fullName.contains(query.toLowerCase());
                  }).toList();
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                ? Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            )
                : RefreshIndicator(
                  onRefresh: _refreshUserList,
                  child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _filteredUsers.length + (_hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                  if (index == _filteredUsers.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final user = _filteredUsers[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: Theme.of(context).brightness == Brightness.dark
                                ? [Colors.grey[850]!, Colors.grey[800]!]
                                : [Colors.blue[50]!, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetail(user: user),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(user['image']),
                          ),
                          title: Text(
                            '${user['firstName']} ${user['lastName']}',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                user['email'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user['company']['title'],
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(user['company']['name']),
                              Text(
                                '${user['address']['city']}, ${user['address']['state']}',
                                style: TextStyle(color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.orangeAccent,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddUser(user: user),
                                    ),
                                  ).then((value) {
                                    fetchUsers();
                                    setState(() {});
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text('Are you sure you want to delete this user?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                          ),
                                          child: const Text('Delete', style: TextStyle(color: Colors.white),),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    await _user.deleteUser(index: int.parse(user['id'].toString()));
                                    fetchUsers();
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                                },
                              ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(),
            ),
          ).then((value) {
            fetchUsers();
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
