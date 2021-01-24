# keytool 生成证书

官方文档： https://docs.oracle.com/javase/8/docs/technotes/tools/windows/keytool.html

des:

```shell 
keytool -genseckey -alias "des_code" -keyalg DES -validity 1000 -keystore D:\github-myproject\encryption\src\main\resources\des_code.keystore -keysize 56 -storetype jceks
```

3des:

```shell
keytool -genseckey -alias "desede_code" -keyalg DESede -validity 1000 -keystore D:\github-myproject\encryption\src\main\resources\desede_code.keystore -keysize 168 -storetype jceks
```

aes:

```shell
keytool -genkeypair -alias "aes_code" -keyalg AES -validity 1000 -keystore D:\github-myproject\encryption\src\main\resources\aes_code.keystore -keysize 128 -storetype jceks
```

rsa:

```shell
keytool -genkeypair -alias "rsa_code"  -keypass 123456 -keyalg RSA -validity 1000 -keystore D:\github-myproject\encryption\src\main\resources\rsa_code.keystore -storepass 123456 -keysize 2048 -storetype jks
```



-keypass:

- Key password



-storepass:

- Keystore password







-keyalg：

* -genseckey  适用对称加密。只有一个密钥。
* -genkeypair  适用非对称加密 。包括私钥和公钥。



-keysize：

- 2048 (when using -genkeypair and -keyalg is "RSA")
- 1024 (when using -genkeypair and -keyalg is "DSA")
- 256 (when using -genkeypair and -keyalg is "EC")



- 56 (when using -genseckey and -keyalg is "DES")
- 168 (when using -genseckey and -keyalg is "DESede")
- 128 (when using -genseckey and -keyalg is "AES")



keyStore type：

- jks 

  - 默认类型，只支持非对称加密  RSA EC

  - only supports asymmetric (public/private) keys

- jceks

  - 支持对称加密   DES 3DES AES











