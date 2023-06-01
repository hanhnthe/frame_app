package com.example.utils;

import io.flutter.embedding.android.FlutterFragmentActivity;
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyPermanentlyInvalidatedException;
import android.security.keystore.KeyProperties;
import android.util.Log;

//import androidx.biometric.BiometricPrompt;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;


import android.widget.Toast;

import java.io.IOException;
import java.nio.charset.Charset;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.Arrays;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.Executor;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * UtilsPlugin
 */
public class UtilsPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private static final String KEY_NAME = "Bkav";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.bkav.utils/bkav_channel");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if(call.method.equals("getStatusBiometricAndroid")){
            Cipher cipher = null;
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    cipher = getCipher();
                }
            } catch (NoSuchPaddingException | NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
            SecretKey secretKey = null;
            try {
                secretKey = getSecretKey();
            } catch (UnrecoverableKeyException | NoSuchAlgorithmException | KeyStoreException e) {
                e.printStackTrace();
            }
            if (secretKey == null){
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    generateSecretKey(new KeyGenParameterSpec.Builder(
                            KEY_NAME,
                            KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                            .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
                            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
                            .setUserAuthenticationRequired(true)
                            // Invalidate the keys if the user has registered a new biometric
                            // credential, such as a new fingerprint. Can call this method only
                            // on Android 7.0 (API level 24) or higher. The variable
                            .setInvalidatedByBiometricEnrollment(true)
                            .build());
                }
            }
            try {
                assert cipher != null;
                cipher.init(Cipher.ENCRYPT_MODE, secretKey);
                result.success(false);
            } catch (KeyPermanentlyInvalidatedException e) {
                result.success(true);
            } catch (InvalidKeyException e) {
                result.success(true);
                e.printStackTrace();
            }

        }
        else if(call.method.equals("resetBiometricAndroid")){
            generateSecretKey(new KeyGenParameterSpec.Builder(
                    KEY_NAME,
                    KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
                    .setUserAuthenticationRequired(true)
                    // Invalidate the keys if the user has registered a new biometric
                    // credential, such as a new fingerprint. Can call this method only
                    // on Android 7.0 (API level 24) or higher. The variable
                    .setInvalidatedByBiometricEnrollment(true)
                    .build());
        }
    }
    private void generateSecretKey(KeyGenParameterSpec keyGenParameterSpec) {
        KeyGenerator keyGenerator = null;
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                keyGenerator = KeyGenerator.getInstance(
                        KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
            }
        } catch (NoSuchAlgorithmException | NoSuchProviderException e) {
            e.printStackTrace();
        }
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                assert keyGenerator != null;
                keyGenerator.init(keyGenParameterSpec);
            }
        } catch (InvalidAlgorithmParameterException e) {
            e.printStackTrace();
        }
        assert keyGenerator != null;
        keyGenerator.generateKey();
    }

    private SecretKey getSecretKey() throws UnrecoverableKeyException, KeyStoreException, NoSuchAlgorithmException {
        KeyStore keyStore = null;
        try {
            keyStore = KeyStore.getInstance("AndroidKeyStore");
        } catch (KeyStoreException e) {
            e.printStackTrace();
        }

        // Before the keystore can be accessed, it must be loaded.
        try {
            assert keyStore != null;
            keyStore.load(null);
        } catch (CertificateException | NoSuchAlgorithmException | IOException e) {
            e.printStackTrace();
        }
        return ((SecretKey) keyStore.getKey(KEY_NAME, null));
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private Cipher getCipher() throws NoSuchPaddingException, NoSuchAlgorithmException {
        return Cipher.getInstance(KeyProperties.KEY_ALGORITHM_AES + "/"
                + KeyProperties.BLOCK_MODE_CBC + "/"
                + KeyProperties.ENCRYPTION_PADDING_PKCS7);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
