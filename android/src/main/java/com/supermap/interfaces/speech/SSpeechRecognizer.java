package com.supermap.interfaces.speech;

import android.os.Bundle;
import android.os.Environment;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import com.iflytek.cloud.RecognizerListener;
import com.iflytek.cloud.RecognizerResult;
import com.iflytek.cloud.SpeechConstant;
import com.iflytek.cloud.SpeechError;
import com.iflytek.cloud.SpeechRecognizer;
import com.iflytek.cloud.SpeechUtility;
import com.supermap.containts.EventConst;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

public class SSpeechRecognizer extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SSpeechRecognizer";
    public static final String TAG = REACT_CLASS;
    private static ReactApplicationContext context;

    private static SpeechRecognizer mSpeechRecognizer;
    private static RecognizerListener mRecognizerListener;

    @Override
    public String getName() {
        return REACT_CLASS;
    }


    public SSpeechRecognizer(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @ReactMethod
    public void init(String AppId, Promise promise) {
        try {
            if (mSpeechRecognizer != null) {
                return;
            }

            SpeechUtility.createUtility(context, SpeechConstant.APPID + "=" + AppId);

            mSpeechRecognizer = SpeechRecognizer.createRecognizer(context, null);
            mRecognizerListener = new RecognizerListener() {
                @Override
                public void onVolumeChanged(int volume, byte[] bytes) {
                    WritableMap params = Arguments.createMap();
                    params.putInt("volume", volume);
                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.RECOGNIZE_VOLUME_CHANGED, params);
                }

                @Override
                public void onBeginOfSpeech() {
                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.RECOGNIZE_BEGIN, true);
                }

                @Override
                public void onEndOfSpeech() {
                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.RECOGNIZE_END, true);
                }

                @Override
                public void onResult(RecognizerResult results, boolean isLast) {
                    String text = parseIatResult(results.getResultString());
                    WritableMap params = Arguments.createMap();
                    params.putString("info", text);
                    params.putBoolean("isLast", isLast);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.RECOGNIZE_RESULT, params);
                }

                @Override
                public void onError(SpeechError error) {
                    String errorString = error.getErrorDescription();
                    Log.d(TAG, "onError: " + error.getPlainDescription(true));

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.RECOGNIZE_ERROR, errorString);
                }

                @Override
                public void onEvent(int i, int i1, int i2, Bundle bundle) {
                    WritableMap params = Arguments.createMap();
                    params.putInt("1", i);
                    params.putInt("2", i1);
                    params.putInt("3", i2);
                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.RECOGNIZE_EVENT, params);
                }
            };
            setParameters();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void start(Promise promise) {
        try {
            if (mSpeechRecognizer.isListening()) {
                mSpeechRecognizer.cancel();
            }
            mSpeechRecognizer.startListening(mRecognizerListener);
            promise.resolve(true);
        } catch (Exception e) {
           promise.reject(e);
        }
    }

    @ReactMethod
    public void cancel(Promise promise) {
        try {
            if (mSpeechRecognizer.isListening()) {
                mSpeechRecognizer.cancel();
            }
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isListening(Promise promise) {
        try {
            promise.resolve(mSpeechRecognizer.isListening());
        } catch (Exception e) {
            promise.reject("Error: isListening()", e);
        }
    }

    @ReactMethod
    public void stop(Promise promise) {
        try {
            if (mSpeechRecognizer.isListening()) {
                mSpeechRecognizer.stopListening();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setParameter(String parameter, String value, Promise promise) {
        try {
            if (parameter.equals(SpeechConstant.ASR_AUDIO_PATH)) {
                value = Environment.getExternalStorageDirectory() + value;
            }
            boolean result = mSpeechRecognizer.setParameter(parameter, value);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getParameter(String param, Promise promise) {
        String value = mSpeechRecognizer.getParameter(param);
        try {
            promise.resolve(value);
        } catch (Exception e) {
            promise.reject("Error: getParameter()", e);
        }
    }

    private static void setParameters() {
        // 清空参数
//        mSpeechRecognizer.setParameter(SpeechConstantModule.PARAMS, null);

        // 设置听写引擎
        mSpeechRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, SpeechConstant.TYPE_CLOUD);

        // 设置返回结果格式
        mSpeechRecognizer.setParameter(SpeechConstant.RESULT_TYPE, "json");

        // 设置语言
        mSpeechRecognizer.setParameter(SpeechConstant.LANGUAGE, "zh_cn");
        // 设置语言区域
        mSpeechRecognizer.setParameter(SpeechConstant.ACCENT, "mandarin");

        // 设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
        mSpeechRecognizer.setParameter(SpeechConstant.VAD_BOS, "5000");

        // 设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入， 自动停止录音
        mSpeechRecognizer.setParameter(SpeechConstant.VAD_EOS, "2000");

        // 设置标点符号,设置为"0"返回结果无标点,设置为"1"返回结果有标点
        mSpeechRecognizer.setParameter(SpeechConstant.ASR_PTT, "0");

        // 设置音频保存路径，保存音频格式支持pcm、wav，设置路径为sd卡请注意WRITE_EXTERNAL_STORAGE权限
        // 注：AUDIO_FORMAT参数语记需要更新版本才能生效
//        mSpeechRecognizer.setParameter(SpeechConstant.AUDIO_FORMAT, "wav");
//        mSpeechRecognizer.setParameter(SpeechConstant.ASR_AUDIO_PATH, Environment.getExternalStorageDirectory() + "/App/SpeechRecognizer");
    }

    private static String parseIatResult(String json) {
        StringBuilder ret = new StringBuilder();
        try {
            JSONTokener tokener = new JSONTokener(json);
            JSONObject joResult = new JSONObject(tokener);
            JSONArray words = joResult.getJSONArray("ws");
            for (int i = 0; i < words.length(); i++) {
                // 转写结果词，默认使用第一个结果
                JSONArray items = words.getJSONObject(i).getJSONArray("cw");
                JSONObject obj = items.getJSONObject(0);
                ret.append(obj.getString("w"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ret.toString();
    }
}
