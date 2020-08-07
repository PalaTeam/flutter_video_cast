package it.aesys.flutter_video_cast

import android.content.Context
import android.view.ContextThemeWrapper
import androidx.mediarouter.app.MediaRouteButton
import com.google.android.gms.cast.MediaInfo
import com.google.android.gms.cast.MediaLoadOptions
import com.google.android.gms.cast.MediaSeekOptions
import com.google.android.gms.cast.framework.CastButtonFactory
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.Session
import com.google.android.gms.cast.framework.SessionManagerListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class ChromeCastController(
        messenger: BinaryMessenger,
        viewId: Int,
        context: Context?
) : PlatformView, MethodChannel.MethodCallHandler, SessionManagerListener<Session> {
    private val channel = MethodChannel(messenger, "plugins.flutter.io/multiPlayer/chromeCast_$viewId")
    private val chromeCastButton = MediaRouteButton(ContextThemeWrapper(context, R.style.Theme_AppCompat_NoActionBar))
    private val sessionManager = CastContext.getSharedInstance()?.sessionManager

    init {
        CastButtonFactory.setUpMediaRouteButton(context, chromeCastButton)
        channel.setMethodCallHandler(this)
        sessionManager?.addSessionManagerListener(this)
    }

    private fun loadMedia(args: Any?) {
        if (args is Map<*, *>) {
            val url = args["url"] as? String
            val media = MediaInfo.Builder(url).build()
            val options = MediaLoadOptions.Builder().build()
            val request = sessionManager?.currentCastSession?.remoteMediaClient?.load(media, options)
            request?.addStatusListener { status ->
                if (status.isSuccess) {
                    channel.invokeMethod("chromeCast#requestDidComplete", null)
                }
            }
        }
    }

    private fun play() {
        sessionManager?.currentCastSession?.remoteMediaClient?.play()
    }

    private fun pause() {
        sessionManager?.currentCastSession?.remoteMediaClient?.pause()
    }

    private fun seek(args: Any?) {
        if (args is Map<*, *>) {
            val relative = (args["relative"] as? Boolean) ?: false
            var interval = args["interval"] as? Double
            interval = interval?.times(1000)
            if (relative) {
                interval = interval?.plus(sessionManager?.currentCastSession?.remoteMediaClient?.mediaStatus?.streamPosition ?: 0)
            }
            val seekOptions = MediaSeekOptions.Builder()
                    .setPosition(interval?.toLong() ?: 0)
                    .build()
            sessionManager?.currentCastSession?.remoteMediaClient?.seek(seekOptions)
        }
    }

    private fun isPlaying() = sessionManager?.currentCastSession?.remoteMediaClient?.isPlaying ?: false

    override fun getView() = chromeCastButton

    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "chromeCast#wait" -> result.success(null)
            "chromeCast#loadMedia" -> {
                loadMedia(call.arguments)
                result.success(null)
            }
            "chromeCast#play" -> {
                play()
                result.success(null)
            }
            "chromeCast#pause" -> {
                pause()
                result.success(null)
            }
            "chromeCast#seek" -> {
                seek(call.arguments)
                result.success(null)
            }
            "chromeCast#isPlaying" -> result.success(isPlaying())
        }
    }

    override fun onSessionStarted(p0: Session?, p1: String?) {
        channel.invokeMethod("chromeCast#didStartSession", null)
    }

    override fun onSessionEnded(p0: Session?, p1: Int) {
        channel.invokeMethod("chromeCast#didEndSession", null)
    }

    override fun onSessionResuming(p0: Session?, p1: String?) {

    }

    override fun onSessionResumed(p0: Session?, p1: Boolean) {

    }

    override fun onSessionResumeFailed(p0: Session?, p1: Int) {

    }

    override fun onSessionSuspended(p0: Session?, p1: Int) {

    }

    override fun onSessionStarting(p0: Session?) {

    }

    override fun onSessionEnding(p0: Session?) {

    }

    override fun onSessionStartFailed(p0: Session?, p1: Int) {

    }
}
