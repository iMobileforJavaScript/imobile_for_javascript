package com.supermap.smNative;

import android.util.Log;

import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.EngineType;
import com.supermap.data.Enum;
import com.supermap.data.Workspace;
import com.supermap.data.WorkspaceConnectionInfo;
import com.supermap.data.WorkspaceType;
import com.supermap.data.WorkspaceVersion;
import com.supermap.realspace.SceneControl;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class SMSceneWC {
    Workspace workspace;
    SceneControl sceneControl;
    public Workspace getWorkspace() {
        return workspace;
    }
    public void setWorkspace(Workspace workspace) {
        this.workspace = workspace;
    }
    public SceneControl getSceneControl() {
        return sceneControl;
    }
    public void setSceneControl(SceneControl sceneControl) {
        this.sceneControl = sceneControl;
    }
    public boolean openWorkspace(Map data) {
        try {
            WorkspaceConnectionInfo info = new WorkspaceConnectionInfo();
            if (data.containsKey("name")) {
                info.setName(data.get("name").toString());
            }
            if (data.containsKey("password")) {
                info.setPassword(data.get("password").toString());
            }
            if (data.containsKey("server")) {
                info.setServer(data.get("server").toString());
            }
            if (data.containsKey("type")) {
                Double type = Double.parseDouble(data.get("type").toString());
                info.setType((WorkspaceType) Enum.parse(WorkspaceType.class, type.intValue()));
            }
            if (data.containsKey("user")) {
                info.setUser(data.get("user").toString());
            }
            if (data.containsKey("version")) {
                Double version = Double.parseDouble(data.get("version").toString());
                info.setVersion((WorkspaceVersion) Enum.parse(WorkspaceVersion.class, version.intValue()));
            }

            boolean result = this.workspace.open(info);
            info.dispose();
            this.sceneControl.getScene().setWorkspace(this.workspace);
            return result;
        } catch (Exception e) {
            throw e;
        }
    }
    public Datasource openDatasource(Map data) {
        try {
            DatasourceConnectionInfo info = new DatasourceConnectionInfo();
            if (data.containsKey("alias")){
                String alias = data.get("alias").toString();
                info.setAlias(alias);

                if (this.workspace.getDatasources().indexOf(alias) != -1) {
                    this.workspace.getDatasources().close(alias);
                }
            }
            if (data.containsKey("engineType")){
                Double type = Double.parseDouble(data.get("engineType").toString());
                info.setEngineType((EngineType) Enum.parse(EngineType.class, type.intValue()));
            }
            if (data.containsKey("server")){
                info.setServer(data.get("server").toString());
            }


            if (data.containsKey("driver")) info.setDriver(data.get("driver").toString());
            if (data.containsKey("user")) info.setUser(data.get("user").toString());
            if (data.containsKey("readOnly")) info.setReadOnly(Boolean.parseBoolean(data.get("readOnly").toString()));
            if (data.containsKey("password")) info.setPassword(data.get("password").toString());
            if (data.containsKey("webCoordinate")) info.setWebCoordinate(data.get("webCoordinate").toString());
            if (data.containsKey("webVersion")) info.setWebVersion(data.get("webVersion").toString());
            if (data.containsKey("webFormat")) info.setWebFormat(data.get("webFormat").toString());
            if (data.containsKey("webVisibleLayers")) info.setWebVisibleLayers(data.get("webVisibleLayers").toString());
            if (data.containsKey("webExtendParam")) info.setWebExtendParam(data.get("webExtendParam").toString());

            Datasource dataSource = this.workspace.getDatasources().open(info);
            info.dispose();

            return dataSource;
        } catch (Exception e) {
            throw e;
        }
    }

    private boolean copyFileFromPath(String srcPath,String desPath){

        boolean copySucc=true;
        File fileDesPath=new File(desPath);
        if (!fileDesPath.exists()) {
            fileDesPath.mkdirs();
        }
        List<String> array=contentsOfDirectoryAtPath(srcPath);
        for (int i=0; i<array.size(); i++) {
            String fullPath =srcPath+"/"+array.get(i);
            String fullToPath =desPath+"/"+array.get(i);
            boolean isDir = false;
            File fileFullPath=new File(fullPath);
            boolean isExist =fileFullPath.exists();
            isDir=fileFullPath.isDirectory();
            if (isExist) {
                if(!copyFile(fullPath,fullToPath)){
                    copySucc = false;
                }
                if(isDir){
                    copyFileFromPath(fullPath,fullToPath);
                }
            }

        }
        return copySucc;

    }
    public WorkspaceConnectionInfo setWorkspaceConnectionInfo(Map<String,String> infoDic,Workspace workspace){
        WorkspaceConnectionInfo info;
        if (workspace == null) {
            info =new WorkspaceConnectionInfo();
        } else {
            info = workspace.getConnectionInfo();
        }
        String caption =infoDic.get("caption");
        int type = infoDic.get("type")!=null?Integer.parseInt(infoDic.get("type")):0;
        type=type>0?type:0;
        String server =infoDic.get("server");
        String user =infoDic.get("user");
        String password =infoDic.get("password");

        //        [info setServer:path];
        if (caption!=null) {
            workspace.setCaption(caption);
        }

        if (infoDic.containsKey("version")) {
            Double version = Double.parseDouble(infoDic.get("version").toString());
            info.setVersion((WorkspaceVersion) Enum.parse(WorkspaceVersion.class, version.intValue()));
        }

        if (user!=null) {
            info.setUser(user);
        }
        if (password!=null) {
            info.setPassword(password);
        }

        if (server!=null) {
            switch (type) {
                case 4:
                    info.setType(WorkspaceType.SXW);
                    if(!server.endsWith(".sxw")){
                        server =server+"/"+caption+".sxw";
                    }
                    break;

                // SMW 工作空间信息设置
                case 5:
                    info.setType(WorkspaceType.SMW);
                    if (!server.endsWith(".smw")) {
                        server =server+"/"+caption+".smw";
                    }
                    break;

                // SXWU 文件工作空间信息设置
                case 8:
                    info.setType(WorkspaceType.SXWU);
                    if (!server.endsWith(".sxwu")){
                        server =server+"/"+caption+".sxwu";
                    }
                    break;

                // SMWU 工作空间信息设置
                case 9:
                    info.setType(WorkspaceType.SMWU);
                    if (!server.endsWith(".smwu")) {
                        server=server+"/"+caption+".smwu";
                    }
                    break;

                // 其他情况
                default:
                    info.setType(WorkspaceType.SMWU);
                    if (!server.endsWith(".smwu")){
                        server =server+"/"+caption+".smwu";
                    }
                    break;
            }
            info.setServer(server);
        }
        return info;
    }

    String g_strCustomerDirectory = null;

    private String getCustomerDirectory(){
        if (g_strCustomerDirectory==null) {
//            g_strCustomerDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/iTablet/User/Customer"];
            g_strCustomerDirectory ="/sdcard/iTablet/User/Customer";
        }
        return g_strCustomerDirectory;

    }

    private void setCustomerDirectory(String strValue){
        g_strCustomerDirectory = strValue;
    }
    protected String formateNoneExistFileName(String strPath, boolean bDirFile) {
        String strName = strPath;
        String strSuffix = "";
        if (!bDirFile) {
            String[] arrPath=strPath.split("/");
            String strFileName=arrPath[arrPath.length-1];
            String[] arrFileName=strFileName.split(".");
            strSuffix=arrFileName[arrFileName.length-1];
            strName=strPath.substring(0,strPath.length()-strSuffix.length()-1);
        }
        String strResult = strPath;
        int nAddNumber = 1;
        while (true) {
            boolean isDir  = false;
            File fileStrResult=new File(strResult);
            boolean isExist =fileStrResult.exists();
            isDir=fileStrResult.isDirectory();
            if (!isExist) {
                return strResult;
            }else if(isDir!=bDirFile){
                return strResult;
            }else{
                if (!bDirFile) {
                    strResult =strName+"#"+nAddNumber+"."+strSuffix;
                }else{
                    strResult =strName+"#"+nAddNumber;
                }

                nAddNumber++;
            }
        }
    }

    public boolean export3DScenceName(String strScenceName,String strDesFolder){

        String strDir =getCustomerDirectory()+"/Scence";
        String srcPathPXP =strDir+"/"+strScenceName+".pxp";
        boolean isDir = true;
        File fileSrcPathPXP=new File(srcPathPXP);
        boolean isExist =fileSrcPathPXP.exists();
        isDir=fileSrcPathPXP.isDirectory();
        if (!isExist || isDir) {
            return false;
        }
        boolean result = false;
        String strScencePXP =stringWithContentsOfFile(srcPathPXP,"UTF-8");
        // {
        //  "Datasources":
        //                  [ {"Alians":strMapName,"Type":nEngineType,"Server":strDatasourceName} , {...} , {...} ... ] ,
        //  "Resources":
        //                  strMapName
        // }
        String strName=null;
        Map<String,String> dicTemp=new HashMap<>();
        try {
            JSONObject jsonObject = new JSONObject(strScencePXP);
            strName=jsonObject.optString("Name");
            JSONObject jsonObject1=jsonObject.optJSONObject("Workspace");
            Iterator<String> iterator=jsonObject1.keys();
            while (iterator.hasNext()){
                String key=iterator.next();
                dicTemp.put(key,jsonObject1.optString(key));
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        String strServer=dicTemp.get("server");
        isDir=true;
        String serverPath=strDir+"/"+strServer;
        File fileServerPath=new File(serverPath);
        isExist=fileServerPath.exists();
        isDir=fileServerPath.isDirectory();
        if (!isExist || isDir) {
            return false;
        }
        String[] arrServer=strServer.split("/");
        String strSrcFolder=strDir+"/"+arrServer[0];

        copyFile(strSrcFolder,strDesFolder);
        result = true;

        return result;
    }

    public boolean import3DWorkspaceInfo(Map<String,String> infoDic){

        boolean result = false;
        if(infoDic==null||infoDic.get("server")==null||infoDic.get("type")==null||workspace.getConnectionInfo().getServer().equals(infoDic.get("server"))) {
            return result;
        }
        Workspace importWorkspace =new Workspace();
        WorkspaceConnectionInfo info =setWorkspaceConnectionInfo(infoDic,null);

        if(importWorkspace.open(info)){
            String strSrcServer =infoDic.get("server");
            String[] arrSrcServer=strSrcServer.split("/");
            String strServerName =arrSrcServer[arrSrcServer.length-1];

            String strSrcFolder =strSrcServer.substring(0,strSrcServer.length()-strServerName.length()-1);
            String[] arrSrcFolder=strSrcFolder.split("/");
            String strFolderName =arrSrcFolder[arrSrcFolder.length-1];

            String strDesDir =getCustomerDirectory()+"/Scence";
//                [NSString stringWithFormat:@"%@/Scence",[self getCustomerDirectory]];
            String strDesFolder =strDesDir+"/"+strFolderName;
            //1.拷贝所有数据
            strDesFolder =formateNoneExistFileName(strDesFolder,true);
            //处理重名
            String[] arrDesFolder=strDesFolder.split("/");
            strFolderName =arrDesFolder[arrDesFolder.length-1];

            copyFile(strSrcFolder,strDesFolder);

            String strWorkspace =strFolderName+"/"+strServerName;
            Map<String,String> dicParame=new HashMap<>();
            dicParame.putAll(infoDic);
            dicParame.put("server",strWorkspace);

            //2.导出所有scence
            for (int i=0; i<importWorkspace.getScenes().getCount(); i++) {
                String strScenceName =importWorkspace.getScenes().get(i);
                String desScencePxp =strDesDir+"/"+strScenceName+".pxp";
                desScencePxp =formateNoneExistFileName(desScencePxp,false);

                JSONObject jsonObject = new JSONObject();
                try {
                    jsonObject.put("Name", strScenceName);
                    jsonObject.put("Workspace", new JSONObject(dicParame));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                String strExplorerJson = jsonObject.toString();
                try {
                    Writer outWriter = new OutputStreamWriter(new FileOutputStream(desScencePxp, true), "UTF-8");
                    outWriter.write(strExplorerJson);
                    outWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            importWorkspace.close();
            result = true;
        }

        info.dispose();
        importWorkspace.close();
        importWorkspace.dispose();

        return result;

    }

    private boolean openScenceName(String strScenceName,SceneControl sceneControl){
        if(sceneControl.getScene().getWorkspace()==null){
            return false;
        }
        String strDir =getCustomerDirectory()+"/Scence";
        String srcPathPXP =strDir+"/"+strScenceName+".pxp";
        boolean isDir = true;
        File filePathPXP=new File(srcPathPXP);
        boolean isExist =filePathPXP.exists();
        isDir=filePathPXP.isDirectory();
        if (!isExist || isDir) {
            return false;
        }
        boolean result = false;
        String strScencePXP =stringWithContentsOfFile(srcPathPXP,"UTF-8");
        // {
        //  "Datasources":
        //                  [ {"Alians":strMapName,"Type":nEngineType,"Server":strDatasourceName} , {...} , {...} ... ] ,
        //  "Resources":
        //                  strMapName
        // }

        String strName=null;
        Map<String,String> dicTemp=new HashMap<>();
        try {
            JSONObject jsonObject = new JSONObject(strScencePXP);
            strName=jsonObject.optString("Name");
            JSONObject jsonObject1=jsonObject.optJSONObject("Workspace");
            Iterator<String> iterator=jsonObject1.keys();
            while (iterator.hasNext()){
                String key=iterator.next();
                dicTemp.put(key,jsonObject1.optString(key));
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        String strServer=dicTemp.get("server");
        String strFullPath=strDir+"/"+strServer;

        isDir = true;
        File fileFullPath=new File(strFullPath);
        isExist=fileFullPath.exists();
        isDir=fileFullPath.isDirectory();
        if (!isExist || isDir) {
            return false;
        }

        Map<String,String> dicInfo=new HashMap<>();
        dicInfo.putAll(dicTemp);
        dicInfo.put("server",strFullPath);

        WorkspaceConnectionInfo info =setWorkspaceConnectionInfo(dicInfo,null);

        if(sceneControl.getScene().getWorkspace().getCaption().equals("UntitledWorkspace")){
            //工作空间未打开
            if(sceneControl.getScene().getWorkspace().open(info)){
                sceneControl.getScene().open(strName);
                result = true;
            }
        }else{

            if (sceneControl.getScene().getWorkspace().getConnectionInfo().getServer().equals(strFullPath)) {
                // 同一个工作空间
                if (sceneControl.getScene().getName().equals(strName)) {
                    result = true;
                }else{
                    sceneControl.getScene().close();
                    result =sceneControl.getScene().open(strName);
                }
            }else{
                // 不同工作空间
                sceneControl.getScene().close();
                sceneControl.getScene().getWorkspace().close();
                if (sceneControl.getScene().getWorkspace().open(info)) {
                    result =sceneControl.getScene().open(strName);
                }
            }

        }

        info.dispose();
        return result;
    }

    public boolean is3DWorkspaceInfo(Map<String,String> infoDic){
        boolean result = false;
        if(infoDic==null||infoDic.get("server")==null||infoDic.get("type")==null||workspace.getConnectionInfo().getServer().equals(infoDic.get("server"))){
            return result;
        }
            Workspace importWorkspace =new Workspace();
            WorkspaceConnectionInfo info =setWorkspaceConnectionInfo(infoDic,null);

            if(importWorkspace.open(info)){
                if (importWorkspace.getScenes().getCount()>0) {
                    result = true;
                }
                importWorkspace.close();
            }
        info.dispose();
        importWorkspace.close();
        importWorkspace.dispose();
        return result;
    }


    /**
     * 获取文件夹下所有子文件名称
     *
     * @param path
     * @return
     */
    private List<String> contentsOfDirectoryAtPath(String path) {
        File file = new File(path);
        File[] files = file.listFiles();
        List<String> s = new ArrayList<>();
        if (files == null) {
            Log.e("error", "空目录");
            return s;
        }
        for (int i = 0; i < files.length; i++) {
            s.add(files[i].getName());
        }
        return s;
    }

    private String stringWithContentsOfFile(String fileName, String encoding) {
        FileInputStream in = null;
        BufferedReader reader = null;
        StringBuilder content = new StringBuilder();
        try {
            in = new FileInputStream(new File(fileName));//文件名
            reader = new BufferedReader(new InputStreamReader(in, encoding));
            String line = "";
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return content.toString();
    }

    protected boolean copyFile(String oldPath, String newPath) {

        File oldfile = new File(oldPath);
        File newfile = new File(newPath);
        if (oldfile.exists()) {
            if (newfile.exists()) {
                newfile.delete();
            }

            try {
                newfile.createNewFile();
                FileInputStream input = new FileInputStream(oldPath);
                BufferedInputStream inBuff = new BufferedInputStream(input);
                FileOutputStream output = new FileOutputStream(newPath);
                BufferedOutputStream outBuff = new BufferedOutputStream(output);

                byte[] b = new byte[1024 * 5];
                int len;
                while ((len = inBuff.read(b)) != -1) {
                    outBuff.write(b, 0, len);
                }
                outBuff.flush();

                inBuff.close();
                outBuff.close();
                output.close();
                input.close();
            } catch (IOException e) {

            }

            return true;
        }
        return false;

    }
}
