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

Private key Sender:
```plaintext
38PnbIaNFoY4UKYY8x63itHY1dlz4eicARA6i42HFB8=
```

PublicKey Sender:
```plaintext
Oiq+GOqfT1L2PBmkOvL+h9WP1CSSUx5lbvVjOwaKIyQ=
```

Private key Empfänger:
```plaintext
8hivrN+NJ5HkrHtMvhUPI76GLu/RogeChYJ6pHJXu7I=
```

PublicKey Empfänger:
```plaintext
trk08wvA81TFM67uJx6rt6UPbipv7pG8o4Lh6cWHRGQ=
```

Klartext:
```plaintext
The quick brown fox jumps over the lazy dog
```

Sample SecretBox:
```plaintext
{
  "algorithm": "XSalsa20Poly1305 PBKDF2",
  "iterations": "15000",
  "salt": "dvV2ihvCqdE5hzgenZQsTBdei203Dhdg7zlDPKewdDo=",
  "iv": "nicht benutzt",
  "ciphertext": "jtDN1LdNDwE+YG1ykO+qQq86jlNJCkUr0istfKAaXOx4TT0gNdFdNtEFN+wm0fHoo7utqAZiwR85iQw8XubLOnFEJFVxHkYKxHzKeHacqKzeJ4Y=",
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