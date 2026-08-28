package com.heraklysia.read_it_later

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "readex/share_intents"
    private var methodChannel: MethodChannel? = null
    private var initialSharedUrl: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initialSharedUrl = extractSharedUrl(intent)
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                if (call.method == "getInitialSharedUrl") {
                    result.success(initialSharedUrl)
                    initialSharedUrl = null
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val sharedUrl = extractSharedUrl(intent) ?: return
        methodChannel?.invokeMethod("sharedUrl", sharedUrl)
    }

    private fun extractSharedUrl(intent: Intent?): String? {
        if (intent == null) {
            return null
        }

        val candidates = buildList {
            intent.dataString?.let(::add)
            intent.getStringExtra(Intent.EXTRA_TEXT)?.let(::add)
            intent.getStringExtra(Intent.EXTRA_SUBJECT)?.let(::add)
        }

        return candidates.firstNotNullOfOrNull(::firstHttpUrl)
    }

    private fun firstHttpUrl(text: String): String? {
        return Regex("""https?://[^\s<>"']+""")
            .find(text)
            ?.value
            ?.trimEnd('.', ',', ';', ')', ']', '}')
    }
}
