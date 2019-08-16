package com.supermap.smNative;


import com.supermap.data.Color;
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

public class SMMapRender {



    private static SMMapRender smMapRender;

    StarCoreFactory starcore = null;
    StarServiceClass Service = null;

    private String strPackageName = null;   //包名
    private String strNativeLibDir = null;  //python库路径

    private Handler myhandler = null;
    private SMMapRender(){
        m_bBegin = true;
        new Thread(){
           @Override
            public void run(){

               onInitiallise();  //初始化python环境

               //建立消息循环
               Looper.prepare();
               myhandler = new Handler(){
                   @Override
                   public void handleMessage(Message msg){

                       Bundle bundle = msg.getData();
                       String strImgPath = bundle.getString("imgPath");
                       String strMapPath = bundle.getString("mapPath");
                       int nCount = bundle.getInt("count");
                       int nMode = bundle.getInt("mode");

                        pythonMatchPictureStyle(strImgPath,strMapPath,nCount,nMode);
                   }
               };
               //可以开始你的表演
               m_bBegin = false;
               Looper.loop();
           }

        }.start();



    }

    public static SMMapRender getInstance() {
        SMap.getInstance();
        if (smMapRender==null){
            smMapRender = new SMMapRender();
        }
        return smMapRender;
    }

    private String getPackageName(){
        return strPackageName;
    }

    private void copyFile(AssetManager assetManager, String Name,String desPath,boolean Overwrite) throws IOException {

        File outfile = null;
        if( desPath != null )
            outfile = new File("/data/data/"+getPackageName()+"/files/"+desPath+Name);
        else
            outfile = new File("/data/data/"+getPackageName()+"/files/"+Name);
        if (Overwrite == true || !outfile.exists()) {
            outfile.createNewFile();
            FileOutputStream out = new FileOutputStream(outfile);
            byte[] buffer = new byte[1024];
            InputStream in;
            int readLen = 0;
            in = assetManager.open(Name);
            while((readLen = in.read(buffer)) != -1){
                out.write(buffer, 0, readLen);
            }
            out.flush();
            in.close();
            out.close();
        }
    }

    private static boolean CreatePath(String Path){
        File destCardDir = new File(Path);
        if(!destCardDir.exists()){
            int Index = Path.lastIndexOf(File.separator.charAt(0));
            if( Index < 0 ){
                if( destCardDir.mkdirs() == false )
                    return false;
            }else{
                String ParentPath = Path.substring(0, Index);
                if( CreatePath(ParentPath) == false )
                    return false;
                if( destCardDir.mkdirs() == false )
                    return false;
            }
        }
        return true;
    }

