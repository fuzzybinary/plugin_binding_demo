package com.example.plugin_binding_demo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "fuzzybinary.binding_demo")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "methodCallChannelTest" -> {
                        result.success("OK")
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
