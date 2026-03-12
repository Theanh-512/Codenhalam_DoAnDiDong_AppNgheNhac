import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedRole = 'User';
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final success = await context.read<AuthProvider>().register(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      role: _selectedRole,
    );
    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công! Hãy đăng nhập.')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thất bại. Vui lòng kiểm tra lại.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tạo tài khoản',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              _usernameController,
              'Tên đăng nhập',
              Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email', Icons.email_outlined),
            const SizedBox(height: 16),
            _buildTextField(
              _fullNameController,
              'Họ và tên',
              Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _passwordController,
              'Mật khẩu',
              Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            const Text(
              'Bạn là:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Row(
              children: [
                _buildRoleRadio('Người nghe', 'User'),
                const SizedBox(width: 24),
                _buildRoleRadio('Nghệ sĩ', 'Artist'),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRoleRadio(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedRole,
          activeColor: Colors.green,
          onChanged: (val) => setState(() => _selectedRole = val!),
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
