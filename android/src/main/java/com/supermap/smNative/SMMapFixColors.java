package com.supermap.smNative;


import com.supermap.data.Color;
import com.supermap.data.Enum;
import com.supermap.interfaces.mapping.SMap;

import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.LayerSettingVector;

import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.data.DatasetType;

import android.graphics.Bitmap;

import android.content.res.AssetManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import java.io.BufferedOutputStream;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.File;

import java.io.FileOutputStream;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import com.srplab.www.starcore.*;
import com.supermap.mapping.Theme;
import com.supermap.mapping.ThemeLabel;
import com.supermap.mapping.ThemeRange;
import com.supermap.mapping.ThemeType;
import com.supermap.mapping.ThemeUnique;

import org.json.JSONArray;
import org.json.JSONException;

public class SMMapFixColors {
    public enum SMMapFixColorsMode{
        //Hue
        FCM_LH(0),
        FCM_FH(1),
        FCM_BH(2),
        FCM_TH(3),
//    //Contrast
//    FCM_LC = 4,
//    FCM_FC = 5,
//    FCM_BC = 6,
//    FCM_TC = 7,
        //Saturation
        FCM_LS(4),
        FCM_FS(5),
        FCM_BS(6),
        FCM_TS(7),
        //Brightness
        FCM_LB(8),
        FCM_FB(9),
        FCM_BB(10),
        FCM_TB(11);

        SMMapFixColorsMode(int value){
            index = value;
        }
        private int index;
        int getIndex(){return index;}
        void setIndex(int value){index=value;}
    }

    public class ColorHSB{

        ColorHSB(float h,float s,float b){
            setHue(h);
            setSaturation(s);
            setBrightness(b);
        }

        ColorHSB(Color rgb){
            float r = ((float)rgb.getR() / 255.0f);
            float g = ((float)rgb.getG() / 255.0f);
            float b = ((float)rgb.getB() / 255.0f);

            float max = Math.max(r, Math.max(g, b));
            float min = Math.min(r, Math.min(g, b));

            float hue = 0.0f;
            if (max == r && g >= b)
            {
                if (max - min == 0) hue = 0.0f;
                else hue = 60.0f * (g - b) / (max - min);
            }
            else if (max == r && g < b)
            {
                hue = 60.0f * (g - b) / (max - min) + 360;
            }
            else if (max == g)
            {
                hue = 60.0f * (b - r) / (max - min) + 120;
            }
            else if (max == b)
            {
                hue = 60.0f * (r - g) / (max - min) + 240;
            }

            float sat = (max == 0) ? 0.0f : (1.0f - ((float)min / (float) max));
            float bri = max;
            _h =  hue;
            _s =  sat;
            _v =  bri;
        }

        public Color toColor(){
            double r = 0;
            double g = 0;
            double b = 0;
            double hue = _h;
            double sat = _s;
            double bri = _v;
            if (sat == 0)
            {
                r = g = b = bri;
            }
            else
            {
                // the color wheel consists of 6 sectors. Figure out which sector you're in.
                double sectorPos = hue / 60.0;
                int sectorNumber = (int) Math.floor(sectorPos);
                // get the fractional part of the sector
                double fractionalSector = sectorPos - sectorNumber;

                // calculate values for the three axes of the color.
                double p = bri * (1.0 - sat);
                double q = bri * (1.0 - (sat * fractionalSector));
                double t = bri * (1.0 - (sat * (1 - fractionalSector)));

                // assign the fractional colors to r, g, and b based on the sector the angle is in.
                switch (sectorNumber)
                {
                    case 0:
                        r = bri;
                        g = t;
                        b = p;
                        break;
                    case 1:
                        r = q;
                        g = bri;
                        b = p;
                        break;
                    case 2:
                        r = p;
                        g = bri;
                        b = t;
                        break;
                    case 3:
                        r = p;
                        g = q;
                        b = bri;
                        break;
                    case 4:
                        r = t;
                        g = p;
                        b = bri;
                        break;
                    case 5:
                        r = bri;
                        g = p;
                        b = q;
                        break;
                }
            }
            int red = (int)(r * 255);
            int green = (int)(g * 255);
            int blue = (int)(b * 255);
            return new Color(red,green,blue);
        }

