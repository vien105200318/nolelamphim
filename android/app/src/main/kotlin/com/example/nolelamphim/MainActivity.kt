package com.example.nolelamphim

import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val PIP_CHANNEL = "com.example.nolelamphim/pip"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PIP_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAvailable" -> {
                    result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
                }

                "enterPiP" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val args = call.arguments as? Map<String, Any>
                        val width = (args?.get("preferredWidth") as? Int) ?: 320
                        val height = (args?.get("preferredHeight") as? Int) ?: 180
                        val aspectRatio = Rational(width, height)
                        val params = android.app.PictureInPictureParams.Builder()
                            .setAspectRatio(aspectRatio)
                            .build()
                        enterPictureInPictureMode(params)
                        result.success(true)
                    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        @Suppress("DEPRECATION")
                        enterPictureInPictureMode()
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }

                "exitPiP" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && isInPictureInPictureMode) {
                        @Suppress("DEPRECATION")
                        enterPictureInPictureMode()
                    }
                    result.success(null)
                }

                "isInPiP" -> {
                    result.success(
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            isInPictureInPictureMode
                        } else {
                            false
                        }
                    )
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val aspectRatio = Rational(320, 180)
            val params = android.app.PictureInPictureParams.Builder()
                .setAspectRatio(aspectRatio)
                .build()
            enterPictureInPictureMode(params)
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            @Suppress("DEPRECATION")
            enterPictureInPictureMode()
        }
    }
}
