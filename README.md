# loginapp

A new Flutter project.

## Getting Started

```
// Command
flutter clean
flutter pub get

// Hardcoded Login user
Username : testuser
Password : 123456
```


## TODO
- Include username, password, reset Password & Login UI component

- Request save password after first logon

- Reset password located in another screen and should auto login after reset

- Add three banner images at the bottom of login page.

- All data can be hard code in the app.

## Permanent Storage
### Hive
- Lightweight and blazing fast key-value database written in pure Dart. Strongly encrypted using AES-256.
  
### flutter_secure_storage
- Keychain is used for iOS
- KeyStore based solution is used in Android.
- AES encryption is used for Android. AES secret key is encrypted with RSA and RSA key is stored in KeyStore

## Sample Screens
![](https://github.com/chankwongyin/flutter-login-app/blob/master/images/login.png)
![](https://github.com/chankwongyin/flutter-login-app/blob/master/images/home.png)
![](https://github.com/chankwongyin/flutter-login-app/blob/master/images/after-login.png)


## License
[MIT](https://choosealicense.com/licenses/mit/)