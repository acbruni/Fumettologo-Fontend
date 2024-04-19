import 'package:flutter/material.dart';
import '../../model/model.dart';
import '../../model/objects/user.dart';
import '../../model/supports/login_result.dart';
import '../widgets/error_dialog.dart';
import 'ordini_utente.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogged = false;
  User? user;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      bool loggedIn = Model.sharedInstance.isLogged();
      setState(() {
        isLogged = loggedIn;
        if (isLogged) {
          fetchUser();
        }
      });
    } catch (e) {
      throw ('Error checking login status: $e');
    }
  }

  Future<void> handleLogin(void Function(LoginResult) resultCallback) async {
    try {
      final result =
      await Model.sharedInstance.login(emailController.text, passwordController.text);
      resultCallback(result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Si è verificato un errore. Riprova più tardi.'),
        ),
      );
    }
  }

  Future<void> fetchUser() async {
    try {
      final retrievedUser = await Model.sharedInstance.fetchUserProfile();
      setState(() {
        user = retrievedUser;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  void handleLogout() {
    setState(() {
      isLogged = false;
      emailController.clear();
      passwordController.clear();
      user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
        title: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white70),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined),
            color: Colors.white70,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdiniUtente()),
              );
            },
            tooltip: 'Ordini',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Container(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: !isLogged
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(25, 25, 112, 1.0),
                          width: 2.0,
                        ),
                        color: Color.fromRGBO(245, 245, 220, 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Fumettologo",
                            style: TextStyle(
                              fontFamily: "Serif",
                              fontSize: 54.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(25, 25, 112, 1.0),
                            ),
                          ),
                          const SizedBox(height: 45),
                          Stack(
                            children: [
                              SizedBox(
                                width: 325,
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    hintText: 'Email',
                                    prefixIcon: Icon(Icons.person),
                                    fillColor: Colors.white70,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: 325,
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Password',
                                fillColor: Colors.white70,
                                filled: true,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !isPasswordVisible,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
                            ),
                            onPressed: () {
                              handleLogin((LoginResult result) {
                                switch (result) {
                                  case LoginResult.logged:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Login effettuato con successo'),
                                        ));
                                    fetchUser();
                                    setState(() {
                                      isLogged = true;
                                    });
                                    break;
                                  case LoginResult.wrongCredentials:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Credenziali errate. Riprova.'),
                                        ));
                                    break;
                                  case LoginResult.unknownError:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Si è verificato un errore. Riprova più tardi.'),
                                        ));
                                    break;
                                }
                              });
                            },
                            child: const Text(
                              "Accedi",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'I tuoi dati personali',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(Icons.person, color: Colors.blue),
                                title: Text(
                                  'Nome e cognome',
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.email, color: Colors.blue),
                                title: Text(
                                  'Email',
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  '${user?.email ?? ''}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone, color: Colors.blue),
                                title: Text(
                                  'Cellulare',
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  '${user?.phone ?? ''}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on, color: Colors.blue),
                                title: Text(
                                  'Indirizzo',
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  '${user?.address ?? ''}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            bool loggedOut = await Model.sharedInstance.logOut();
                            if (loggedOut) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout effettuato con successo'),
                                ),
                              );
                              handleLogout();
                            } else {
                              showErrorDialog(context, "Impossibile effettuare il logout. Riprova.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
                          ),
                          child: const Text(
                            'Esci',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
