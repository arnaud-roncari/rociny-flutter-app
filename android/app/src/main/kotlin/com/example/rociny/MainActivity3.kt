package com.example.rociny

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.facebook.FacebookSdk
import com.facebook.login.LoginManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginResult
import com.facebook.CallbackManager
import com.facebook.AccessToken
import com.facebook.appevents.AppEventsLogger
import android.os.Bundle
import android.content.Intent

class MainActivity : FlutterActivity() {
    companion object {
        lateinit var callbackManager: CallbackManager
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // La méthode que Flutter appellera pour effectuer la connexion Facebook
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.rociny/facebook")
            .setMethodCallHandler { call, result ->
                if (call.method == "loginWithFacebook") {
                    // Initialise la connexion Facebook
                    LoginManager.getInstance().logInWithReadPermissions(this, listOf("email","public_profile","pages_show_list","pages_read_engagement","instagram_basic","instagram_manage_insights","business_management"))

                    // Enregistre le callback
                    LoginManager.getInstance().registerCallback(callbackManager,
                        object : FacebookCallback<LoginResult> {
                            override fun onSuccess(loginResult: LoginResult) {
                                // Récupère le token d'accès
                                val token = loginResult.accessToken.token
                                // Envoie le token à Flutter
                                result.success(token)
                            }

                            override fun onCancel() {
                                result.error("CANCELLED", "Connexion annulée", null)
                            }

                            override fun onError(exception: FacebookException) {
                                result.error("ERROR", exception.message, null)
                            }
                        }
                    )
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialisation de Facebook SDK
        FacebookSdk.sdkInitialize(applicationContext)
        AppEventsLogger.activateApp(application)

        // Crée le callbackManager avant de l'utiliser
        callbackManager = CallbackManager.Factory.create()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        // Transmet les résultats de l'Activity pour traiter le Facebook Login
        callbackManager.onActivityResult(requestCode, resultCode, data)
    }
}
