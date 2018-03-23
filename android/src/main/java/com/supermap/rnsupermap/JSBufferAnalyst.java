package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.supermap.analyst.BufferAnalyst;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/22.
 */

public class JSBufferAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSBufferAnalyst";
    protected static Map<String, BufferAnalyst> m_BufferAnalystList = new HashMap<String, BufferAnalyst>();
    BufferAnalyst m_BufferAnalyst;

    public JSBufferAnalyst(ReactApplicationContext context) {
        super(context);
    }

    public static BufferAnalyst getObjFromList(String id) {
        return m_BufferAnalystList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void createBuffer(String sourceDatasetId, String resultDatasetId,
                             String bufferAnalystParamId, Boolean isUnion, Boolean isAttributeRetained, Promise promise){
        try{
            DatasetVector source = JSDatasetVector.getObjFromList(sourceDatasetId);
            DatasetVector result = JSDatasetVector.getObjFromList(resultDatasetId);
            BufferAnalystParameter bufferAnalystPara = JSBufferAnalystParameter.getObjFromList(bufferAnalystParamId);

            Boolean isCreate = BufferAnalyst.createBuffer(source,result,bufferAnalystPara,isUnion,isAttributeRetained);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createLineOneSideMultiBuffer(String sourceDatasetId, String resultDatasetId,
                                             ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isLeft, Boolean isUnion, Boolean isAttributeRetained, Boolean isRing, Promise promise){
        try{
            DatasetVector source = JSDatasetVector.getObjFromList(sourceDatasetId);
            DatasetVector result = JSDatasetVector.getObjFromList(resultDatasetId);
            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,bufferRadiusUnit);

            ArrayList listArr = arrBufferRadius.toArrayList();
            Object[] objArr = listArr.toArray();
            double[] doubleArr = new double[objArr.length];
            for (int i = 0; i<=objArr.length-1;i++){
                doubleArr[i] = (double)objArr[i];
            }
            Boolean isCreate = BufferAnalyst.createLineOneSideMultiBuffer(source,result,doubleArr,unit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createMultiBuffer(String sourceDatasetId, String resultDatasetId,
                                  ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isUnion, Boolean isAttributeRetained,Boolean isRing, Promise promise){
        try{
            DatasetVector source = JSDatasetVector.getObjFromList(sourceDatasetId);
            DatasetVector result = JSDatasetVector.getObjFromList(resultDatasetId);
            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,bufferRadiusUnit);

            ArrayList listArr = arrBufferRadius.toArrayList();
            Object[] objArr = listArr.toArray();
            double[] doubleArr = new double[objArr.length];
            for (int i = 0; i<=objArr.length-1;i++){
                doubleArr[i] = (double)objArr[i];
            }
            Boolean isCreate = BufferAnalyst.createMultiBuffer(source,result,doubleArr,unit,semicircleSegment,isUnion,isAttributeRetained,isRing);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