        private float _h;
        public float getHue(){
            return _h;
        }
        public void setHue(float h){
            while (h<0){
                h += 360;
            }
            while (h>360){
                h -= 360;
            }
            _h = h;
        }

        private float _s;
        public float getSaturation(){
            return _s;
        }
        public void setSaturation(float value){
            while (value<0) {
                value+=1;
            }
            while (value>1) {
                value-=1;
            }
            _s = value;
        }

        private float _v;
        public float getBrightness(){
            return _v;
        }
        public void setBrightness(float value){
            while (value<0) {
                value+=1;
            }
            while (value>1) {
                value-=1;
            }
            _v = value;
        }

    }



    private static SMMapFixColors smMapFixColors;
    public static SMMapFixColors getInstance() {
        SMap.getInstance();
        if (smMapFixColors==null){
            smMapFixColors = new SMMapFixColors();
        }
        return smMapFixColors;
    }

    //private ArrayList<Integer> _param;
    private int[] _param = new int[12];
    private SMMapFixColors(){
        reset(false);
    }

    public void reset(boolean bMapRefresh){
        if (bMapRefresh){
            updateMapFixColors(SMMapFixColorsMode.FCM_LH,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_FH,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_BH,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_TH,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_LS,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_FS,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_BS,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_TS,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_LB,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_FB,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_BB,0);
            updateMapFixColors(SMMapFixColorsMode.FCM_TB,0);
        }else{
            for (int i=0;i<12;i++){
                _param[i] = 0;
            }
        }
    }

    public void updateMapFixColors(SMMapFixColorsMode mode,int value){
        if (value<-100 || value>100) {
            return ;
        }

        int index = mode.getIndex();
        Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
        ArrayList<Layer> layers = getLayers(map);
        for (int i = 0; i < layers.size(); i++) {
            Layer layer = layers.get(i);
            if (layer.isVisible() && layer.getDataset() != null) {
                DatasetType datasetType = layer.getDataset().getType();

                if (datasetType==DatasetType.POINT
                        || datasetType==DatasetType.LINE
                        || datasetType==DatasetType.REGION
                        || datasetType==DatasetType.POINT3D
                        || datasetType==DatasetType.LINE3D
                        || datasetType==DatasetType.REGION3D
                        //|| datasetType==DatasetType.LINEM
                        //|| datasetType==DatasetType.MODEL
                        || datasetType==DatasetType.TABULAR
                        || datasetType==DatasetType.NETWORK
                        || datasetType==DatasetType.NETWORK3D
                        || datasetType==DatasetType.CAD
                        || datasetType==DatasetType.TEXT
                ) {
                    if (layer.getTheme() == null) {
                        setDatasetVectorSimplyColors(layer,mode, _param[index],value);
                    } else {
                        setDatasetVectorThemeColors(layer,mode, _param[index],value);
                    }
                }
                //else if (DatasetTypeUtilities.isGridDataset(layer.getDataset().getType())) {
                //}
                //else if (DatasetTypeUtilities.isImageDataset(layer.getDataset().getType())) {
                //}
            }
        }

        _param[index] = value;
        map.refresh();

    }

