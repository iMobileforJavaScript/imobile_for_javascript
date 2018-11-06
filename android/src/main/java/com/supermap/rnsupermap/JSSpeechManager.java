package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.mapping.speech.IntelligentSpeechListener;
import com.supermap.mapping.speech.SpeechManager;

public class JSSpeechManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSpeechManager";
    ReactContext mReactContext;
    SpeechManager m_SpeechManager;

    private static final String BEGIN_OF_SPEECH = "com.supermap.RN.JSSpeechManager.begin_of_speech";
    private static final String END_OF_SPEECH = "com.supermap.RN.JSSpeechManager.end_of_speech";
    private static final String ERROR = "com.supermap.RN.JSSpeechManager.error";
    private static final String RESULT = "com.supermap.RN.JSSpeechManager.result";
    private static final String VOLUME_CHANGED = "com.supermap.RN.JSSpeechManager.volume_changed";

    public JSSpeechManager(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SpeechManager getInstance() {
        m_SpeechManager = SpeechManager.getInstance(getCurrentActivity());
        return m_SpeechManager;
    }

    Runnable initSpeechManager = new Runnable(){
        @Override
        public void run(){
            SpeechManager.init(getCurrentActivity(),"110");
        }
    };

    /**
     * 初始化语音SDK组件(只能在主线程中调用)，只需在应用启动时调用一次就够了
     * @param promise
     */
    @ReactMethod
    public void init(Promise promise){
        try {
            getCurrentActivity().runOnUiThread(initSpeechManager);
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过此函数取消当前的会话
     * @param promise
     */
    @ReactMethod
    public void cancel(Promise promise){
        try {
            m_SpeechManager = getInstance();
            m_SpeechManager.cancel();
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在调用本函数进行销毁前，应先保证当前不在会话中，否则，本函数将尝试取消当前会话，并返回false，此时销毁失败
     * @param promise
     */
    @ReactMethod
    public void destroy(Promise promise){
        try {
            m_SpeechManager = getInstance();
            boolean result = m_SpeechManager.destroy();
            promise.resolve(result);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过此函数，获取当前SDK是否正在进行会话
     * @param promise
     */
    @ReactMethod
    public void isListening(Promise promise){
        try {
            m_SpeechManager = getInstance();
            boolean result = m_SpeechManager.isListening();
            promise.resolve(result);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置音频保存路径:(目前支持音频文件格式为wav格式) 通过此参数，可以在识别完成后在本地保存一个音频文件
     * 是否必须设置：否 默认值：null (不保存音频文件)
     * 值范围：有效的文件相对或绝对路径（含文件名
     * 例如：Environment.getExternalStorageDirectory() + "/msc/speech.wav"
     * @param path
     * @param promise
     */
    @ReactMethod
    public void setAudioPath(String path, Promise promise){
        try {
            String absolutePath = android.os.Environment.getExternalStorageDirectory().getAbsolutePath() + path;
            m_SpeechManager = getInstance();
            m_SpeechManager.setAudioPath(absolutePath);
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
     * 是否必须设置：否 默认值：听写5000，其他4000 值范围：[1000, 10000]
     * @param time
     * @param promise
     */
    @ReactMethod
    public void setVAD_BOS_Time(int time, Promise promise){
        try {
            m_SpeechManager = getInstance();
            m_SpeechManager.setVAD_BOS_Time(time);
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入，自动停止录音
     * 是否必须设置：否 默认值：听写1800，其他700 值范围：[0, 10000]
     * @param time
     * @param promise
     */
    @ReactMethod
    public void setVAD_EOS_Time(int time, Promise promise){
        try {
            m_SpeechManager = getInstance();
            m_SpeechManager.setVAD_EOS_Time(time);
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 调用此函数，开始语音听写
     * @param promise
     */
    @ReactMethod
    public void startListening(Promise promise){
        try{
            m_SpeechManager = getInstance();

            IntelligentSpeechListener listener = new IntelligentSpeechListener() {
                /**
                 * 开始说话 在录音模式下，调用开始录音函数后，会自动开启系统的录音机，并在录音机开启后，会回调此函数（这中间的过程应该在几毫秒内，可以忽略，除非系统响应很慢）
                 */
                @Override
                public void onBeginOfSpeech() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(BEGIN_OF_SPEECH, true);
                }

                /**
                 * 在SDK检测到音频的静音端点时，回调此函数（应用层主动调用stopListening()则不会回调此函数， 在识别出错时，可能不会回调此函数）
                 */
                @Override
                public void onEndOfSpeech() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(END_OF_SPEECH, true);
                }

                /**
                 * 当开始识别，到停止录音或SDK返回最后一个结果自动结束识别为止，SDK检测到音频数据（正在录音）的音量变化时，会多次通过此函数回调，告知应用层当前的音量值
                 * @param i
                 */
                @Override
                public void onVolumeChanged(int i) {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(VOLUME_CHANGED, i);
                }

                /**
                 * 当此函数回调时，说明当次会话出现错误，会话自动结束，录音也会停止
                 * @param error
                 */
                @Override
                public void onError(String error) {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(ERROR, error);
                }

                /**
                 * 返回的结果可能为null，请增加判断处理
                 * @param info
                 * @param isLast
                 */
                @Override
                public void onResult(String info, boolean isLast) {
                    WritableMap map = Arguments.createMap();
                    map.putString("info", info);
                    map.putBoolean("isLast", isLast);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(RESULT, map);
                }
            };
            m_SpeechManager.startListening(listener);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 调用本函数告知SDK，当前会话音频已全部录入
     * @param promise
     */
    @ReactMethod
    public void stopListening(Promise promise){
        try {
            m_SpeechManager = getInstance();
            m_SpeechManager.stopListening();
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }
}

