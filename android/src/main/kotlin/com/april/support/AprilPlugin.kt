package com.april.support

import android.app.Activity
import android.content.ComponentName
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
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

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
                flutterPluginBinding.binaryMessenger,
                "April.FlutterDevelopSupport.MethodChannelName",
        )
        channel.setMethodCallHandler(this)
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
            //根据包名查询对应包相关信息
            "installedAppInfo" -> {
                if (activity == null) {
                    result.success(mapOf<Any, Any>())
                } else {
                    try {
                        val packageInfo: PackageInfo = activity!!.packageManager.getPackageInfo(
                                (call.arguments as String?) ?: "",
                                0
                        )
                        result.success(mapOf(
                                "packageName" to packageInfo.packageName,
                                "versionName" to packageInfo.versionName,
                                "versionCode" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                                    packageInfo.longVersionCode
                                } else {
                                    packageInfo.versionCode
                                },
                                "firstInstallTime" to packageInfo.firstInstallTime,
                                "lastUpdateTime" to packageInfo.lastUpdateTime,
                        ))
                    } catch (e: Exception) {
                        result.success(mapOf<Any, Any>())
                    }
                }
            }
            "supportedActivities" -> {
                if (activity == null) {
                    result.success(listOf<Map<Any, Any>>())
                } else {
                    val resolveInfoList: List<ResolveInfo> = activity!!.packageManager.queryIntentActivities(
                            Intent(Intent.ACTION_VIEW).also {
                                it.data = Uri.parse((call.arguments as String?) ?: "")
                            },
                            PackageManager.MATCH_DEFAULT_ONLY,
                    )
                    result.success(resolveInfoList.map {
                        val activityInfo: ActivityInfo = it.activityInfo ?: return@map null
                        return@map mapOf(
                                "packageName" to activityInfo.packageName,
                                "className" to activityInfo.name,
                        )
                    })
                }
            }
            "launchUrl" -> {
                activity?.startActivity(
                        Intent(Intent.ACTION_VIEW).also {
                            it.data = Uri.parse(call.argument<String>("url") ?: "")
                            val packageName: String? = call.argument<String>("packageName")
                            val className: String? = call.argument<String>("className")
                            if (packageName.isNullOrEmpty() || className.isNullOrEmpty()) {
                                return@also
                            }
                            it.component = ComponentName(
                                    packageName,
                                    className,
                            )
                        }
                )
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
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