import 'package:flutter/material.dart';
import '../../model/model.dart';
import '../../model/objects/registration_request.dart';
import '../../model/supports/constants.dart';
import '../widgets/error_dialog.dart';
import 'login.dart';

class Registrazione extends StatefulWidget {
  Registrazione({Key? key}) : super(key: key);

  @override
  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool checkTextFields() {
    return (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
        title: const Text(
          'Sing up',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white70),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(220, 220, 220, 1.0),
          ),
          Positioned.fill(
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 700,
                height: 500,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 220, 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Color.fromRGBO(25, 25, 112, 1.0),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      Constants.appName,
                      style: TextStyle(
                        fontFamily: "Serif",
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(25, 25, 112, 1.0),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: firstNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome',
                                  hintText: 'Nome',
                                  suffixIcon: Icon(Icons.person_2_outlined),
                                  fillColor: Colors.white70,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: lastNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cognome',
                                  hintText: 'Cognome',
                                  suffixIcon: Icon(Icons.person),
                                  fillColor: Colors.white70,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Indirizzo',
                                  hintText: 'Indirizzo',
                                  suffixIcon: Icon(Icons.location_on),
                                  fillColor: Colors.white70,
                                  filled: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Telefono',
                                  hintText: 'Telefono',
                                  suffixIcon: Icon(Icons.phone),
                                  fillColor: Colors.white70,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  hintText: 'Email',
                                  suffixIcon: Icon(Icons.email),
                                  fillColor: Colors.white70,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Password',
                                  fillColor: Colors.white70,
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                        !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
                      ),
                      onPressed: () async {
                        if (checkTextFields()) {
                          RegistrationRequest r = RegistrationRequest(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            address: addressController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          );
                          try {
                            await Model.sharedInstance.register(r);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Registrazione effettuata con successo. Effettua il login.'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        } else {
                          showErrorDialog(context, "Compila tutti i campi.");
                        }
                      },
                      child: const Text(
                        "Registrati",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromRGBO(25, 25, 112, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
