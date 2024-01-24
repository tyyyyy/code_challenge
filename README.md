# technical_code_challenge

Technical Code Challenge.

## Overview
The application supports both dark and light modes to enhance user experience and accommodate different preferences and lighting conditions.
Users can toggle between these modes through the application settings.
To install the app download and double click or long press the app and follow the instructions


## State management with provider

Here is i have implemented 'provider' in my code:

## 1. Provider setup in LoginScreen
   -At the top of my loginScreen  widget, i have wrapped my entire widget tree with ChangeNotifierProvider.
   -The create callback is used to instantiate an instance of AuthProvider, which is then accessible to the entire widget tree beneath LoginScreen.
   -AuthProvider is likely a class that extends ChangeNotifier and is responsible for managing authentication-related state.
##   2.Accessing Provider in login method
   -In the login method, I use Provider.of<AuthProvider>(context) to access the instance of AuthProvider
   -I use this instance to call setAccessToken method, which presumably updates the authentication token in the AuthProvider state.
##   3.Error Handling and SnackBars
   -I've implemented a _showLoadingSnackbar method to display a circular loading indicator using a SnackBar when the login and registeration process is ongoing.
   -The ScaffoldMessenger.of(context).hideCurrentSnackBar(); is used to hide the loading indicator when the login and registration process is complete.
##   4.Navigating to Other Screens
   -After a successful login I navigate to the HomeScreen and After a successful Register Navigator to loginScreen.
   General Explanations

The provider package is efficiently used to manage and update the authentication state across different parts of my application.

The separation of concerns is maintained by having an AuthProvider responsible for authentication-related state.

SnackBars are used to display loading indicators and error messages, providing a user-friendly experience."# code_challenge" 
