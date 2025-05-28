package com.example.rociny

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.facebook.FacebookSdk
import com.facebook.login.LoginManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginResult
import com.facebook.CallbackManager
import com.facebook.appevents.AppEventsLogger

class MainActivity : FlutterFragmentActivity() {

    companion object {
        lateinit var callbackManager: CallbackManager
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Méthode Flutter pour Facebook Login
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.rociny/facebook")
            .setMethodCallHandler { call, result ->
                if (call.method == "loginWithFacebook") {
                    LoginManager.getInstance().logOut()
                    LoginManager.getInstance().logInWithReadPermissions(
                        this,
                        listOf(
                            "email",
                            "public_profile",
                            "pages_show_list",
                            "pages_read_engagement",
                            "instagram_basic",
                            "instagram_manage_insights",
                            "business_management"
                        )
                    )

                    LoginManager.getInstance().registerCallback(callbackManager,
                        object : FacebookCallback<LoginResult> {
                            override fun onSuccess(loginResult: LoginResult) {
                                val token = loginResult.accessToken.token
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

        FacebookSdk.sdkInitialize(applicationContext)
        AppEventsLogger.activateApp(application)
        callbackManager = CallbackManager.Factory.create()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        callbackManager.onActivityResult(requestCode, resultCode, data)
    }
}
