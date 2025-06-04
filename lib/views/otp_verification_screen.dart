import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tickets_transporte/services/auth_serviceotp.dart';
import 'package:tickets_transporte/views/home_screen.dart';
import 'package:tickets_transporte/utils/colors.dart';
import 'package:tickets_transporte/utils/utils.dart';
import 'package:tickets_transporte/widgets/custom_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String telefone;

  const OTPVerificationScreen({
    Key? key,
    required this.telefone,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  TextEditingController _otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool _isLoading = false;
  bool _canResend = false;
  int _countdownSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    _startCountdown();
  }

  @override
  void dispose() {
    errorController?.close();
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _countdownSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _verificarOTP() async {
    if (_otpController.text.length != 6) {
      errorController?.add(ErrorAnimationType.shake);
      Utils.showSnackBar(
          context, 'Digite o código completo de 6 dígitos', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result =
          await AuthService.verifyOTP(widget.telefone, _otpController.text);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        Utils.showSnackBar(context, result['message'], Colors.green);

        // Navegar para a tela principal
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        errorController?.add(ErrorAnimationType.shake);
        Utils.showSnackBar(context, result['message'], Colors.red);
        _otpController.clear();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      errorController?.add(ErrorAnimationType.shake);
      Utils.showSnackBar(context, 'Erro ao verificar código: $e', Colors.red);
    }
  }

  void _reenviarOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.sendOTP(widget.telefone);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        Utils.showSnackBar(
            context, 'Código reenviado com sucesso!', Colors.green);
        _startCountdown();
        _otpController.clear();
      } else {
        Utils.showSnackBar(context, result['message'], Colors.red);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Utils.showSnackBar(context, 'Erro ao reenviar código: $e', Colors.red);
    }
  }

  String _formatPhone(String phone) {
    if (phone.startsWith('+258')) {
      return phone.replaceFirst('+258', '+258 *** *** ***');
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Ícone de verificação
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sms_outlined,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  'Verificação',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Digite o código de 6 dígitos enviado para\n${_formatPhone(widget.telefone)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Campo PIN
              PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length < 6) {
                    return null;
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: AppColors.primary,
                ),
                cursorColor: AppColors.primary,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: _otpController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) {
                  _verificarOTP();
                },
                onChanged: (value) {
                  setState(() {});
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),

              const SizedBox(height: 30),

              // Botão de Verificar
              CustomButton(
                text: 'Verificar Código',
                isLoading: _isLoading,
                onTap: _verificarOTP,
              ),

              const SizedBox(height: 30),

              // Reenviar código
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não recebeu o código? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: _canResend ? _reenviarOTP : null,
                    child: Text(
                      _canResend
                          ? 'Reenviar'
                          : 'Reenviar em ${_countdownSeconds}s',
                      style: TextStyle(
                        color:
                            _canResend ? AppColors.primary : Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        decoration: _canResend
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Informações de segurança
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Mantenha seu código seguro. Nunca o compartilhe com ninguém.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Footer com informação adicional
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Problemas com a verificação?\nEntre em contato conosco',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
