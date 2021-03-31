import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/screens/edit_product/components/images_form.dart';
import 'package:lojavirtual/screens/edit_product/components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final bool editing;

  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ImagesForm(product),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: product.name,
                    decoration: const InputDecoration(
                      hintText: 'Titulo',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (name) {
                      if (name.length < 6) {
                        return 'Titulo muito curto';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 4),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Descrição',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (desc) {
                      if (desc.length < 10) {
                        return 'Descrição muito curta';
                      }
                      return null;
                    },
                  ),
                  SizesForm(product),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          product.save();
                        }
                      },
                      color: primaryColor,
                      disabledColor: primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: const Text(
                        'Salvar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
