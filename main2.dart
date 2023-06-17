void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  String? _name;
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email address.';
                }

                if (!value.contains('@')) {
                  return 'Please enter a valid email address.';
                }

                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password.';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }

                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onSaved: (value) {
                _name = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              onSaved: (value) {
                _phoneNumber = value;
              },
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    // Go to login page.
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate form and sign up user.
                    if (_formKey.currentState!.validate()) {
                      _signUp();
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email address.';
                }

                if (!value.contains('@')) {
                  return 'Please enter a valid email address.';
                }

                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password.';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }

                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    // Go to sign up page.
                  },
                  child: const Text('Sign Up'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate form and login user.
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
