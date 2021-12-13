# libsodium_sym_encr_pinenacl

Libsodium SecretBox encryption

XSalsa20Poly1305 SecretBox encryption

For more information see here: http://fluttercrypto.bplaced.net/libsodium-symmetric-encryption-playground-pinenacl/

Enable Web support

/Users/michaelfehr/flutter/bin/flutter create .

```plaintext
https://pub.dev/packages/pinenacl
https://github.com/ilap/pinenacl-dart
pinenacl: ^0.3.3

https://pub.dev/packages/url_launcher
url_launcher: ^6.0.12

https://pub.dev/packages/path_provider
path_provider: ^2.0.5

in AndroidManifest.xml ergänzen:

    <queries>
        <!-- If your app opens https URLs -->
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
    </queries>
```    

Passwort:
```plaintext
Passwort12345
```

Iterationen:
```plaintext
15000
```

Klartext:
```plaintext
Mein wichtiges Geheimnis
```

Sample SecretBox:
```plaintext
{
  "algorithm": "XSalsa20Poly1305 PBKDF2",
  "iterations": "15000",
  "salt": "fFyoi9/sfvyBVVVbPM477AgLsPQv7JBsU9hasyP62tE=",
  "iv": "in ciphertext integriert",
  "ciphertext": "Zk4H3FWYqnNOBLzH9HUrOG4YEUdNAJTvPRmIFHjxEFG2KAEC3DdZcaRGsZg3Bz7om2Fbcpfcl/AYLn9kCTcGeA==",
  "gcmTag": "nicht benutzt"
}
```

Sample :
```plaintext

```

development environment:
```plaintext
Android Studio Arctic Fox Version 2020.3.1 Patch 3
Build #AI-203.7717.56.2031.7784292
Runtime version: 11.0.10+0-b96-7249189 aarch64
VM: OpenJDK 64-Bit Server VM
Flutter 2.5.3 channel stable Framework Revision 18116933e7
Dart 2.14.4
```

tested on:
```plaintext
Android Simulator: 
  Android 11 (SDK 30) Emulator,
  Android 12 SV2 (SDK 31) Emulator, 
  Android 6 (SDK 23) Emulator,


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
