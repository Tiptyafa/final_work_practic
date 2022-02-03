import 'dart:async';
import 'package:final_project/model/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/model/users.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<UserList> futureUserList;
  int _selectedIndex = -1;

  String? _userStoredName;
  String? _userStoredPass;

  bool _checkAuthorization() {
    if ((_userStoredName == '9112223344')&&(_userStoredPass == '12345')) {
      return true;
    }
    return false;
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userStoredName = (prefs.getString('userStoredName') ?? '');
      _userStoredPass = (prefs.getString('userStoredPass') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    futureUserList = fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkAuthorization()) {
      return Scaffold(
        appBar: myAppBar('Итог учёбы'),
        drawer: navDrawer(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FutureBuilder<UserList>(
                future: futureUserList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.items.length,
                      itemBuilder:(BuildContext context, int index) {
                        return SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(snapshot.data!.items[index].id.toString(),
                                      style: Theme.of(context).textTheme.bodyText2,)
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Text(snapshot.data!.items[index].name,
                                      style: Theme.of(context).textTheme.bodyText1,)
                                ),
                                Expanded(
                                    flex: 7,
                                    child: Text(snapshot.data!.items[index].email,
                                      style: Theme.of(context).textTheme.caption,
                                      textAlign: TextAlign.right,)
                                ),
                              ],
                            ),
                            selected: index == _selectedIndex,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              Navigator.pushNamed(
                                  context,
                                  '/tasks',
                                  arguments: snapshot.data!.items[index].id
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Ошибка: ${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Icon(Icons.verified_user, size: 50, color: Theme.of(context).primaryColor,),
                const SizedBox(height: 50),
                Text(
                  'Корректно введите логин или пароль',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
