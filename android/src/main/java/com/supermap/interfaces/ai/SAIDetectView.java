package com.supermap.interfaces.ai;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.ai.AIRecognition;
import com.supermap.ai.AIdetectView;
import com.supermap.ai.AidetectViewInfo;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Vector;

public class SAIDetectView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SAIDetectView";

    private static Context mContext = null;
    private static CustomAIDetectView mAIDetectView = null;
    private static AidetectViewInfo aidetectViewInfo;

    private static Vector<String> strToUseAll = new Vector<>(); //模型文件中所有可用的模型
    private static Date startDate = null;//开始识别
    private static boolean mIsPOIMode = true; //投射模式

    static Vector<String> strToUse = new Vector<>(); //初始化默认设置的模型

    public SAIDetectView(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext.getApplicationContext();
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static void setInstall(CustomAIDetectView aiDetectView) {
        mAIDetectView = aiDetectView;
        prepareAidetectViewInfo();
        initAI();
    }

    @ReactMethod
    public void initAIDetect(Promise promise){
        try{
            Log.e(REACT_CLASS, "----------------SAIDetectView--initAIDetect--------RN--------");
            mAIDetectView.init();

            mAIDetectView.setBackgroundColor(Color.parseColor("#708090"));
            mAIDetectView.setDetectInfo(aidetectViewInfo);//设置数据

            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.TV));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.KEYBOARD));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CELLPHONE));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.PERSON));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.MOTORCYCLE));

            mAIDetectView.setDetectArrayToUse(strToUse);//设置初始模型

            mAIDetectView.setDetectedListener(mDetectListener);//设置Ai监听回调

            mAIDetectView.setDetectInterval(3000);//设置识别时间间隔

            mAIDetectView.setisPolymerize(false);//置是否聚合模式

            mAIDetectView.setPolymerizeThreshold(100, 100);//设置聚合模式网格宽高

//            mAIDetectView.startDetect();//开始识别
//            mAIDetectView.startCountTrackedObjs();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void startDetect(Promise promise) {
        try {
            Log.e(REACT_CLASS, "----------------SAIDetectView--startDetect--------RN--------");
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                mAIDetectView.startDetect();//开始识别
                mAIDetectView.startCountTrackedObjs();
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private static void initAI(){
        try{
            Log.e(REACT_CLASS, "----------------SAIDetectView--initAIDetect--------JAVA--------");
            mAIDetectView.init();

            mAIDetectView.setBackgroundColor(Color.parseColor("#708090"));
            prepareAidetectViewInfo();
            mAIDetectView.setDetectInfo(aidetectViewInfo);//设置数据

            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.TV));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.KEYBOARD));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CELLPHONE));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.PERSON));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.MOTORCYCLE));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.LAPTOP));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CAR));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.MOUSE));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CHAIR));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.POTTEDPLANT));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CUP));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.PERSON));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.BOTTLE));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.BUS));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.BOOK));
            strToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.TRUCK));

            mAIDetectView.setDetectArrayToUse(strToUse);//设置初始模型

            mAIDetectView.setDetectedListener(mDetectListener);//设置Ai监听回调

            mAIDetectView.setDetectInterval(3000);//设置识别时间间隔

            mAIDetectView.setisPolymerize(false);//置是否聚合模式

            mAIDetectView.setPolymerizeThreshold(100, 100);//设置聚合模式网格宽高

//            mAIDetectView.startDetect();//开始识别
//            mAIDetectView.startCountTrackedObjs();

        }catch (Exception e){
            Log.e(REACT_CLASS, e.getMessage());
        }
    }


    private static void prepareAidetectViewInfo() {
        aidetectViewInfo = new AidetectViewInfo();
        aidetectViewInfo.assetManager = mContext.getAssets();
        aidetectViewInfo.modeFile = "detect.tflite";
        aidetectViewInfo.lableFile = "file:///android_asset/labelmap.txt";
        aidetectViewInfo.inputSize = 300;
        aidetectViewInfo.isQUANTIZED = true;
    }

    //毫秒
    private static int calLastedTime(Date startDate) {
        long a = new Date().getTime();
        long b = startDate.getTime();
        int c = (int) (a - b);
        return c;
    }

    private static AIdetectView.DetectListener mDetectListener = new AIdetectView.DetectListener() {
        @Override
        public void onDectetComplete(Map<String, Integer> result) {
            //流量统计
            Log.e("DetectListener", "-----------onDectetComplete-----------");
//            for (Map.Entry<String, Integer> entry : result.entrySet()) {
//                Log.e("onDectetComplete:", entry.getKey() + "  value:" + entry.getValue());
//            }
        }

        @Override
        public void onProcessDetectResult(List<AIRecognition> recognitions) {
            Log.e("DetectListener", "-----------onProcessDetectResult-----------");
            if (!mAIDetectView.isDetect()) {
                //停止识别状态
                return;
            }
            //识别结果(3秒间隔)
            boolean isCreated = false;//重新识别
            if (startDate == null) {
                isCreated = true;
            } else if (mIsPOIMode && calLastedTime(startDate) >= 3000) {
                isCreated = true;
            } else if (mIsPOIMode && calLastedTime(startDate) < 3000) {
                isCreated = false;
            }

            if (isCreated) {
                //重新识别
                Log.e("DetectListener", "onProcessDetectResult--重新识别");
                startDate = new Date();
            }
        }

        @Override
        public void onTrackedCountChanged(int i) {
            Log.e("DetectListener", "-----------onTrackedCountChanged-----------");
        }
    };

}