    private void setDatasetVectorSimplyColors(Layer layer,SMMapFixColorsMode mode,int nSrc,int nDes){
        DatasetType datasetType = layer.getDataset().getType();
        if (datasetType==DatasetType.POINT
                || datasetType==DatasetType.POINT3D
                || datasetType==DatasetType.LINE
                || datasetType==DatasetType.NETWORK
                || datasetType==DatasetType.LINE3D
                || datasetType==DatasetType.NETWORK3D
        ){
            Color colorOrg = ((LayerSettingVector)layer.getAdditionalSetting()).getStyle().getLineColor();
            if (colorOrg!=null && (mode==SMMapFixColorsMode.FCM_LB||mode==SMMapFixColorsMode.FCM_LH||mode==SMMapFixColorsMode.FCM_LS)) {
                Color  matchedColor = colorTrance(colorOrg , mode , nSrc , nDes);
                if (matchedColor!=null) {
                    ((LayerSettingVector)layer.getAdditionalSetting()).getStyle().setLineColor(matchedColor);
                }
            }
        }else if(datasetType==DatasetType.REGION
                || datasetType==DatasetType.REGION3D){
            Color colorF = ((LayerSettingVector)layer.getAdditionalSetting()).getStyle().getFillForeColor();
            if (colorF!=null && (mode==SMMapFixColorsMode.FCM_FB||mode==SMMapFixColorsMode.FCM_FH||mode==SMMapFixColorsMode.FCM_FS)) {
                Color  matchedColor = colorTrance(colorF , mode , nSrc , nDes);
                if (matchedColor!=null) {
                    ((LayerSettingVector)layer.getAdditionalSetting()).getStyle().setFillForeColor(matchedColor);
                }
            }

            Color colorOrg = ((LayerSettingVector)layer.getAdditionalSetting()).getStyle().getLineColor();
            if (colorOrg!=null && (mode==SMMapFixColorsMode.FCM_BB||mode==SMMapFixColorsMode.FCM_BH||mode==SMMapFixColorsMode.FCM_BS)) {
                Color matchedColor = colorTrance(colorOrg , mode , nSrc , nDes);
                if (matchedColor!=null) {
                    ((LayerSettingVector)layer.getAdditionalSetting()).getStyle().setLineColor(matchedColor);
                }
            }
        }
    }

