import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:fitapp/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: const SizedBox(),
          bodyWidget: const SizedBox(),

          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            contentMargin: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            imagePadding: EdgeInsets.zero,
          ),

          image: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/track_workout.jpg',
                fit: BoxFit.cover,
              ),

              Container(
                color: Colors.black.withOpacity(0.3),
              ),

               Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Spacer(),

                     EasyRichText(
                      'Track Workouts \n Get Stronger',
                      defaultStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          targetString: 'Stronger',
                          style: TextStyle(
                          color: Colors.green,
                          ),
                        ),          
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('Track Your Workouts, monitor \n progress, and achieve your \n fitness goals step by step',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        ),

        PageViewModel(
          titleWidget: const SizedBox(),
          bodyWidget: const SizedBox(),

          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            contentMargin: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            imagePadding: EdgeInsets.zero,
          ),

          image: Stack(
            fit: StackFit.expand,
            children: [

              Image.asset(
                'assets/images/track_progress.jpg',
                fit: BoxFit.cover,
              ),

              Container(
                color: Colors.black.withOpacity(0.3),
              ),

               Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Spacer(),

                     EasyRichText(
                      'Track Progress \n See Results',
                      defaultStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          targetString: 'Results',
                          style: TextStyle(
                          color: Colors.green,
                          ),
                        ),          
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('Track body measurments, photos \n and stats. Visualize your progress \n and stay motivated.',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        ),

        PageViewModel(
          titleWidget: const SizedBox(),
          bodyWidget: const SizedBox(),

          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            contentMargin: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            imagePadding: EdgeInsets.zero,
          ),

          image: Stack(
            fit: StackFit.expand,
            children: [

              Image.asset(
                'assets/images/nutrition.jpg',
                fit: BoxFit.cover,
              ),

              Container(
                color: Colors.black.withOpacity(0.3),
              ),

               Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Spacer(),

                     EasyRichText(
                      'Track Nutrition \n Eat Better',
                      defaultStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          targetString: 'Better',
                          style: TextStyle(
                          color: Colors.green,
                          ),
                        ),          
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('Track calories, macros, and nutrients \n build easy eating habits \n that fit your lifestyle.',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 70,)
                  ],
                ),
              ),
            ],
          ),
        )

      ],

      showSkipButton: true,
      skip: Text('Skip',style: TextStyle(fontSize: 20,color: Colors.white),),
      onSkip: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LandingPage())),

      showNextButton: false,

      showDoneButton: true,
      done: Text('Done',style: TextStyle(fontSize: 20,color: Colors.white),),
      onDone: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LandingPage())),
    );
  }
}