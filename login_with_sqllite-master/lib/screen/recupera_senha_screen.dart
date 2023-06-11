import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../common/messages/messages.dart';
import '../components/user_login_header.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _usuarioExiste = false;

  void _procurarUsuario() {
    final db = SqlLiteDb();
    db.verificarEmailExiste(_emailController.text.trim()).then((emailExiste) {
      setState(() {
        _usuarioExiste = emailExiste;
      });
      if (!_usuarioExiste) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erro"),
              content: Text("O usuário não foi encontrado."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void _atualizarSenha() {
    final db = SqlLiteDb();
    db
        .atualizarSenhaUsuario(
            _emailController.text.trim(), _newPasswordController.text.trim())
        .then((_) {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        title: MessagesApp.sucessoAtualizacaoSenha,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
        btnOkText: 'OK',
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esqueci minha senha'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserLoginHeader('recuperação de senha'),
              SizedBox(height: 20),
              UserTextField(
                hintName: 'E-mail',
                icon: Icons.email,
                controller: _emailController,
              ),
              ElevatedButton(
                onPressed: _procurarUsuario,
                child: Text('Procurar usuário'),
              ),
              if (_usuarioExiste) ...[
                SizedBox(height: 20),
                UserTextField(
                  hintName: 'Nova senha',
                  icon: Icons.lock,
                  controller: _newPasswordController,
                  isObscured: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _atualizarSenha,
                  child: Text('Atualizar senha'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
