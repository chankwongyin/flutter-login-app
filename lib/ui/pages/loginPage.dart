import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginapp/modules/biometrics/biometricsController.dart';
import 'package:loginapp/others/contants.dart';
import 'package:loginapp/ui/components/components.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();
  var _box = Hive.box('configs');
  bool _isChecked = false;
  bool _showAlert = false;
  String _username = "";
  String _password = "";
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final _biometricsController = BiometricsController();

  @override
  void initState() {
    super.initState();
    _isChecked = _box.get(AppConstants.HIVE_CONFIG_IS_SAVED_PASSWORD);
    _initUsernameAndPassword();

    _usernameController = TextEditingController(text: _username);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initUsernameAndPassword() async {
    if (_isChecked) {
      _username =
          (await storage.read(key: AppConstants.SECURE_STORAGE_KEY_USERNAME))!;
      _password =
          (await storage.read(key: AppConstants.SECURE_STORAGE_KEY_PASSWORD))!;
    } else {
      _username = "";
      _password = "";
    }
    _usernameController = TextEditingController(text: _username);
    _passwordController = TextEditingController(text: _password);

    setState(() {
      _username = _username;
      _password = _password;
      _usernameController = _usernameController;
      _passwordController = _passwordController;
    });
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = 10;
    double width = MediaQuery.of(context).size.width;
    double bannerWidth =
        (width - horizontalPadding * 2) / 3 - horizontalPadding;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              _getLoginSection(),
              _getBannerSection(bannerWidth, horizontalPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPassword() {
    return Container(
      child: CupertinoTextField(
        controller: _passwordController,
        obscureText: true,
        style: TextStyle(fontSize: 16),
        placeholder: "Password",
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        onChanged: (c) {
          setState(() {
            _password = c;
          });
        },
      ),
    );
  }

  Widget _getUsername() {
    return Container(
      child: CupertinoTextField(
        controller: _usernameController,
        style: TextStyle(fontSize: 16),
        placeholder: "Username",
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        onChanged: (c) {
          setState(() {
            _username = c;
          });
        },
      ),
    );
  }

  Widget _getLoginSection() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getUsername(),
          SizedBox(height: 5),
          _getPassword(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getSwitcher(),
              ForgotPasswordButton(
                username: _username,
              ),
            ],
          ),
          _getLoginButton(),
          _showAlert ? _getAlert() : Container(),
        ],
      ),
    );
  }

  Widget _getAlert() {
    return Row(
      children: [
        Text(
          "Incorrect username or password",
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget _getLoginButton() {
    return ElevatedButton(
      child: Text("Login"),
      onPressed: () async {
        bool isValid = await _validate();
        print("isValid: $isValid");
        if (isValid) {
          if (!_isChecked) {
            _showAlertDialog(context);
          } else {
            _loginSucceed();
          }
        }
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Would you like to save this password?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              _box.put(AppConstants.HIVE_CONFIG_IS_SAVED_PASSWORD, true);
              _savePassword();
              _loginSucceed();
            },
            child: const Text('Yes'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              _loginSucceed();
            },
            child: const Text('Not Now'),
          )
        ],
      ),
    );
  }

  Widget _getSwitcher() {
    return Row(
      children: [
        CupertinoSwitch(
          value: _isChecked,
          onChanged: (bool value) {
            setState(() {
              _isChecked = value;
              if (value == false) {
                _password = "";
                _passwordController = TextEditingController(text: _password);
              } else {
                _box.put(AppConstants.HIVE_CONFIG_IS_SAVED_PASSWORD, true);
                storage.write(
                    key: AppConstants.SECURE_STORAGE_KEY_USERNAME,
                    value: _username);
                storage.write(
                    key: AppConstants.SECURE_STORAGE_KEY_PASSWORD,
                    value: _password);
              }
            });
            var box = Hive.box('configs');
            box.put(AppConstants.HIVE_CONFIG_IS_SAVED_PASSWORD, value);
          },
        ),
        Text("Save Password"),
      ],
    );
  }

  Widget _getBannerSection(double bannerWidth, double horizontalPadding) {
    return Row(
      children: [
        BannerWithImage(width: bannerWidth),
        SizedBox(width: horizontalPadding),
        BannerWithImage(width: bannerWidth),
        SizedBox(width: horizontalPadding),
        BannerWithImage(width: bannerWidth),
      ],
    );
  }

  Future<void> _loginSucceed() async {
    if (await _biometricsController.authenticateWithBiometrics()) {
      Navigator.pushReplacementNamed(context, '/navigate');
    }
  }

  Future<void> _savePassword() async {
    await storage.write(
        key: AppConstants.SECURE_STORAGE_KEY_USERNAME, value: _password);
    await storage.write(
        key: AppConstants.SECURE_STORAGE_KEY_USERNAME, value: _username);
  }

  Future<bool> _validate() async {
    if (_username.trim() ==
            await storage.read(key: AppConstants.SECURE_STORAGE_KEY_USERNAME) &&
        _password ==
            await storage.read(key: AppConstants.SECURE_STORAGE_KEY_PASSWORD)) {
      setState(() {
        _showAlert = false;
      });
      return true;
    } else {
      setState(() {
        _showAlert = true;
      });
      return false;
    }
  }
}
