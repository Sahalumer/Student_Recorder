import 'package:myproject/db_helper/repositery.dart';
import 'package:myproject/model/user.dart';

class Userservice {
  late Repository repository;
  Userservice() {
    repository = Repository();
  }
//save user
  saveUser(User user) async {
    return await repository.insertData("user", user.userMap());
  }

  //readallusers
  readAllUsers() async {
    return await repository.readData('user');
  }

  //editallusers
  updateUser(User user) async {
    return await repository.updateData('user', user.userMap());
  }

//delete user
  deleteUser(userId) async {
    return await repository.deleteDataById('user', userId);
  }
}
