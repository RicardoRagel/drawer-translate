# Translator Minimal App

Minimalistic Translator Application to translate text using the Google Translate API. It has been develope under the idea of it doesn't interfer with the rest of our work.

It is a simple Qt Application with a front-end developed using QML.

## Dependencies

* Linux or Windows

* [Qt + QtCreator](https://www.qt.io/download). Created using Qt 5.14.2

* [OpenSSL](https://slproweb.com/products/Win32OpenSSL.html) if you will compile it **on Windows**.

## Compilation

Just open the project file [translator_app.pro](translator_app.pro) using **QtCreator**, configure the project using the default settings and compile.

## Known issues

1. QNetworkManager library usage throws the following errors on Windows:

    ```bash
    qt.network.ssl: QSslSocket::connectToHostEncrypted: TLS initialization failed
    ```
    Fix: Install OpenSSL. [Reference](https://stackoverflow.com/questions/53805704/tls-initialization-failed-on-get-request)
