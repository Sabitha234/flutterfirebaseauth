class UserDetails{
 late final String name;
 final String email;
 final String  phno;
 final String uid;
 UserDetails(

 {

 required this.name,
 required this.email,
 required this.phno,
 required this.uid,
});
Map<String,dynamic> storeToFirebaseStore(){
 return{
  'name':name,
  'email':email,
  'phone':phno,
  'uid':uid,
 };
}
 factory UserDetails.fromMap(Map<String,dynamic> map){
  return UserDetails(
      name: map['name']??'',
      email: map['email']??'',
      phno: map['phno']??'',
      uid:map['uid']??'');
 }

}