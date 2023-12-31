import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/layoutCubit/layoutCubit.dart';
import 'package:social_app/layouts/homeLayoutScreen/home_layout_screen.dart';
import 'package:social_app/layouts/relatedToSpecificUser/cubit/cubit_specificUser.dart';
import 'package:social_app/modules/create_post/createPostScreen.dart';
import 'package:social_app/modules/edit_profile/editProfileScreen.dart';
import 'package:social_app/modules/sign_screens/cubit/signCubit.dart';
import 'package:social_app/modules/sign_screens/signScreens/login.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cacheHelper.dart';
import 'package:social_app/shared/styles/theme.dart';
import 'firebase_options.dart';
import 'lib/layouts/bloc_observer.dart';
import 'lib/modules/sign_screens/signScreens/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.cacheInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  userID = CacheHelper.getCacheData(key: 'uid');
  print("User ID is $userID");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:
        [
          BlocProvider(create: (BuildContext context)=>SignCubit()),
          BlocProvider(create: (BuildContext context)=>LayoutCubit()),
          BlocProvider(create: (BuildContext context)=>SpecificUserCubit()),
        ],
        child: MaterialApp(
          home: userID != null ? const HomeLayoutScreen() : LoginScreen(),
          // محتاج اعمل تعديل علي صفحه اسجيل الدخول بحيث يكون فيه البيانات زي الصوره والبايو بدل صفحه createUserImage بحيث تكون الداتا كلها بتتأخد لحظه تسجيل الدخول لأول مره
          debugShowCheckedModeBanner: false,
          theme: lightThemeData,
          routes:
          {
            'register' : (context)=>RegisterScreen(),
            'login' : (context)=>LoginScreen(),
            'createPostScreen' : (context)=> CreatePostScreen(),
            'editProfileScreen' : (context)=>EditProfileScreen(),
            'homeLayoutScreen' : (context)=>const HomeLayoutScreen(),
          },
        ),
    );
  }
}