    private void setDatasetVectorThemeColors(Layer layer,SMMapFixColorsMode mode,int nSrc,int nDes){
        Theme theme = layer.getTheme();
        if (theme.getType() == ThemeType.UNIQUE) {
            ThemeUnique themeUnique = (ThemeUnique)theme;
            DatasetType datasetType = layer.getDataset().getType();
            int nType = 0;
            if (datasetType==DatasetType.POINT
                    || datasetType==DatasetType.POINT3D
                    || datasetType==DatasetType.LINE
                    || datasetType==DatasetType.NETWORK
                    || datasetType==DatasetType.LINE3D
                    || datasetType==DatasetType.NETWORK3D
            ){
                nType = 1;
            }
            else if(datasetType==DatasetType.REGION
                    || datasetType==DatasetType.REGION3D){
                nType = 2;
            }
            for (int i=0; i<themeUnique.getCount(); i++) {
                if (nType==1) {
                    Color colorOrg = themeUnique.getItem(i).getStyle().getLineColor();
                    if (colorOrg!=null && (mode==SMMapFixColorsMode.FCM_LB||mode==SMMapFixColorsMode.FCM_LH||mode==SMMapFixColorsMode.FCM_LS)) {
                        Color  matchedColor = colorTrance(colorOrg , mode , nSrc , nDes);
                        if (matchedColor!=null) {
                            themeUnique.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }
                }else if(nType==2){
                    Color colorF = themeUnique.getItem(i).getStyle().getFillForeColor();
                    if (colorF!=null && (mode==SMMapFixColorsMode.FCM_FB||mode==SMMapFixColorsMode.FCM_FH||mode==SMMapFixColorsMode.FCM_FS)) {
                        Color  matchedColor = colorTrance(colorF , mode , nSrc , nDes);
                        if (matchedColor!=null) {
                            themeUnique.getItem(i).getStyle().setFillForeColor(matchedColor);
                        }
                    }

                    Color colorOrg = themeUnique.getItem(i).getStyle().getLineColor();
                    if (colorOrg!=null && (mode==SMMapFixColorsMode.FCM_BB||mode==SMMapFixColorsMode.FCM_BH||mode==SMMapFixColorsMode.FCM_BS)) {
                        Color matchedColor = colorTrance(colorOrg , mode , nSrc , nDes);
                        if (matchedColor!=null) {
                            themeUnique.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }
                }
            }

        }
        else if(theme.getType() == ThemeType.RANGE){
            ThemeRange themeRange = (ThemeRange)theme;
            DatasetType datasetType = layer.getDataset().getType();
            int nType = 0;
            if (datasetType==DatasetType.POINT
                    || datasetType==DatasetType.POINT3D
                    || datasetType==DatasetType.LINE
                    || datasetType==DatasetType.NETWORK
                    || datasetType==DatasetType.LINE3D
                    || datasetType==DatasetType.NETWORK3D
            ){
                nType = 1;
            }
            else if(datasetType==DatasetType.REGION
                    || datasetType==DatasetType.REGION3D){
                nType = 2;
            }
            for (int i=0; i<themeRange.getCount(); i++) {
                if (nType==1) {
                    Color colorOrg = themeRange.getItem(i).getStyle().getLineColor();
                    if (colorOrg!=null && (mode==SMMapFixColorsMode.FCM_LB||mode==SMMapFixColorsMode.FCM_LH||mode==SMMapFixColorsMode.FCM_LS)) {
                        Color  matchedColor = colorTrance(colorOrg , mode , nSrc , nDes);
                        if (matchedColor!=null) {
                            themeRange.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }
                }else if(nType==2){
                    Color colorF = themeRange.getItem(i).getStyle().getFillForeColor();
                    if (colorF!=null && (mode==SMMapFixColorsMode.FCM_FB||mode==SMMapFixColorsMode.FCM_FH||mode==SMMapFixColorsMode.FCM_FS)) {
                        Color  matchedColor = colorTrance(colorF , mode , nSrc , nDes);
                        if (matchedColor!=null) {
                            themeRange.getItem(i).getStyle().setFillForeColor(matchedColor);
                        }
                    }

                    Color colorOrg = themeRange.getItem(i).getStyle().getLineColor();
                    if (colorOrg!=null && (mode==SMMapFixColorsMode.FCM_BB||mode==SMMapFixColorsMode.FCM_BH||mode==SMMapFixColorsMode.FCM_BS)) {
                        Color matchedColor = colorTrance(colorOrg , mode , nSrc , nDes);
                        if (matchedColor!=null) {
                            themeRange.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }
                }
            }
        }
        else if(theme.getType() == ThemeType.GRAPH){

        }
        else if(theme.getType() == ThemeType.GRADUATEDSYMBOL){

        }else if(theme.getType() == ThemeType.DOTDENSITY){

        }else if(theme.getType() == ThemeType.LABEL){
            ThemeLabel themeLabel = (ThemeLabel)theme;
            if (themeLabel.getLabels() != null) {
                // ThemeLabelMaxtrixPropertyManager
            } else if (themeLabel.getUniformMixedStyle() != null) {
                // ThemeLabelMixedPropertyManager
            } else if(themeLabel.getUniqueItems()!=null && themeLabel.getUniqueItems().getCount()>0) {
                for (int i = 0; i < themeLabel.getUniqueItems().getCount(); i++) {

                    Color colorF = themeLabel.getUniqueItems().getItem(i).getStyle().getForeColor();
                    if (colorF!=null && (mode==SMMapFixColorsMode.FCM_TB||mode==SMMapFixColorsMode.FCM_TH||mode==SMMapFixColorsMode.FCM_TS)){
                        Color matchedColor = colorTrance(colorF , mode , nSrc , nDes);
                        if (matchedColor!=null){
                            themeLabel.getUniqueItems().getItem(i).getStyle().setForeColor(matchedColor);
                        }
                    }
                    Color colorB = themeLabel.getUniqueItems().getItem(i).getStyle().getBackColor();
                    if (colorB!=null && (mode==SMMapFixColorsMode.FCM_TB||mode==SMMapFixColorsMode.FCM_TH||mode==SMMapFixColorsMode.FCM_TS)){
                        Color matchedColor = colorTrance(colorB , mode , nSrc , nDes);
                        if (matchedColor!=null){
                            themeLabel.getUniqueItems().getItem(i).getStyle().setBackColor(matchedColor);
                        }
                    }
                }

            } else if(themeLabel.getRangeItems() != null && themeLabel.getRangeItems().getCount()>0){

                for (int i = 0; i < themeLabel.getRangeItems().getCount(); i++) {

                    Color colorF = themeLabel.getRangeItems().getItem(i).getStyle().getForeColor();
                    if (colorF!=null && (mode==SMMapFixColorsMode.FCM_TB||mode==SMMapFixColorsMode.FCM_TH||mode==SMMapFixColorsMode.FCM_TS)){
                        Color matchedColor = colorTrance(colorF , mode , nSrc , nDes);
                        if (matchedColor!=null){
                            themeLabel.getRangeItems().getItem(i).getStyle().setForeColor(matchedColor);
                        }
                    }
                    Color colorB = themeLabel.getRangeItems().getItem(i).getStyle().getBackColor();
                    if (colorB!=null && (mode==SMMapFixColorsMode.FCM_TB||mode==SMMapFixColorsMode.FCM_TH||mode==SMMapFixColorsMode.FCM_TS)){
                        Color matchedColor =colorTrance(colorB , mode , nSrc , nDes);
                        if (matchedColor!=null){
                            themeLabel.getRangeItems().getItem(i).getStyle().setBackColor(matchedColor);
                        }
                    }
                }

            } else if (themeLabel.getUniformStyle() != null){
                Color colorF = themeLabel.getUniformStyle().getForeColor();
                if (colorF!=null && (mode==SMMapFixColorsMode.FCM_TB||mode==SMMapFixColorsMode.FCM_TH||mode==SMMapFixColorsMode.FCM_TS)){
                    Color matchedColor = colorTrance(colorF , mode , nSrc , nDes);
                    if (matchedColor!=null){
                        themeLabel.getUniformStyle().setForeColor(matchedColor);
                    }
                }
                Color colorB = themeLabel.getUniformStyle().getBackColor();
                if (colorB!=null && (mode==SMMapFixColorsMode.FCM_TB||mode==SMMapFixColorsMode.FCM_TH||mode==SMMapFixColorsMode.FCM_TS)){
                    Color matchedColor = colorTrance(colorB , mode , nSrc , nDes);
                    if (matchedColor!=null){
                        themeLabel.getUniformStyle().setBackColor(matchedColor);
                    }
                }
            }

        }
    }

    private Color colorTrance(Color srcColor,SMMapFixColorsMode mode,int nSrc,int nDes){

        ColorHSB hsb = new ColorHSB(srcColor);
        int nDistance = nDes - nSrc;

        if (mode==SMMapFixColorsMode.FCM_LH||mode==SMMapFixColorsMode.FCM_BH||mode==SMMapFixColorsMode.FCM_FH||mode==SMMapFixColorsMode.FCM_TH) {
            float tempH = hsb.getHue();
            tempH = tempH + nDistance*1.8f;
            hsb.setHue(tempH);
        }else if(mode==SMMapFixColorsMode.FCM_LS||mode==SMMapFixColorsMode.FCM_BS||mode==SMMapFixColorsMode.FCM_FS||mode==SMMapFixColorsMode.FCM_TS){
            float tempS = hsb.getSaturation();
            tempS = tempS + nDistance*0.005f;
            hsb.setSaturation(tempS);
        }else if(mode==SMMapFixColorsMode.FCM_LB||mode==SMMapFixColorsMode.FCM_BB||mode==SMMapFixColorsMode.FCM_FB||mode==SMMapFixColorsMode.FCM_TB){
            float tempB = hsb.getBrightness();
            tempB = tempB + nDistance*0.005f;
            hsb.setBrightness(tempB);
        }

        return hsb.toColor();

    }

    /**
     * 获取地图的所有子图层
     *
     * @DesktopJavaDocable enable
     */
    public ArrayList<Layer> getLayers(Map map) {
        ArrayList<Layer> layers = new ArrayList<Layer>();
        for (int i = 0; i < map.getLayers().getCount(); i++) {
            Layer layer = map.getLayers().get(i);
            if (layer instanceof LayerGroup) {
                layers.addAll(getLayers((LayerGroup) layer));
            } else {
                layers.add(layer);
            }
        }
        return layers;
    }

    /**
     * 获取图层分组的所有子图层
     *
     * @param layerGroup 图层分组
     * @DesktopJavaDocable enable
     */
    public ArrayList<Layer> getLayers(LayerGroup layerGroup) {
        ArrayList<Layer> layers = new ArrayList<Layer>();
        for (int i = 0; i < layerGroup.getCount(); i++) {
            Layer layer = layerGroup.get(i);
            if (layer instanceof LayerGroup) {
                layers.addAll(getLayers((LayerGroup) layer));
            } else {
                layers.add(layer);
            }
        }
        return layers;
    }


    public int getMapFixColorsModeValue(SMMapFixColorsMode mode){
        int index = mode.getIndex();
        return _param[index];
    }

}
