package it.aesys.flutter_video_cast

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterVideoCastPlugin */
public class FlutterVideoCastPlugin: FlutterPlugin, ActivityAware {
  private lateinit var chromeCastFactory: ChromeCastFactory

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    chromeCastFactory = ChromeCastFactory(flutterPluginBinding.binaryMessenger)
    flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(
                    "ChromeCastButton",
                    chromeCastFactory
            )
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      registrar
              .platformViewRegistry()
              .registerViewFactory(
                      "ChromeCastButton",
                      ChromeCastFactory(registrar.messenger())
              )
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    chromeCastFactory.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onDetachedFromActivity() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }
}
