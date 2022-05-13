package com.april.support

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
import io.flutter.plugin.common.PluginRegistry
import kotlin.system.exitProcess

/** AprilPlugin */
class AprilPlugin : FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener,
    MethodCallHandler {
    private var binding: ActivityPluginBinding? = null
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "April.FlutterDevelopSupport.MethodChannelName",
        ).also {
            it.setMethodCallHandler(this)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            //回到桌面
            "backToDesktop" -> {
                binding?.activity?.moveTaskToBack(false)
                result.success(binding != null)
            }
            //关闭应用
            "closeApplication" -> {
                Process.killProcess(Process.myPid())
                exitProcess(0)
            }
            //重启应用
            "restartApplication" -> {
                result.success(binding != null)
                binding?.activity?.let { activity ->
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
                if (binding == null) {
                    result.success(mapOf<Any, Any>())
                } else {
                    try {
                        val packageInfo: PackageInfo =
                            binding!!.activity.packageManager.getPackageInfo(
                                (call.arguments as String?) ?: "",
                                0
                            )
                        result.success(
                            mapOf(
                                "packageName" to packageInfo.packageName,
                                "versionName" to packageInfo.versionName,
                                "versionCode" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                                    packageInfo.longVersionCode
                                } else {
                                    packageInfo.versionCode
                                },
                                "firstInstallTime" to packageInfo.firstInstallTime,
                                "lastUpdateTime" to packageInfo.lastUpdateTime,
                            )
                        )
                    } catch (e: Exception) {
                        result.success(mapOf<Any, Any>())
                    }
                }
            }
            //根据隐式跳转链，查找能接收跳转的 包和类信息
            "supportedActivities" -> {
                if (binding == null) {
                    result.success(listOf<Map<Any, Any>>())
                } else {
                    val resolveInfoList: List<ResolveInfo> =
                        binding!!.activity.packageManager.queryIntentActivities(
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
            //执行隐式跳转链
            "launchUrl" -> {
                if (binding == null) {
                    result.success(false)
                } else {
                    try {
                        binding!!.activity.startActivity(
                            Intent(Intent.ACTION_VIEW).also {
                                it.data = Uri.parse(call.argument<String>("url") ?: "")
                                val packageName: String =
                                    call.argument<String>("packageName") ?: return@also
                                val className: String? = call.argument<String>("className")
                                if (className.isNullOrEmpty()) {
                                    it.setPackage(packageName)
                                } else {
                                    it.component = ComponentName(
                                        packageName,
                                        className,
                                    )
                                }
                            }
                        )
                        result.success(true)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.success(false)
                    }
                }
            }
            //获取 Intent 的 data 字段
            "getIntentData" -> {
                val intent: Intent? = binding?.activity?.intent
                if (intent == null) {
                    result.success(null)
                } else {
                    if (
                        (intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
                        != Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                    ) {
                        result.success(intent.dataString)
                    } else {
                        result.success(null)
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.binding?.removeOnNewIntentListener(this)
        this.binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivity() {
        this.binding?.removeOnNewIntentListener(this)
        this.binding = null
    }

    override fun onNewIntent(intent: Intent): Boolean {
        channel?.invokeMethod("onNewIntentData", intent.dataString)
        return false
    }
}
