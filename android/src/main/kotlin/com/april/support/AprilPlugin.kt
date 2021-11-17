package com.april.april

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Process
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.system.exitProcess

/** AprilPlugin */
class AprilPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    private var activity: Activity? = null
    private lateinit var channel: MethodChannel
    private lateinit var infoChannel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "april_method_channel_name")
        channel.setMethodCallHandler(this)
        infoChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "april_application_info_method_channel_name"
        )
        infoChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            //回到桌面
            "backToDesktop" -> {
                activity?.moveTaskToBack(false)
                result.success(activity != null)
            }
            //关闭应用
            "closeApplication" -> {
                Process.killProcess(Process.myPid())
                exitProcess(0)
            }
            //重启应用
            "restartApplication" -> {
                result.success(activity != null)
                activity?.let { activity ->
                    activity.baseContext.packageManager
                        .getLaunchIntentForPackage(activity.baseContext.packageName)
                        ?.let {
                            it.addFlags(
                                Intent.FLAG_ACTIVITY_NEW_TASK
                                        or Intent.FLAG_ACTIVITY_CLEAR_TOP
                                        or Intent.FLAG_ACTIVITY_CLEAR_TASK
                            )
                            activity.baseContext.startActivity(it)
                        }
                    activity.overridePendingTransition(0, 0)
                    Process.killProcess(Process.myPid())
                    exitProcess(0)
                }
            }
            //获取应用的一些信息
            "applicationInfo" -> {
                if (activity == null) {
                    result.error("001", "The host Activity is destroyed !", "")
                    return
                }
                val packageName: String = activity!!.applicationContext.packageName;
                val manager: PackageManager = activity!!.applicationContext.packageManager
                val info: PackageInfo = manager.getPackageInfo(packageName, 0)
                result.success(
                    mapOf(
                        "packageName" to packageName,
                        "appName" to info.applicationInfo.loadLabel(manager).toString(),
                        "appVersion" to info.versionName,
                        "appBuildNumber" to getBuildNumber(info),
                        "supportAbis" to Build.SUPPORTED_ABIS.map { return@map it },
                        "support64Abis" to Build.SUPPORTED_64_BIT_ABIS.map { return@map it },
                    )
                )
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        infoChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}

private fun getBuildNumber(info: PackageInfo): Long {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        info.longVersionCode
    } else {
        info.versionCode.toLong()
    }
}