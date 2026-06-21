import 'package:fitapp/screens/main_screen.dart';
import 'package:fitapp/screens/signup_screen.dart';
import 'package:fitapp/screens/user_info_screen.dart';
import 'package:fitapp/services/auth_service.dart';
import 'package:fitapp/services/firestore_sercive.dart';
import 'package:fitapp/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool isPasswordHidden = true;
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, 
        icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign In', style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),),
                        Text("Let's sign in with your SportUp account"),
                      ],
                    )),
                ),
            
                SizedBox(height: 30,),
            
                CustomTextField(
                hintText: 'Email@gmail.com', 
                prefixIcon: Icons.email, 
                controller: emailController, 
                validator: (value){
                  if(value == null ||!value.contains('@')){
                    return 'Email must contain @';
                    };
                    return null;
                  }                  
                ),

                SizedBox(height: 20,),
        
                CustomTextField(
                  hintText: '********',
                  labelText: 'Password',
                  obsecureText: isPasswordHidden,
                  prefixIcon: Icons.lock,
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  }, 
                  icon: Icon(isPasswordHidden 
                  ? Icons.visibility_off
                  : Icons.visibility
                  )
                  ),
                  controller: passwordController, 
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Please Enter Valid Password";
                    }

                    if(value.length < 8){
                      return 'Password must be at least 8 char';
                    }

                    if(!RegExp(r'[A-Z]').hasMatch(value)){
                      return 'Password must contain upper letter';
                    }
                    return null;
                  },
                ),
            
                SizedBox(height: 20,),
            
                InkWell(onTap: (){
                  //Go to recovering account page
                },
                child: Text('Forgot password?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
            
                SizedBox(height: 20,),
            
                SizedBox(
                      width: MediaQuery.of(context).size.width*.85,
                      height: height * .07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async{
                          if(formKey.currentState!.validate()){
                            final result = await _authService.signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            if (result == null) {
                              final user = _authService.currentUser;
                              if (user == null) return;

                              final uid = user.uid;

                              final doc = await FirestoreService().getUserData(uid);
                              final data = doc.data();

                              if (data?['profileCompleted'] == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const MainScreen()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const UserInfoScreen()),
                                );
                              }

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                            }
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields correctly'))
                            );
                          }
                          
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * .045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            
                    SizedBox(height: 20,),
                    Text('Or sign in with'),
                    SizedBox(height: 20,),
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            
                        Expanded(
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.black.withOpacity(.08),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
            
                                  Icon(
                                    Icons.facebook,
                                    size: 24,
                                  ),
            
                                  SizedBox(width: 10),
            
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
            
                        SizedBox(width: 15),
            
                        Expanded(
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.black.withOpacity(.08),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () async{
                                final userCredential =
                                    await _authService.signInWithGoogle();

                                if (userCredential != null) {
                                  final uid = userCredential.user!.uid;

                                  final doc =
                                      await FirestoreService().getUserData(uid);

                                  if (!doc.exists) {
                                    await FirestoreService().saveUserData(
                                      uid: uid,
                                      data: {
                                        'username': userCredential.user!.displayName ?? '',
                                        'email': userCredential.user!.email ?? '',
                                        'profileCompleted': false,
                                      },
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const UserInfoScreen(),
                                      ),
                                    );

                                  } else {
                                    final data = doc.data();

                                    if (data?['profileCompleted'] == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MainScreen(),
                                        ),
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const UserInfoScreen(),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
            
                                  FaIcon(
                                    FontAwesomeIcons.google,
                                    size: 20,
                                  ),
            
                                  SizedBox(width: 10),
            
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            
                    SizedBox(height: 20,),
            
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFF6C63FF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}