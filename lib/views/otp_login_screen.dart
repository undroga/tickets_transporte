import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:tickets_transporte/services/auth_serviceotp.dart';
import 'package:tickets_transporte/views/otp_verification_screen.dart';
import 'package:tickets_transporte/views/signup_screen.dart';
import 'package:tickets_transporte/widgets/custom_button.dart';
import 'package:tickets_transporte/widgets/custom_textfield.dart';
import 'package:tickets_transporte/utils/colors.dart';
import 'package:tickets_transporte/utils/utils.dart';

class OTPLoginScreen extends StatefulWidget {
  static const String routeName = '/otp-login';

  const OTPLoginScreen({Key? key}) : super(key: key);

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final TextEditingController _telefoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Country _selectedCountry = Country(
    phoneCode: "258",
    countryCode: "MZ",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Mozambique",
    example: "Mozambique",
    displayName: "Mozambique",
    displayNameNoCountryCode: "MZ",
    e164Key: "",
  );

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void _enviarOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String telefoneCompleto =
        '+${_selectedCountry.phoneCode}${_telefoneController.text.trim()}';

    try {
      final result = await AuthService.sendOTP(telefoneCompleto);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        Utils.showSnackBar(context, result['message'], Colors.green);

        // Navegar para tela de verificação OTP
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              telefone: telefoneCompleto,
            ),
          ),
        );
      } else {
        Utils.showSnackBar(context, result['message'], Colors.red);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Utils.showSnackBar(context, 'Erro ao enviar código: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Login com OTP',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Digite seu número de telefone para receber o código de verificação',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 40),

                  // Campo de Telefone com Seletor de País
                  Text(
                    'Número de Telefone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Seletor de País
                      GestureDetector(
                        onTap: _selectCountry,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountry.flagEmoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+${_selectedCountry.phoneCode}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Campo de Telefone
                      Expanded(
                        child: CustomTextField(
                          controller: _telefoneController,
                          labelText: 'Telefone',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite seu número de telefone';
                            } else if (value.length < 9) {
                              return 'Número de telefone inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Botão de Enviar OTP
                  CustomButton(
                    text: 'Enviar Código',
                    isLoading: _isLoading,
                    onTap: _enviarOTP,
                  ),

                  const SizedBox(height: 30),

                  // Divisor
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OU',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Botão de Login com Email
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/email-login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Login com Email',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Link para Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta? ',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
