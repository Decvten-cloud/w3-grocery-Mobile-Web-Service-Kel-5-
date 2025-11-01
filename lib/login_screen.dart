import 'package:flutter/material.dart';

// Definisi warna yang konsisten
const Color w3Green = Color(0xFF006400);

//==================================================================
// 1. HALAMAN LOGIN (UTAMA)
//==================================================================
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Hijau dengan Logo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                color: w3Green,
                child: Column(
                  children: const [
                    Text(
                      'W3 Grocery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Putih
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                transform: Matrix4.translationValues(0, -20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    // --- FIELD EMAIL (GAYA OUTLINE) ---
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey.shade700,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // --- FIELD PASSWORD (GAYA OUTLINE) ---
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline,
                            color: Colors.grey.shade700),
                        suffixIcon: Icon(Icons.visibility_off_outlined,
                            color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Keep Sign In & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (val) {},
                              activeColor: w3Green,
                            ),
                            const Text('Keep Sign In'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen()));
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: w3Green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tombol SIGN IN
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: w3Green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Logika Sign In
                        },
                        child:
                            const Text('SIGN IN', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol CREATE AN ACCOUNT
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: w3Green,
                          side: BorderSide(color: w3Green.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()));
                        },
                        child: const Text('CREATE AN ACCOUNT',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//==================================================================
// 2. HALAMAN BUAT AKUN
//==================================================================
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: w3Green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create your account',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter your information to create an account.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // --- FIELD FULL NAME (GAYA OUTLINE) ---
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Full Name',
                prefixIcon:
                    Icon(Icons.person_outline, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- FIELD EMAIL (GAYA OUTLINE) ---
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon:
                    Icon(Icons.email_outlined, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // --- FIELD PASSWORD (GAYA OUTLINE) ---
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon:
                    Icon(Icons.lock_outline, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- FIELD CONFIRM PASSWORD (GAYA OUTLINE) ---
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                prefixIcon:
                    Icon(Icons.lock_outline, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol SIGN UP
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: w3Green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('SIGN UP', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==================================================================
// 3. HALAMAN LUPA PASSWORD (STEP 1: MASUKKAN EMAIL)
//==================================================================
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controller untuk mengambil teks email
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: w3Green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController, // Gunakan controller
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon:
                    Icon(Icons.email_outlined, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: w3Green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Ambil email dari controller
                  final email = _emailController.text;

                  // TODO: Tambahkan logika kirim email reset di sini

                  // Navigasi ke halaman Verifikasi Kode
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerificationScreen(email: email),
                    ),
                  );
                },
                child: const Text('SEND INSTRUCTIONS',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==================================================================
// 4. HALAMAN VERIFIKASI (STEP 2: MASUKKAN KODE)
//==================================================================
class VerificationScreen extends StatefulWidget {
  final String email; // Menerima email dari halaman sebelumnya
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // Controller untuk mengambil kode
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Enter Code'),
        backgroundColor: w3Green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check your email',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Menampilkan email yang dikirimi kode (menggunakan widget.email)
            Text(
              'We\'ve sent a 6-digit verification code to\n${widget.email}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _codeController, // Gunakan controller
              decoration: InputDecoration(
                hintText: 'Enter 6-digit code',
                prefixIcon:
                    Icon(Icons.pin_outlined, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6, // Batasi 6 digit
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, letterSpacing: 3),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: w3Green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // --- PERBAIKAN DIMULAI DI SINI ---
                  // Ambil kode dari controller
                  final code = _codeController.text;

                  // TODO: Ganti "123456" dengan logika verifikasi Anda
                  if (code == "123456") {
                    // Jika benar, navigasi ke halaman Reset Password
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResetPasswordScreen(email: widget.email),
                      ),
                    );
                  } else {
                    // Tampilkan pesan error jika kode salah
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Verification code is incorrect.')),
                    );
                  }
                  // --- AKHIR PERBAIKAN ---
                },
                child: const Text('VERIFY', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive the code?"),
                TextButton(
                  onPressed: () {
                    // TODO: Tambahkan logika kirim ulang kode
                  },
                  child: const Text('Resend', style: TextStyle(color: w3Green)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//==================================================================
// 5. HALAMAN RESET PASSWORD (STEP 3: PASSWORD BARU)
//==================================================================
class ResetPasswordScreen extends StatefulWidget {
  final String email; // Menerima email
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Controller untuk password baru
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: w3Green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create new password',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your new password must be different from previously used passwords.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // --- FIELD PASSWORD BARU ---
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'New Password',
                prefixIcon:
                    Icon(Icons.lock_outline, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- FIELD KONFIRMASI PASSWORD BARU ---
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm New Password',
                prefixIcon:
                    Icon(Icons.lock_outline, color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol RESET PASSWORD
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: w3Green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final newPassword = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;

                  // Cek jika password sama
                  if (newPassword.isEmpty || newPassword != confirmPassword) {
                    // Tampilkan error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match.')),
                    );
                    return;
                  }

                  // TODO: Tambahkan logika update password di database
                  //       untuk akun dengan email: widget.email

                  // Kembali ke halaman Login (hapus semua halaman di atasnya)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false, // Hapus semua (Reset, Verify, Forgot)
                  );
                },
                child: const Text('RESET PASSWORD',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}