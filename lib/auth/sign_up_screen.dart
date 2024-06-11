import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/store_items/views/store_view.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_state.dart';
import 'components/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
	const SignUpScreen({super.key});

	@override
	State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
	final passwordController = TextEditingController();
	final emailController = TextEditingController();
	final nameController = TextEditingController();
	final _formKey = GlobalKey<FormState>();
	IconData iconPassword = EvaIcons.eye;
	bool obscurePassword = true;
	bool signUpRequired = false;

	bool containsUpperCase = false;
	bool containsLowerCase = false;
	bool containsNumber = false;
	bool containsSpecialChar = false;
	bool contains8Length = false;

	@override
	Widget build(BuildContext context) {
		return BlocListener<SignUpBloc, SignUpState>(
			listener: (context, state) {
				if(state is SignUpSuccess) {
					setState(() {
						signUpRequired = false;
					});
					Navigator.pushReplacement(
							context,
							MaterialPageRoute(
									builder: (context) =>  HomeScreen()));
					// Navigator.pop(context);
				} else if(state is SignUpProcess) {
					setState(() {
						signUpRequired = true;
					});
				} else if(state is SignUpFailure) {
					if (state.failureType == SignUpFailureType.accountAlreadyExists) {
						ScaffoldMessenger.of(context).showSnackBar(
							const SnackBar(
								content: Text('An account with this email already exists.'),
							),
						);
					}
				}
			},
			child: Form(
				key: _formKey,
				child: Center(
					child: Column(
						children: [
							const SizedBox(height: 20),
							SizedBox(
								width: MediaQuery.of(context).size.width * 0.9,
								child: MyTextField(
										controller: emailController,
										hintText: 'Email',
										obscureText: false,
										keyboardType: TextInputType.emailAddress,
										prefixIcon: const Icon(EvaIcons.email),
										validator: (val) {
											if(val!.isEmpty) {
												return 'Please fill in this field';
											} else if(!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
												return 'Please enter a valid email';
											}
											return null;
										}
								),
							),
							const SizedBox(height: 10),
							SizedBox(
								width: MediaQuery.of(context).size.width * 0.9,
								child: MyTextField(
										controller: passwordController,
										hintText: 'Password',
										obscureText: obscurePassword,
										keyboardType: TextInputType.visiblePassword,
										prefixIcon: const Icon(EvaIcons.lock),
										onChanged: (val) {
											if(val!.contains(RegExp(r'[A-Z]'))) {
												setState(() {
													containsUpperCase = true;
												});
											} else {
												setState(() {
													containsUpperCase = false;
												});
											}
											if(val.contains(RegExp(r'[a-z]'))) {
												setState(() {
													containsLowerCase = true;
												});
											} else {
												setState(() {
													containsLowerCase = false;
												});
											}
											if(val.contains(RegExp(r'[0-9]'))) {
												setState(() {
													containsNumber = true;
												});
											} else {
												setState(() {
													containsNumber = false;
												});
											}
											if(val.contains(RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
												setState(() {
													containsSpecialChar = true;
												});
											} else {
												setState(() {
													containsSpecialChar = false;
												});
											}
											if(val.length >= 8) {
												setState(() {
													contains8Length = true;
												});
											} else {
												setState(() {
													contains8Length = false;
												});
											}
											return null;
										},
										suffixIcon: IconButton(
											onPressed: () {
												setState(() {
													obscurePassword = !obscurePassword;
													if(obscurePassword) {
														iconPassword = EvaIcons.eye;
													} else {
														iconPassword = EvaIcons.eyeOff;
													}
												});
											},
											icon: Icon(iconPassword),
										),
										validator: (val) {
											if(val!.isEmpty) {
												return 'Please fill in this field';
											} else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
												return 'Please enter a valid password';
											}
											return null;
										}
								),
							),
							const SizedBox(height: 10),
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												"⚈  1 uppercase",
												style: TextStyle(
														color: containsUpperCase
																? Colors.green
																: Colors.white
												),
											),
											Text(
												"⚈  1 lowercase",
												style: TextStyle(
														color: containsLowerCase
																? Colors.green
																: Colors.white
												),
											),
											Text(
												"⚈  1 number",
												style: TextStyle(
														color: containsNumber
																? Colors.green
																: Colors.white
												),
											),
										],
									),
									Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												"⚈  1 special character",
												style: TextStyle(
														color: containsSpecialChar
																? Colors.green
																: Colors.white
												),
											),
											Text(
												"⚈  8 minimum character",
												style: TextStyle(
														color: contains8Length
																? Colors.green
																:Colors.white
												),
											),
										],
									),
								],
							),
							const SizedBox(height: 10),
							SizedBox(
								width: MediaQuery.of(context).size.width * 0.9,
								child: MyTextField(
										controller: nameController,
										hintText: 'Name',
										obscureText: false,
										keyboardType: TextInputType.name,
										prefixIcon: const Icon(EvaIcons.person),
										validator: (val) {
											if(val!.isEmpty) {
												return 'Please fill in this field';
											} else if(val.length > 30) {
												return 'Name too long';
											}
											return null;
										}
								),
							),
							SizedBox(height: MediaQuery.of(context).size.height * 0.02),
							!signUpRequired
									? SizedBox(
								width: MediaQuery.of(context).size.width * 0.5,
								child: ElevatedButton(
										onPressed: () {
											if (_formKey.currentState!.validate()) {
												MyUser myUser = MyUser.empty;
												myUser = myUser.copyWith(
													email: emailController.text,
													name: nameController.text,
												);
												setState(() {
													context.read<SignUpBloc>().add(
															SignUpRequired(
																	myUser,
																	passwordController.text
															)
													);
												});
											}
										},
										style: ElevatedButton.styleFrom(
												elevation: 3.0,
												backgroundColor: ColorConstant.primaryColor,
												foregroundColor: Colors.white,
												shape: RoundedRectangleBorder(
														borderRadius: BorderRadius.circular(10)
												)
										),
										child: const Padding(
											padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
											child: Text(
												'Sign Up',
												textAlign: TextAlign.center,
												style: TextStyle(
														color: Colors.white,
														fontSize: 16,
														fontWeight: FontWeight.w600
												),
											),
										)
								),
							)
									:  loadingIndicator(
								color: Colors.white,
							)
						],
					),
				),
			),
		);
	}
}
