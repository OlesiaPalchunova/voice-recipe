

class UserDB{
  static String uid = "root";
  static String nickname = "User";

  static void addUser(String login, String display_name){
    uid = login;
    nickname = display_name;
  }

  static String setUserUid(){
    return uid;
  }

  static String setNickname(){
    return nickname;
  }

}