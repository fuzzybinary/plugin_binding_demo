package com.example.plugin_binding_demo

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.MatOfPoint
import org.opencv.core.Point
import org.opencv.objdetect.Dictionary as CVDictionary
import org.opencv.objdetect.ArucoDetector
import org.opencv.objdetect.DetectorParameters
import org.opencv.objdetect.Objdetect
import org.opencv.utils.Converters
import kotlin.time.DurationUnit
import kotlin.time.ExperimentalTime
import kotlin.time.measureTime

class MainActivity : FlutterActivity() {
    var detector: ArucoDetector? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if(OpenCVLoader.initLocal()) {
            Log.i("MainActivity", "OpenCV loaded successfully")
            val arucoDictionary = Objdetect.getPredefinedDictionary(Objdetect.DICT_6X6_250)
            val arucoParameters = DetectorParameters()
            detector = ArucoDetector(arucoDictionary, arucoParameters)
        } else {
            Log.e("MainActivity", "OpenCV initialization failed!");
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "fuzzybinary.binding_demo")
            .setMethodCallHandler(::methodCallHandler)
    }

    fun methodCallHandler(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "methodCallChannelTest" -> {
                result.success("OK")
            }
            "detectQrCodes" -> {
                if (detector == null) {
                    result.error("QR_PROCESSOR_NOT_INITIALIZED", "QR Processor is not initialized", null)
                    return
                }

                detectQrCodes(call, result)
            }
            else -> result.notImplemented()
        }
    }

    @OptIn(ExperimentalStdlibApi::class, ExperimentalTime::class)
    private fun detectQrCodes(call: MethodCall, result: MethodChannel.Result) {
        val mat = decodeMat(call.argument("mat"))
        val decodeResults = mutableMapOf(
            "markerIds" to IntArray(0),
            "markerCorners" to mutableListOf<List<List<FloatArray>>>()
        )
        if (mat != null) {
            val markerCornersList = mutableListOf<Mat>()
            val ids = Mat()
            val timeTaken = measureTime {
                detector!!.detectMarkers(mat, markerCornersList, ids)
            }

            val idArray = IntArray(ids.total().toInt())
            ids.get(0, 0, idArray)
            decodeResults["markerIds"] = idArray.toList()

            val markerList = mutableListOf<List<List<Float>>>()
            for (markerIndex in 0 until markerCornersList.size) {
                val markerCorners = markerCornersList[markerIndex]
                val buff = FloatArray(markerCorners.total().toInt() * 2)
                markerCorners.get(0, 0, buff)
                val cornerList = mutableListOf<List<Float>>()
                for (cornerIndex in 0 until markerCorners.cols()) {
                    cornerList.add(
                        listOf<Float>(
                            buff[cornerIndex * 2],
                            buff[cornerIndex * 2 + 1]
                        )
                    )
                }
                markerList.add(cornerList)
            }
            decodeResults["markerCorners"] = markerList
            decodeResults["classifyTime"] = timeTaken.toDouble(DurationUnit.MILLISECONDS)
        }
        result.success(decodeResults)
    }

    private fun decodeMat(matMap: Any?): Mat? {
        return (matMap as? Map<*, *>)?.let {
            val width = it["width"] as? Int
            val height = it["height"] as? Int
            val data = it["data"] as? ByteArray
            val rgbaMat = Mat(height!!, width!!, CvType.CV_8UC4)
            rgbaMat.put(0, 0, data)
            return rgbaMat
        }
    }
}
