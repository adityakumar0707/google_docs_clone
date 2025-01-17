import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/repository/auth_repository.dart';
import 'package:google_docs/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';
import '../colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context)  async{
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await  ref.read(authRepositoryProvider).signInWithGoogle();
      if(errorModel!.error == null){
        print("5");
         ref.read(userProvider.notifier).update((state) => errorModel.data);
         navigator.replace('/');
    } else{
       sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error.toString())));
       print(errorModel.error.toString());
 }
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context) ,
          icon: Image.asset(
            'assets/images/g-logo-2.png',
            height: 20,
          ),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(
              color: kBlackColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor,
            //minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}