import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/impl/mongo_service_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mongoService = MongoServiceImpl();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initMongo();
  }

  Future<void> _initMongo() async {
    try {
      await _mongoService.connect();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to database: $e')),
      );
    }
  }

  Future<void> _handleLogin(BuildContext context, String userId) async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final exists = await _mongoService.checkUserExists(userId);
      
      if (!exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User does not exist')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'userId': userId},
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userIdController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _handleLogin(context, userIdController.text),
                    child: const Text('Continue'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mongoService.close();
    super.dispose();
  }
}