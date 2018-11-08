package com.supermap.map3D.toolKit;

import com.supermap.data.CursorType;
import com.supermap.data.FieldInfos;
import com.supermap.data.QueryParameter;
import com.supermap.data.Workspace;
import com.supermap.imb.jsonlib.SiJsonArray;
import com.supermap.imb.jsonlib.SiJsonObject;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Feature3DSearchOption;
import com.supermap.realspace.Feature3Ds;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DOSGBFile;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.Selection3D;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Map;

/**
 * Created by zym on 2018/11/6.
 */

public class Utils {
    // ���ݳ������ƻ�ȡͬ���ķ���·�ߣ���Ҫȷ�Ϸ����ļ��Ĵ��λ��
    public static String getFlyRoutePath(String localDataPath, String sceneName) {
        String flyRoutePath = "";

        if (new File(localDataPath).exists()) {
            flyRoutePath = localDataPath + sceneName + ".fpf";
            if (new File(flyRoutePath).exists()) {
                return flyRoutePath;
            }
        }
        return null;
    }

    // ���Բ�ѯ��url Ϊ�յ����
    public static void urlNUll(Scene tempScene, int _nID, Workspace mWorkspace, Map<String,String> attributeMap) {

        // ��������Դ���϶������
        int _nDSCount = mWorkspace.getDatasources().getCount();
        if (_nDSCount > 0) {
            String sceneName = tempScene.getName();
            com.supermap.data.Datasource datasetsource = mWorkspace.getDatasources().get(sceneName);
            if (datasetsource != null) {
                com.supermap.data.DatasetVector datasetVector = (com.supermap.data.DatasetVector) (datasetsource
                        .getDatasets().get(sceneName));
                if (datasetVector != null) {
                    String strFilter = "SmID = '" + _nID + "'";
                    // QueryParameter
                    com.supermap.data.QueryParameter parameter = new QueryParameter();
                    parameter.setAttributeFilter(strFilter);
                    // CursorType
                    parameter.setCursorType(CursorType.STATIC);
                    // recordset
                    // ��¼����ͨ�����ַ�ʽ��ã��ڵ�ͼ�ؼ���ѡ�����ɸ����ζ����γ�һ��ѡ�񼯣�Ȼ���ѡ��ת��Ϊ��¼�������ߴ�ʸ�����ݼ��л��һ����¼����
                    // �����ַ����� �û�����ͨ��
                    // DatasetVector.getRecordset()
                    // ����ֱ�Ӵ�ʸ�����ݼ��з��ؼ�¼����Ҳ����ͨ����ѯ��䷵�ؼ�¼��������ͬ����ǰ�ߵõ��ļ�¼���������༯�ϵ�ȫ���ռ伸����Ϣ��������Ϣ
                    // ��
                    // �����ߵõ����Ǿ�����ѯ����������˵ļ�¼����

                    com.supermap.data.Recordset recordset = datasetVector.query(parameter);

                    if (recordset.getRecordCount() >= 1) {
                        // FieldInfos

                        FieldInfos fieldInfos = datasetVector.getFieldInfos();

                        recordset.moveFirst();

                        ArrayList<String> nameList = new ArrayList<String>();

                        for (int n = 0; n < fieldInfos.getCount(); n++) {
                            String name = fieldInfos.get(n).getName();
                            // ����sm��ʱ����Թ���
                            if (name.toLowerCase().startsWith("sm")) {
                                continue;
                            }
                            nameList.add(name + ":");
                            String strValue;
                            Object value = recordset.getFieldValue(name);
                            if (value == null) {
                                strValue = "";
                            } else {
                                strValue = value.toString();

                            }

                            if (!nameList.contains(name)) {
                                attributeMap.put(name + ":", strValue);
                            }

                        }

                        // fieldInfos.dispose();
                        recordset.dispose();
                        nameList.clear();
                    }
                }
            }
        }

    }

    // ���Բ�ѯʱ��ʸ������
    public static void vect(Selection3D selection, Layer3D layer, FieldInfos fieldInfos, Map<String,String> attributeMap) {
        Feature3D feature = null;
        Layer3DOSGBFile layer3d=null;
        if (layer.getType() == Layer3DType.OSGBFILE) {

            layer3d = (Layer3DOSGBFile) layer;
            //Selection3D selection3d = layer3d.getSelection();
        } else if (layer.getType() == Layer3DType.VECTORFILE) {
            feature = selection.toFeature3D();
        }
        int count=0;
        Object[] str=null;
        if(feature==null){
            str=layer3d.getAllFieldValueOfLastSelectedObject();
            if(str!=null){
                count=str.length;
            }
        }else{
            count=fieldInfos.getCount();
        }

        for (int j = 0; j < count; j++) {
            String name = fieldInfos.get(j).getName();
//				if (name.toLowerCase().startsWith("sm")) {
//					continue;
//				}
            String strValue;
            Object value;
            if(feature==null){
                value=str[j];
            }else{
                value = feature.getFieldValue(name);
            }
            if (value.equals("NULL")) {
                strValue = "";
            } else {
                strValue = value.toString();
            }
            attributeMap.put(name + ":",strValue);
        }

    }


    // ���Բ�ѯʱ ��ѯKML������
    public static void KMLData(Layer3D layer, int id, Map<String,String> attributeMap) {

        Feature3Ds fer = layer.getFeatures();
        if (fer != null && fer.getCount() > 0) {
            Feature3D fer3d = fer.findFeature(id, Feature3DSearchOption.ALLFEATURES);
            if (fer3d != null) {
                String value = fer3d.getDescription();
                String value1 = fer3d.getName();
                attributeMap.put("name:",value1);
                attributeMap.put("description:",value);
            }

        }

    }

    //	// ���Բ�ѯ��url ��Ϊ�յ���� ��������
    public static void urlNoNULL(SceneControl mSceneControl, String sceneUrl, int id, Map<String,String> attributeMap) {

        String Sceneurl = mSceneControl.getScene().getUrl();

        String sceneName = mSceneControl.getScene().getName();

        String jsonURL = "http://www.supermapol.com/realspace/services/data-" + sceneName + "/rest/data/datasources/"
                + sceneName + "/datasets/" + sceneName + "/features/" + id + ".rjson";

        StringBuilder json = new StringBuilder();
        try {
            URL urlObject = new URL(jsonURL);
            URLConnection uc = urlObject.openConnection();
            uc.setConnectTimeout(3000);
            uc.setReadTimeout(3000);
            BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream()));
            String inputLine = null;
            while ((inputLine = in.readLine()) != null) {
                json.append(inputLine);
            }
            in.close();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        String jsonContent = json.toString();
        if (!(jsonContent == null || jsonContent.isEmpty() || jsonContent.equals(""))) {
            SiJsonObject jsonObject = new SiJsonObject(jsonContent);

            SiJsonArray fieldNames = jsonObject.getJsonArray("fieldNames");
            SiJsonArray fieldValues = jsonObject.getJsonArray("fieldValues");

            for (int m = 0; m < fieldNames.getArraySize(); m++) {
                String name = fieldNames.getString(m);
                String fieldValuesJson = fieldValues.getString(m);

                if (name.toLowerCase().startsWith("sm")) {
                    continue;
                }
                attributeMap.put(name + ":", fieldValuesJson);
            }

            fieldNames.dispose();
            fieldValues.dispose();

            jsonObject.dispose();
            jsonObject = null;
        }

    }
}
