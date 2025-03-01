

import 'package:anwer_shop/auth/sign_in_screen.dart';
import 'package:anwer_shop/core/colors.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
	late TabController tabController;

	@override
  void initState() {
    tabController = TabController(
			initialIndex: 0,
			length: 2, 
			vsync: this
		);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
			backgroundColor:Colors.blueGrey,
			body: SingleChildScrollView(
				child: BlurryContainer(
					borderRadius: BorderRadius.circular(40),
					blur: 10,
					color: ColorConstant.bgColor.withOpacity(0.5),
					elevation: 0,
				  child:  Column(
				  		mainAxisAlignment: MainAxisAlignment.center,
				  	  children: [
								SizedBox(height: MediaQuery.of(context).size.height / 10,),
				  	    SizedBox(
				  	    	height: MediaQuery.of(context).size.height / 1.8,
				  	    	child: Column(
				  	    		children: [
				  	    			Padding(
				  	    				padding: const EdgeInsets.symmetric(horizontal: 50.0),
				  	    				child: TabBar(
				  	    					controller: tabController,
				  	    					unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
				  	    					labelColor: Theme.of(context).colorScheme.onSurface,
				  	    					tabs: const [
				  	    						Padding(
				  	    							padding: EdgeInsets.all(12.0),
				  	    							child: Text(
				  	    								'تسجيل دخول',
				  	    								style: TextStyle(
				  	    									fontSize: 18,
																	color: Colors.white
				  	    								),
				  	    							),
				  	    						),
				  	    						Padding(
				  	    							padding: EdgeInsets.all(12.0),
				  	    							child: Text(
				  	    								'انشاء حساب',
				  	    								style: TextStyle(
				  	    									fontSize: 18,
																	color: Colors.white
				  	    								),
				  	    							),
				  	    						),
				  	    					],
				  	    				),
				  	    			),
				  	    			Expanded(
				  	    				child: TabBarView(
				  	    					controller: tabController,
				  	    					children: [
				  	    						BlocProvider<SignInBloc>(
				  	    							create: (context) => SignInBloc(
				  	    								userRepository: context.read<AuthenticationBloc>().userRepository
				  	    							),
				  	    							child: const SignInScreen(),
				  	    						),
				  	    						BlocProvider<SignUpBloc>(
				  	    							create: (context) => SignUpBloc(
				  	    								userRepository: context.read<AuthenticationBloc>().userRepository
				  	    							),
				  	    							child: const SignUpScreen(),
				  	    						),
				  	    					],
				  	    				)
				  	    			)
				  	    		],
				  	    	),
				  	    ),
				  	  ],
				  	),
				  ),
				),

		);
  }
}