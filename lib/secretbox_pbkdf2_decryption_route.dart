import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinenacl/key_derivation.dart';
import 'package:pinenacl/x25519.dart';

class SecretBoxPbkdf2DecryptionRoute extends StatefulWidget {
  const SecretBoxPbkdf2DecryptionRoute({Key? key}) : super(key: key);

  final String title = 'SecretBox Entschlüsselung';

  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<SecretBoxPbkdf2DecryptionRoute> {
  @override
  void initState() {
    super.initState();
    descriptionController.text = txtDescription;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ciphertextController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription = 'SecretBox XSalsa20Poly1305 Entschlüsselung, der Schlüssel'
      ' wird mit PBKDF2 (wählbare Iterationen) von einem Passwort abgeleitet.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // ciphertext
                TextFormField(
                  controller: ciphertextController,
                  maxLines: 15,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Ciphertext',
                    hintText:
                        'kopieren Sie den verschlüsselten Text in dieses Feld',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          ciphertextController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          ciphertextController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                // password
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  enabled: true,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Passwort',
                    hintText: 'das Passwort zur Entschlüsselung eingeben',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Daten eingeben';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          passwordController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          passwordController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: Text('Formulardaten löschen'),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          if (_formKey.currentState!.validate()) {
                            String jsonEncryption = ciphertextController.text;
                            String password = passwordController.text;
                            String algorithm = '';
                            String iterationsString = '';
                            String salt = '';
                            String iv = ''; // not in use with XSalsa20Poly1305 as included in ciphertext
                            String ciphertext = '';
                            String gcmTag = ''; // not in use with CBC mode
                            try {
                              final parsedJson = json.decode(jsonEncryption);

                              algorithm = parsedJson['algorithm'];
                              if (parsedJson['iterations'] != null) {
                                iterationsString = parsedJson?['iterations'];
                              }
                              salt = parsedJson['salt'];
                              iv = parsedJson['iv'];
                              ciphertext = parsedJson['ciphertext'];
                              gcmTag = parsedJson['gcmTag'];
                            } on FormatException catch (e) {
                              outputController.text =
                                  'Fehler: Die Eingabe sieht nicht nach einem Json-Datensatz aus.';
                              return;
                            } on NoSuchMethodError catch (e) {
                              outputController.text =
                                  'Fehler: Die Eingabe ist ungültig.';
                              return;
                            }
                            if (algorithm != 'XSalsa20Poly1305 PBKDF2') {
                              outputController.text =
                                  'Fehler: es handelt sich nicht um einen Datensatz, der mit AES-256 CBC PBKDF2 verschlüsselt worden ist.';
                              return;
                            }
                            // rebuild string for xsalsa20poly1305
                            String ciphertextComplete =
                                salt + ':' + ciphertext;
                            String decryptionText =
                                xSalsa20Poly1305IterPbkdf2DecryptFromBase64(password,
                                    iterationsString, ciphertextComplete);
                            outputController.text = decryptionText;
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('entschlüsseln'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Klartext',
                    hintText: 'hier steht der entschlüsselte Text',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          outputController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                              ClipboardData(text: outputController.text);
                          await Clipboard.setData(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('in die Zwischenablage kopiert'),
                            ),
                          );
                        },
                        child: Text('in Zwischenablage kopieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String xSalsa20Poly1305IterPbkdf2DecryptFromBase64(
      String password, String iterations, String data) {
    try {
      var parts = data.split(':');
      var salt = base64Decoding(parts[0]);
      var ciphertext = base64Decoding(parts[1]);
      var passphrase = createUint8ListFromString(password);
      final PBKDF2_ITERATIONS = int.tryParse(iterations);
      final key = PBKDF2.hmac_sha256(
          passphrase, salt, PBKDF2_ITERATIONS!, SecretBox.keyLength);
      final box = SecretBox(key);
      final decryptedtext = box.decrypt(EncryptedMessage.fromList(ciphertext));
      return new String.fromCharCodes(decryptedtext);
    } catch (error) {
      return "Fehler bei der Entschlüsselung";
    }
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  String base64Encoding(Uint8List input) {
    return base64.encode(input);
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }
}
