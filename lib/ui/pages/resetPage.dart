import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginapp/others/contants.dart';

class ResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPageState();
  }
}

class _ResetPageState extends State<ResetPage> {
  bool _showAlert = false;
  String _retypePassword = "";
  String _password = "";
  late TextEditingController _retypePasswordController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _retypePasswordController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _retypePasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = 10;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          "Reset Password",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              _getLoginSection(),
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

  Widget _getRetypePassword() {
    return Container(
      child: CupertinoTextField(
        controller: _retypePasswordController,
        obscureText: true,
        style: TextStyle(fontSize: 16),
        placeholder: "Re-enter password",
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
            _retypePassword = c;
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
          _getPassword(),
          SizedBox(height: 5),
          _getRetypePassword(),
          _getResetPasswordButton(),
          _showAlert ? _getAlert() : Container(),
        ],
      ),
    );
  }

  Widget _getAlert() {
    return Row(
      children: [
        Text(
          "Password and re-enter password do not match.",
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget _getResetPasswordButton() {
    return ElevatedButton(
      child: Text("Reset Password"),
      onPressed: () async {
        bool isValid = await _validate();
        if (isValid) Navigator.pushReplacementNamed(context, '/navigate');
      },
    );
  }

  Future<bool> _validate() async {
    final String username =
        ModalRoute.of(context)!.settings.arguments as String;
    final storage = new FlutterSecureStorage();

    if (_retypePassword != _password) {
      setState(() {
        _showAlert = true;
      });
      return false;
    } else {
      storage.write(
          key: AppConstants.SECURE_STORAGE_KEY_USERNAME, value: username);
      storage.write(
          key: AppConstants.SECURE_STORAGE_KEY_PASSWORD, value: _password);
      setState(() {
        _showAlert = false;
      });
      return true;
    }
  }
}