    private static boolean unzip(InputStream zipFileName, String outputDirectory,Boolean OverWriteFlag ) {
        try {
            ZipInputStream in = new ZipInputStream(zipFileName);
            ZipEntry entry = in.getNextEntry();
            byte[] buffer = new byte[1024];
            while (entry != null) {
                File file = new File(outputDirectory);
                file.mkdir();
                if (entry.isDirectory()) {
                    String name = entry.getName();
                    name = name.substring(0, name.length() - 1);
                    if( CreatePath(outputDirectory + File.separator + name) == false )
                        return false;
                } else {
                    String name = outputDirectory + File.separator + entry.getName();
                    int Index = name.lastIndexOf(File.separator.charAt(0));
                    if( Index < 0 ){
                        file = new File(outputDirectory + File.separator + entry.getName());
                    }else{
                        String ParentPath = name.substring(0, Index);
                        if( CreatePath(ParentPath) == false )
                            return false;
                        file = new File(outputDirectory + File.separator + entry.getName());
                    }
                    if( !file.exists() || OverWriteFlag == true){
                        file.createNewFile();
                        FileOutputStream out = new FileOutputStream(file);
                        int readLen = 0;
                        while((readLen = in.read(buffer)) != -1){
                            out.write(buffer, 0, readLen);
                        }
                        out.close();
                    }
                }
                entry = in.getNextEntry();
            }
            in.close();
            return true;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }


    private void onInitiallise(){

        SMap smapInstance = SMap.getInstance();
        AssetManager assetManager = smapInstance.getAssets();
        strPackageName = smapInstance.getPackageName();
        strNativeLibDir = smapInstance.getNativeLibraryDir();

        File destDir = new File("/data/data/"+getPackageName()+"/files");
        if(!destDir.exists())
            destDir.mkdirs();
        java.io.File python2_7_libFile = new java.io.File("/data/data/"+getPackageName()+"/files/python2.7.zip");
        if( !python2_7_libFile.exists() ){
            try{
                copyFile(assetManager,"python2.7.zip",null,false);
            }
            catch(Exception e){
            }
        }

        try{
            InputStream dataSource = assetManager.open("PIL.zip");
            unzip(dataSource, "/data/data/"+getPackageName()+"/files",false );
            dataSource.close();
        }
        catch(Exception e)
        {

        }

        try{
            copyFile(assetManager,"array.so",null,false);
            copyFile(assetManager,"_io.so",null,false);
            copyFile(assetManager,"_struct.so",null,false);
            copyFile(assetManager,"math.so",null,false);
            copyFile(assetManager,"itertools.so",null,false);
            copyFile(assetManager,"operator.so",null,false);
            copyFile(assetManager,"_collections.so",null,false);
            copyFile(assetManager,"cStringIO.so",null,false);
            copyFile(assetManager,"zlib.so",null,false);
            copyFile(assetManager,"time.so",null,false);
//            copyFile(assetManager,"dir.png",null,false);
//            copyFile(assetManager,"dir.jpg",null,false);
//            copyFile(assetManager,"test.py",null,true);
        }
        catch(Exception e){
            System.out.println(e);
        }

        /*----init starcore----*/
        StarCoreFactoryPath.StarCoreCoreLibraryPath = strNativeLibDir;
        StarCoreFactoryPath.StarCoreShareLibraryPath = strNativeLibDir;
        StarCoreFactoryPath.StarCoreOperationPath = "/data/data/"+getPackageName()+"/files";


        starcore = StarCoreFactory.GetFactory();
        Service=starcore._InitSimple("test","123",0,0);


        starcore._RegMsgCallBack_P(new StarMsgCallBackInterface(){
            public Object Invoke(int ServiceGroupID, int uMes, Object wParam, Object lParam){
                if (uMes == starcore._Getint("MSG_DISPMSG") || uMes == starcore._Getint("MSG_DISPLUAMSG") )
                {
                    String strResult = (String)wParam;
                    recievePythonResult(strResult);
                }
                return null;
            }
        });

        StarSrvGroupClass SrvGroup = (StarSrvGroupClass)Service._Get("_ServiceGroup");
        Service._CheckPassword(false);

        SrvGroup._InitRaw("python",Service);
        StarObjectClass python = Service._ImportRawContext("python","",false,"");
        python._Call("import", "sys");

        StarObjectClass pythonSys = python._GetObject("sys");
        StarObjectClass pythonPath = (StarObjectClass)pythonSys._Get("path");
        pythonPath._Call("insert",0,"/data/data/"+getPackageName()+"/files/python2.7.zip");
        pythonPath._Call("insert",0,strNativeLibDir);
        pythonPath._Call("insert",0,"/data/data/"+getPackageName()+"/files");

        m_matchedColors = new HashMap<Color, MatchedColors>();
    }

    private boolean m_bBegin = true;
    private synchronized boolean tryBeginePython(){
        if (m_bBegin){
            return false;
        }else{
            m_bBegin = true;
            return true;
        }
    }

    private synchronized void endPython(){
        m_bBegin = false;
    }

    class MatchedColors {

        private Color sourceColor ;

        public Color getSourceColor() {
            return sourceColor;
        }

        public void setSourceColor(Color sourceColor) {
            this.sourceColor = sourceColor;
        }


        private Color keyColor ;

        public Color getKeyColor() {
            return keyColor;
        }

        public void setKeyColor(Color keyColor) {
            this.keyColor = keyColor;
        }


        private Color resultColor;

        public Color getResultColor() {
            return resultColor;
        }

        public void setResultColor(Color resultColor) {
            this.resultColor = resultColor;
        }


        public MatchedColors() {
        }

        public MatchedColors(Color sourceColor, Color keyColor, Color resultColor) {
            this.sourceColor = sourceColor;
            this.keyColor = keyColor;
            this.resultColor = resultColor;
        }
    }

    HashMap<Color, MatchedColors> m_matchedColors = null;
    private ArrayList<Color> m_arrColors = null;

    private void pythonMatchPictureStyle(String strPicPath1 , String strPicPath2 ,int nColorCount ,int nMode){

//        if ( !canBeginePython() ){
//            return;
//        }

        m_matchedColors.clear();
        m_arrColors = null;

        String script = "import os, sys\n" +
                "import traceback\n" +
                "try:\n" +
                "    from PIL import Image\n" +
                "\n" +
                "    def get_colors(pic, colors, mode):\n" +
                "    \tcolor_str = []\n" +
                "    \timg = Image.open(pic)\n" +
                "    \tif mode != 0:\n" +
                "    \t\toriginalWidth, originalHeight = img.size\n" +
                "    \t\tpercentWidth = 200*1.0 / originalWidth\n" +
                "    \t\tpercentHeight = 200*1.0 / originalHeight\n" +
                "    \t\tif percentHeight < percentWidth:\n" +
                "    \t\t\tpercent = percentHeight\n" +
                "    \t\telse:\n" +
                "    \t\t\tpercent = percentWidth\n" +
                "    \t\twidth2 = int(round(originalWidth * percent))\n" +
                "    \t\theight2 = int(round(originalHeight * percent))\n" +
                "    \tif mode == 1:\n" +
                "    \t\timg = img.resize((width2, height2), Image.ANTIALIAS)\n" +
                "    \telif mode == 2:\n" +
                "    \t\timg = img.resize((width2, height2), Image.NEAREST)\n" +
                "    \telif mode == 3:\n" +
                "    \t\timg = img.resize((width2, height2), Image.BILINEAR)\n" +
                "    \telif mode == 4:\n" +
                "    \t\timg = img.resize((width2, height2), Image.BICUBIC)\n" +
                "    \twidth, height = img.size\n" +
                "    \tquantized = img.quantize(colors, kmeans=3)\n" +
                "    \tconvert_rgb = quantized.convert('RGB')\n" +
                "    \tcolors = convert_rgb.getcolors()\n" +
                "    \tcolor_str = sorted(colors, reverse=True)\n" +
                "    \tfinal_list = []\n" +
                "    \tfor i in color_str:\n" +
                "    \t\tfinal_list.append((i[1][0]<<16)|(i[1][1]<<8)|i[1][2])\n" +
                "    \treturn final_list\n" +
                "\n" +
                "    path1 = \"" + strPicPath1 + "\"\n" +
                "    path2 = \"" + strPicPath2 + "\"\n" +
                "    color_count = " + nColorCount + "\n" +
                "    mode = " + nMode + "\n" +
                "    result1 = get_colors(path1, color_count, mode)\n" +
                "    result2 = get_colors(path2, color_count, mode)\n" +
                "    print(result1)\n" +
                "    print(result2)\n" +
                "    \n" +
                "except Exception,e:\n" +
                "    traceback.print_exc()";
        starcore._SRPLock();
        Service._RunScript("python", script + "\n", "", "");
        starcore._SRPUnLock();


    }

    private void recievePythonResult(String strResult) {
        //JSONObject jsonObject = new JSONObject(strResult);
        try{
            JSONArray jsonArray = new JSONArray(strResult);
            if (jsonArray != null) {
                ArrayList<Color> arrColors =  new ArrayList<Color>();

                for (int index = 0; index < jsonArray.length(); index++) {
                    String strNum = jsonArray.getString(index);
                    Color color = new Color(Integer.parseInt(strNum));
                    arrColors.add( color );
                }

                if (m_arrColors == null){
                    m_arrColors = arrColors;
                }else{

                    setMapColors(SMap.getInstance().getSmMapWC().getMapControl().getMap() , m_arrColors ,arrColors);

                    endPython();
                }
            }
        }catch (Exception e){
            System.out.println(e);
            endPython();
        }



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


    void setMapColors( Map map , ArrayList<Color> arrDesColors ,ArrayList<Color> arrSrcColors ){


        m_matchedColors.clear();
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
                        setDatasetVectorSimplyColors(layer, arrDesColors, arrSrcColors);
                    } else {
                        setDatasetVectorThemeColors(layer, arrDesColors, arrSrcColors);
                    }
                }
                //else if (DatasetTypeUtilities.isGridDataset(layer.getDataset().getType())) {
                //}
                //else if (DatasetTypeUtilities.isImageDataset(layer.getDataset().getType())) {
                //}
            }
        }

        map.refresh();
    }

    private Color getMatchedColor(Color color,ArrayList<Color> arrDesColors ,ArrayList<Color> arrSrcColors){
        return getMatchedColor(color,arrDesColors,arrSrcColors,100);
    }

    private Color getMatchedColor(Color color,ArrayList<Color> arrDesColors ,ArrayList<Color> arrSrcColors,int tolerance){
        Color resultColor = null;
        int minTolerance = tolerance * 3;
        Color keyColor = null;
        if (m_matchedColors.containsKey(color)) {
            resultColor = m_matchedColors.get(color).getResultColor();
            keyColor = m_matchedColors.get(color).getKeyColor();
            minTolerance = Math.abs(keyColor.getR() - color.getR()) + Math.abs(keyColor.getG() - color.getG()) + Math.abs(keyColor.getB() - color.getB());
        } else {
            int index = -1;
            for (int i=0;i<arrSrcColors.size();i++) {
                Color key = arrSrcColors.get(i);
                if (Math.abs(key.getR() - color.getR()) + Math.abs(key.getG() - color.getG()) + Math.abs(key.getB() - color.getB()) < minTolerance) {
                    //if (resultColor == null) {
                        //keyColor = key;
                        index = i;
                        minTolerance = Math.abs(key.getR() - color.getR()) + Math.abs(key.getG() - color.getG()) + Math.abs(key.getB() - color.getB());
                    //}
//                    else if (Math.abs(key.getR() - color.getR()) + Math.abs(key.getG() - color.getG()) + Math.abs(key.getB() - color.getB())
//                            < Math.abs(keyColor.getR() - color.getR()) + Math.abs(keyColor.getG() - color.getG()) + Math.abs(keyColor.getB() - color.getB())) {
//                        //keyColor = key;
//                        index = i;
//                        minTolerance = Math.abs(key.getR() - color.getR()) + Math.abs(key.getG() - color.getG()) + Math.abs(key.getB() - color.getB());
//                    }
                }
            }

            if (index>=0) {
                keyColor = arrSrcColors.get(index);
                resultColor = arrDesColors.get(index);
               // matchedColors.remove(keyColor);

                MatchedColors matchedColorsItem = new MatchedColors(color, keyColor, resultColor);
                if (!m_matchedColors.containsKey(color)) {
                    m_matchedColors.put(color, matchedColorsItem);
                }
            }
        }
        return resultColor;
    }

    private void setDatasetVectorSimplyColors(Layer layer, ArrayList<Color> arrDesColors ,ArrayList<Color> arrSrcColors ) {

        DatasetType datasetType = layer.getDataset().getType();
        if (datasetType==DatasetType.POINT
                || datasetType==DatasetType.POINT3D
                || datasetType==DatasetType.LINE
                || datasetType==DatasetType.NETWORK
                || datasetType==DatasetType.LINE3D
                || datasetType==DatasetType.NETWORK3D
        ){
            Color colorOrg = ((LayerSettingVector) layer.getAdditionalSetting()).getStyle().getLineColor();
            if (colorOrg!=null){
                Color matchedColor = getMatchedColor(colorOrg,arrDesColors,arrSrcColors);
                if (matchedColor!=null){
                    //LayerSettingVector layerSettingVector = layer.getAdditionalSetting();
                    ((LayerSettingVector) layer.getAdditionalSetting()).getStyle().setLineColor(matchedColor);
                }
            }

        } else if (datasetType==DatasetType.REGION
                || datasetType==DatasetType.REGION3D) {
            Color colorOrgL = ((LayerSettingVector) layer.getAdditionalSetting()).getStyle().getLineColor();
            if (colorOrgL!=null){
                Color matchedColor = getMatchedColor(colorOrgL,arrDesColors,arrSrcColors);
                if (matchedColor!=null){
                    ((LayerSettingVector) layer.getAdditionalSetting()).getStyle().setLineColor(matchedColor);
                }
            }

            Color colorOrgF = (((LayerSettingVector) layer.getAdditionalSetting())).getStyle().getFillForeColor();
            if (colorOrgF!=null){
                Color matchedColor = getMatchedColor(colorOrgF,arrDesColors,arrSrcColors);
                if (matchedColor!=null){
                    ((LayerSettingVector) layer.getAdditionalSetting()).getStyle().setFillForeColor(matchedColor);
                }
            }
        }
    }

    private void setDatasetVectorThemeColors(Layer layer, ArrayList<Color> arrDesColors ,ArrayList<Color> arrSrcColors ) {
        Theme theme = layer.getTheme();
        if (theme.getType() == ThemeType.UNIQUE) {
            ThemeUnique themeUnique = (ThemeUnique) theme;
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
            for (int i = 0; i < themeUnique.getCount(); i++) {
                if (nType==1) {
                    Color colorOrg = themeUnique.getItem(i).getStyle().getLineColor();
                    if (colorOrg!=null){
                        Color matchedColor = getMatchedColor(colorOrg,arrDesColors,arrSrcColors);
                        if (matchedColor!=null){
                           themeUnique.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }
                } else if (nType==2) {
                    Color colorL = themeUnique.getItem(i).getStyle().getLineColor();
                    if (colorL != null) {
                        Color matchedColor = getMatchedColor(colorL,arrDesColors,arrSrcColors);
                        if (matchedColor!=null) {
                            themeUnique.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }

                    Color colorF = themeUnique.getItem(i).getStyle().getFillForeColor();
                    if (colorF != null) {
                        Color matchedColor = getMatchedColor(colorF,arrDesColors,arrSrcColors);
                        if (matchedColor!=null) {
                            themeUnique.getItem(i).getStyle().setFillForeColor(matchedColor);
                        }
                    }
                }
            }
        } else if (theme.getType() == ThemeType.RANGE) {
            ThemeRange themeRange = (ThemeRange) theme;
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
            for (int i = 0; i < themeRange.getCount(); i++) {
                if (nType==1) {
                    Color colorOrg = themeRange.getItem(i).getStyle().getLineColor();
                    if (colorOrg!=null){
                        Color matchedColor = getMatchedColor(colorOrg,arrDesColors,arrSrcColors);
                        if (matchedColor!=null){
                            themeRange.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }
                } else if (nType==2) {
                    Color colorL = themeRange.getItem(i).getStyle().getLineColor();
                    if (colorL != null) {
                        Color matchedColor = getMatchedColor(colorL,arrDesColors,arrSrcColors);
                        if (matchedColor!=null) {
                            themeRange.getItem(i).getStyle().setLineColor(matchedColor);
                        }
                    }

                    Color colorF = themeRange.getItem(i).getStyle().getFillForeColor();
                    if (colorF != null) {
                        Color matchedColor = getMatchedColor(colorF,arrDesColors,arrSrcColors);
                        if (matchedColor!=null) {
                            themeRange.getItem(i).getStyle().setFillForeColor(matchedColor);
                        }
                    }
                }
            }
        } else if (theme.getType() == ThemeType.GRAPH) {

        } else if (theme.getType() == ThemeType.GRADUATEDSYMBOL) {

        } else if (theme.getType() == ThemeType.DOTDENSITY) {

        } else if (theme.getType() == ThemeType.LABEL) {
            ThemeLabel themeLabel = (ThemeLabel) theme;

            if (themeLabel.getLabels() != null) {
                // ThemeLabelMaxtrixPropertyManager
            } else if (themeLabel.getUniformMixedStyle() != null) {
                // ThemeLabelMixedPropertyManager
            } else if(themeLabel.getUniqueItems()!=null && themeLabel.getUniqueItems().getCount()>0) {
                for (int i = 0; i < themeLabel.getUniqueItems().getCount(); i++) {

                    Color colorF = themeLabel.getUniqueItems().getItem(i).getStyle().getForeColor();
                    if (colorF!=null){
                        Color matchedColor = getMatchedColor(colorF,arrDesColors,arrSrcColors);
                        if (matchedColor!=null){
                           themeLabel.getUniqueItems().getItem(i).getStyle().setForeColor(matchedColor);
                        }
                    }
                    Color colorB = themeLabel.getUniqueItems().getItem(i).getStyle().getBackColor();
                    if (colorB!=null){
                        Color matchedColor = getMatchedColor(colorB,arrDesColors,arrSrcColors);
                        if (matchedColor!=null){
                            themeLabel.getUniqueItems().getItem(i).getStyle().setBackColor(matchedColor);
                        }
                    }
                }

            } else if(themeLabel.getRangeItems() != null && themeLabel.getRangeItems().getCount()>0){

                for (int i = 0; i < themeLabel.getRangeItems().getCount(); i++) {

                    Color colorF = themeLabel.getRangeItems().getItem(i).getStyle().getForeColor();
                    if (colorF!=null){
                        Color matchedColor = getMatchedColor(colorF,arrDesColors,arrSrcColors);
                        if (matchedColor!=null){
                            themeLabel.getRangeItems().getItem(i).getStyle().setForeColor(matchedColor);
                        }
                    }
                    Color colorB = themeLabel.getRangeItems().getItem(i).getStyle().getBackColor();
                    if (colorB!=null){
                        Color matchedColor = getMatchedColor(colorB,arrDesColors,arrSrcColors);
                        if (matchedColor!=null){
                            themeLabel.getRangeItems().getItem(i).getStyle().setBackColor(matchedColor);
                        }
                    }
                }

            } else if (themeLabel.getUniformStyle() != null){
                Color colorF = themeLabel.getUniformStyle().getForeColor();
                if (colorF!=null){
                    Color matchedColor = getMatchedColor(colorF,arrDesColors,arrSrcColors);
                    if (matchedColor!=null){
                        themeLabel.getUniformStyle().setForeColor(matchedColor);
                    }
                }
                Color colorB = themeLabel.getUniformStyle().getBackColor();
                if (colorB!=null){
                    Color matchedColor = getMatchedColor(colorB,arrDesColors,arrSrcColors);
                    if (matchedColor!=null){
                        themeLabel.getUniformStyle().setBackColor(matchedColor);
                    }
                }
            }

        } else if (theme.getType() == ThemeType.CUSTOM) {

        }
    }

    private double waitTime = 1.5;// 等待时间
    public void setWaitTime(double nWaitSecounds){
        if (nWaitSecounds<0.1){
            waitTime=0.1;
        }else{
            waitTime = nWaitSecounds;
        }

    }
    public double getWaitTime(){
        return waitTime;
    }

    public void matchPictureStyle( final String strImagePath ){

        //如未初始化完成 等待下
//        while (myhandler==null){
//            try {
//                Thread.sleep(100);
//            }catch (Exception e){
//
//            }
//        }
        int perSleep = 100;
        int waitMax = (int)(waitTime*1000)/perSleep;
        int count = 0;
        //如未初始化完成或正在run 等待
        while ( count<waitMax  &&  !tryBeginePython()){
            try {
                Thread.sleep(perSleep);
            }catch (Exception e){

            }
            count++;
        }

        if (count==waitMax){
            return;
        }

        final Handler handler = new Handler(Looper.getMainLooper());
        //final String strMathImagePath = strImagePath;
        handler.post(new Runnable() {

            @Override
            public void run() {
                MapControl mapContral = SMap.getInstance().getSmMapWC().getMapControl();
                if (mapContral.getMap().getLayers().getCount()==0 ){
                    endPython();
                    return;
                }
                // 输出map的图像
                final Bitmap bitmap = Bitmap.createBitmap(mapContral.getWidth(),mapContral.getHeight(), Bitmap.Config.ARGB_8888);
                mapContral.outputMap(bitmap);

                new Thread(){
                    @Override
                    public void run(){
                        String strDir = android.os.Environment.getExternalStorageDirectory().getAbsolutePath() + "/SuperMap";
                        String strMapPath = strDir + "/temporary.jpg";
                        try {
                            //目录
                            File fileDesDir = new File(strDir);
                            boolean isExist = fileDesDir.exists();
                            boolean isDir = fileDesDir.isDirectory();
                            if (!isExist || !isDir) {
                                fileDesDir.mkdirs();
                            }
                            //文件
                            File file = new File(strMapPath);
                            if (!file.exists()){
                                file.createNewFile();
                            }
                            //写入
                            BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(file));
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out);
                            out.flush();
                            out.close();

                        } catch (Exception e) {
                            e.printStackTrace();
                            endPython();
                            return;
                        }

                        Message msg = myhandler.obtainMessage();
                        Bundle bundle = new Bundle();
                        bundle.putString("imgPath",strImagePath);
                        bundle.putString("mapPath",strMapPath);
                        bundle.putInt("count",50);
                        bundle.putInt("mode",2);
                        msg.setData(bundle);
                        msg.sendToTarget();
                    }
                }.start();

            }

        });

//        waitMax = (waitMax>5*1000/perSleep)?(5*1000/perSleep):waitMax;
//        //处理超时
//        count=0;
//        while ( count<waitMax && m_bBegin==true){
//            try {
//                Thread.sleep(perSleep);
//            }catch (Exception e){
//
//            }
//            count++;
//        }
//        if ( count==waitMax ){
//            endPython();
//        }

    }

}
