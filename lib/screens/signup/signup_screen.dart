import 'package:flutter/material.dart';
import 'package:lojavirtual/helpers/validators.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Users users = Users();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                ///========================================================
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Nome Completo'),
                  validator: (name) {
                    if (name.isEmpty) {
                      return 'Campo obrigatorio';
                    } else if (name.trim().split(' ').length <= 1) {
                      return 'preencha seu nome completo';
                    }
                    return null;
                  },
                  onSaved: (name) => users.name = name,
                ),
                const SizedBox(height: 16),
                ///========================================================
                TextFormField(
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email.isEmpty) {
                      return 'Campo obrigatorio';
                    } else if (!emailValid(email)) {
                      return 'E-mail invalido';
                    }
                    return null;
                  },
                  onSaved: (email) => users.email = email,
                ),
                const SizedBox(height: 16),
                ///========================================================
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (pass) {
                    if (pass.isEmpty) {
                      return 'Campo obrigatorio';
                    } else if (pass.length < 6) {
                      return 'Senha muito curta';
                    }
                    return null;
                  },
                  onSaved: (pass) => users.password = pass,
                ),
                const SizedBox(height: 16),
                ///========================================================
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Repita a Senha'),
                  obscureText: true,
                  validator: (pass) {
                    if (pass.isEmpty) {
                      return 'Campo obrigatorio';
                    } else if (pass.length < 6) return 'Senha muito curta';
                    return null;
                  },
                  onSaved: (pass) => users.confirmPassword = pass,
                ),
                const SizedBox(height: 16),
                ///========================================================
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                    textColor: Colors.white,
                    onPressed: () {
                      if(formKey.currentState.validate()){
                        formKey.currentState.save();

                        if(users.password != users.confirmPassword){
                          scaffoldKey.currentState.showSnackBar(
                              const SnackBar(
                                content: Text('Senhas não coincidem'),
                                backgroundColor: Colors.red,
                              )
                          );
                          return;
                        }
                        context.read<UserManager>().signUp(
                          users: users,
                          onSuccess: (){
                            Navigator.of(context).pop();

                          },
                          onFail: (e){

                            scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                    content: Text('Falha ao cadastrar: $e'),
                                  backgroundColor: Colors.red,
                                ));
                          }
                        );
                      }
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
