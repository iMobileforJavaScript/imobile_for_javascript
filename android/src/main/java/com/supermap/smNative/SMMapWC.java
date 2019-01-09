package com.supermap.smNative;

import android.util.JsonToken;
import android.util.Log;

import com.facebook.react.bridge.ReadableArray;
import com.supermap.RNUtils.FileUtil;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EngineType;
import com.supermap.data.Enum;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Recordset;
import com.supermap.data.Symbol;
import com.supermap.data.SymbolFill;
import com.supermap.data.SymbolFillLibrary;
import com.supermap.data.SymbolGroup;
import com.supermap.data.SymbolGroups;
import com.supermap.data.SymbolLibrary;
import com.supermap.data.SymbolLine;
import com.supermap.data.SymbolLineLibrary;
import com.supermap.data.SymbolMarkerLibrary;
import com.supermap.data.Workspace;
import com.supermap.data.WorkspaceConnectionInfo;
import com.supermap.data.WorkspaceType;
import com.supermap.data.WorkspaceVersion;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.data.DatasetType;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONStringer;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;


public class SMMapWC {
    Workspace workspace;
    MapControl mapControl;

    public Workspace getWorkspace() {
        return workspace;
    }

    public void setWorkspace(Workspace workspace) {
        this.workspace = workspace;
    }

    public MapControl getMapControl() {
        return mapControl;
    }

    public void setMapControl(MapControl mapControl) {
        this.mapControl = mapControl;
    }

    private final String encodingUTF8 = "UTF-8";

    public boolean openWorkspace(Map data) {
        try {
            boolean result = false;

//            Workspace _workspace = SMap.getInstance().getSmMapWC().getWorkspace();
//            if (_workspace != null && _workspace.getCaption().equals("UntitledWorkspace")) {
//                newWS = new Workspace();
//                SMap.getInstance().getSmMapWC().setWorkspace(newWS);
//            }
//            if (data != null && data.get("server") != null && !SMap.getInstance().getSmMapWC().getWorkspace().getConnectionInfo().getServer().equals(data.get("server"))) {
//                WorkspaceConnectionInfo info = setWorkspaceConnectionInfo(data, null);
//
//                result = SMap.getInstance().getSmMapWC().getWorkspace().open(info);
//                info.dispose();
////                SMap.getInstance().getSmMapWC().getMapControl().getMap().setWorkspace(SMap.getInstance().getSmMapWC().getWorkspace());
//            }
//
//            // 先设置在释放
//            if (_workspace != null && _workspace.getCaption().equals("UntitledWorkspace")) {
//                _workspace.dispose();
//                setWorkspace(newWS);
//            }

            if (data != null && data.get("server") != null) {
                Workspace _workspace = SMap.getInstance().getSmMapWC().getWorkspace();
                if (_workspace != null && !_workspace.getCaption().equals("UntitledWorkspace")) {
                    _workspace.close();
                }
                Workspace newWS = new Workspace();
                SMap.getInstance().getSmMapWC().setWorkspace(newWS);
                WorkspaceConnectionInfo info = setWorkspaceConnectionInfo(data, null);

                result = SMap.getInstance().getSmMapWC().getWorkspace().open(info);
                info.dispose();

                SMap.getInstance().getSmMapWC().getMapControl().getMap().setWorkspace(SMap.getInstance().getSmMapWC().getWorkspace());

                _workspace.dispose();
            }

            return result;
        } catch (Exception e) {
            throw e;
        }
    }

    public Datasource openDatasource(Map data) {
        try {
            DatasourceConnectionInfo info = new DatasourceConnectionInfo();
            Datasource ds = data.get("alias") != null ? SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().get((String) data.get("alias")) : null;
            Boolean isOpen = ds != null && data.get("server") != null && ds.getConnectionInfo().getServer().equals(data.get("server")) && ds.isOpened();
            Datasource dataSource = isOpen ? ds : null;
            if (!isOpen) {
                if (data.containsKey("alias")) {
                    String alias = data.get("alias").toString();
                    info.setAlias(alias);

//                    if (this.workspace.getDatasources().indexOf(alias) != -1) {
//                        dataSource = this.workspace.getDatasources().get(alias);
//                        info.dispose();
//
//                        return dataSource;
//                    }
                }
                if (data.containsKey("engineType")) {
                    Double type = Double.parseDouble(data.get("engineType").toString());
                    info.setEngineType((EngineType) Enum.parse(EngineType.class, type.intValue()));
                }
                if (data.containsKey("server")) {
                    info.setServer(data.get("server").toString());
                }


                if (data.containsKey("driver")) info.setDriver(data.get("driver").toString());
                if (data.containsKey("user")) info.setUser(data.get("user").toString());
                if (data.containsKey("readOnly"))
                    info.setReadOnly(Boolean.parseBoolean(data.get("readOnly").toString()));
                if (data.containsKey("password")) info.setPassword(data.get("password").toString());
                if (data.containsKey("webCoordinate"))
                    info.setWebCoordinate(data.get("webCoordinate").toString());
                if (data.containsKey("webVersion"))
                    info.setWebVersion(data.get("webVersion").toString());
                if (data.containsKey("webFormat"))
                    info.setWebFormat(data.get("webFormat").toString());
                if (data.containsKey("webVisibleLayers"))
                    info.setWebVisibleLayers(data.get("webVisibleLayers").toString());
                if (data.containsKey("webExtendParam"))
                    info.setWebExtendParam(data.get("webExtendParam").toString());

                dataSource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().open(info);
                info.dispose();
            }

            return dataSource;
        } catch (Exception e) {
            throw e;
        }
    }

    public Dataset addDatasetByName(String name, int datasetType, String datasourceName, String datasourcePath) {
        try {
            String dsName = name;
            if (dsName.equals("")) {
                switch (datasetType) {
                    case 1: // POINT
                        dsName = "COL_POINT";
                        break;
                    case 3: // LINE
                        dsName = "COL_LINE";
                        break;
                    case 5: // REGION
                        dsName = "COL_REGION";
                        break;
                    default:
                        dsName = "COL_POINT";
                        break;
                }
            }

            Datasource datasource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().get(datasourceName);
            if (datasource == null || datasource.isReadOnly()) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias(datasourceName);
                info.setEngineType(EngineType.UDB);
                FileUtil.createDirectory(datasourcePath);
                info.setServer(datasourcePath + "/" + datasourceName + ".udb");

                datasource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().create(info);
                if (datasource == null) {
                    datasource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().open(info);
                }
            }

            Datasets datasets = datasource.getDatasets();
            Dataset dataset = datasets.get(dsName);

            if (dataset == null) {
                String dsAvailableName = datasets.getAvailableDatasetName(dsName);
                DatasetVectorInfo info = new DatasetVectorInfo(dsAvailableName, (DatasetType) Enum.parse(DatasetType.class, datasetType));
                dataset = datasets.create(info);
            }

            return dataset;
        } catch (Exception e) {
            throw e;
        }
    }

    public boolean saveWorkspace() {
        try {
            if (SMap.getInstance().getSmMapWC().getWorkspace() == null) return false;
            boolean saved = SMap.getInstance().getSmMapWC().getWorkspace().save();
            return saved;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean saveWorkspaceWithInfo(Map data) {
        try {
            if (SMap.getInstance().getSmMapWC().getWorkspace() == null) return false;
            setWorkspaceConnectionInfo(data, SMap.getInstance().getSmMapWC().getWorkspace());
            boolean saved = SMap.getInstance().getSmMapWC().getWorkspace().save();
            return saved;
        } catch (Exception e) {
            return false;
        }
    }

    public WorkspaceConnectionInfo setWorkspaceConnectionInfo(Map data, Workspace workspace) {
        WorkspaceConnectionInfo info;
        if (workspace != null) {
            info = workspace.getConnectionInfo();
        } else {
            info = new WorkspaceConnectionInfo();
        }
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
        return info;
    }

    ////////////////////

    private String formateNoneExistDatasourceAlian(String alian, Workspace workspaceTemp) {
        if (workspaceTemp == null) {
            return alian;
        }
        String resultAlian = alian;
        int nAddNumber = 1;
        while (workspaceTemp.getDatasources().indexOf(resultAlian) != -1) {
            resultAlian = alian + "#" + nAddNumber;
            nAddNumber++;
        }
        return resultAlian;
    }

    private String formateNoneExistMapName(String name) {
        String resultName = name;
        int nAddNumber = 1;
        while (workspace.getMaps().indexOf(resultName) != -1) {
            resultName = name + "#" + nAddNumber;
            nAddNumber++;
        }
        return resultName;
    }

    // arrAlian中值不重复
    // arrNewAlian中值不重复
    // arrAlian与arrNewAlian对应位不等
    private String modifyXML(String strXML, List<String> arrAlian, List<String> arrNewAlian) {

        Set<String> setAlian = new HashSet<>();
        setAlian.addAll(arrAlian);
        if (setAlian.size() != arrAlian.size()) {
            Log.e("error:", "XML modify with redefined srcString!!");
        }
        Set setNewAlian = new HashSet();
        setNewAlian.addAll(arrNewAlian);
        if (setNewAlian.size() != arrNewAlian.size()) {
            Log.e("error:", "XML modify with redefined desString!!");
        }

        int nCount = arrAlian.size();
        int[] pRespace = new int[nCount];

        for (int i = 0; i < nCount; i++) {
            pRespace[i] = arrAlian.indexOf(arrNewAlian.get(i));
            if (pRespace[i] < 0 || pRespace[i] >= nCount) {
                pRespace[i] = -1;  //源外的
            }
        }

        // -2处理过 -1不在源内 i为所指list

        List<List<String>> arrLists = new ArrayList<>();
        for (int i = 0; i < nCount; i++) {
            int nIndex = pRespace[i];
            if (nIndex == -2) {
                //已经处理过 在list中
                continue;
            } else {

                List<String> arrTemp = new ArrayList<>();
                arrTemp.add(arrAlian.get(i));//list头
                int nPreIndex = i;
                while (nIndex > i) {

                    arrTemp.add(arrAlian.get(nIndex));//加到list中
                    nPreIndex = nIndex;
                    nIndex = pRespace[nPreIndex];
                    pRespace[nPreIndex] = -2;//标记处理过了

                }
                if (nIndex == i || nIndex == -1) {
                    //循环 || 源外的

                    int nListIndex = arrLists.size();
                    arrTemp.add(arrNewAlian.get(nPreIndex));
                    arrLists.add(arrTemp);
                    pRespace[i] = nListIndex;


                } else if (nIndex >= 0) {

                    //添加到其他表头
                    int nListIndex = pRespace[nIndex];

                    List<String> arrListTemp = arrLists.get(nListIndex);
                    arrTemp.addAll(arrListTemp);
                    arrLists.set(nListIndex, arrTemp);
                    pRespace[nIndex] = -2;
                    pRespace[i] = nListIndex;


                } else {
                    //error
                }

            }

        }


        String strResult = strXML;
        for (int i = 0; i < arrLists.size(); i++) {
            List<String> arrListTemp = arrLists.get(i);
            if (arrListTemp.get(0).equals(arrListTemp.get(arrListTemp.size() - 1))) {
                int ntemp = 1;
                String strTail = arrListTemp.get(arrListTemp.size() - 1);
                String strTmp = strTail + "#" + ntemp;
                while (strResult.contains("<sml:DataSourceAlias>" + strTmp + "</sml:DataSourceAlias>") || arrNewAlian.contains(strTmp)) {
                    ntemp++;
                    strTmp = strTail + "#" + ntemp;
                }
                arrListTemp.set(arrListTemp.size() - 1, strTmp);
                strResult = modifyXML(strResult, arrListTemp);

                List<String> arrStrTemp_Tail = new ArrayList<>(Arrays.asList(strTmp, strTail));
                strResult = modifyXML(strResult, arrStrTemp_Tail);
            } else {
                strResult = modifyXML(strResult, arrListTemp);
            }

        }

        return strResult;
    }

    private String modifyXML(String strXML, List<String> arrString) {
        String strResult = strXML;
        int nIndex = arrString.size() - 1;
        while (nIndex > 0) {
            String strSrc = "<sml:DataSourceAlias>" + arrString.get(nIndex - 1) + "</sml:DataSourceAlias>";
            String strReplace = "<sml:DataSourceAlias>" + arrString.get(nIndex) + "</sml:DataSourceAlias>";
            strResult = strResult.replace(strSrc, strReplace);
            nIndex--;
        }
        return strResult;
    }


    //导入工作空间
//  失败情况：
//      a)info为空或sever为空或type为空 或导入工作空间为SMap.singletonInstance.smMapWC.workspace
//      b)打开工作空间失败
//      c)SMap.singletonInstance.smMapWC.workspace没初始化
//  流程：
//      1.新的工作空间打开
//      2.导入数据源
//          -文件型数据源需拷贝数据源到目录下,重名要改名
//          -打开数据源，alias相同需改名
//      3.导入点线面符号库（若是SMWX可直接读取文件，其他类型需要先导出符号库文件再读入）
//      4.导入maps，先导出成XML在倒入，3中alian变化的数据源需修改导出XML对应字段
//  非替换模式：重复文件名+num
//  替换模式：重复文件替换，同路径先关闭工作空间再替换
    public boolean importWorkspaceInfo(Map infoMap, String strDirPath, boolean bDatasourceRep, boolean bSymbolsRep) {
        boolean bSucc = false;
        Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();

        if (!(workspace != null && infoMap != null && infoMap.containsKey("server") && infoMap.containsKey("type") &&
                !workspace.getConnectionInfo().getServer().equals(infoMap.get("server")))) {
            return bSucc;
        }
        Workspace importWorkspace = new Workspace();
        WorkspaceConnectionInfo info = setWorkspaceConnectionInfo(infoMap, null);

        if (!importWorkspace.open(info)) {
            info.dispose();
            importWorkspace.dispose();
            return bSucc;
        }
        String importPath = info.getServer();

        int nSuffixCount = 0;
        if (info.getType() == WorkspaceType.SXWU || info.getType() == WorkspaceType.SMWU) {
            nSuffixCount = 5;
        } else {
            nSuffixCount = 4;
        }

        String strTargetDir = strDirPath;
        if (strDirPath == null || strDirPath.length() == 0) {
            //若未指定存放目录需构造默认目录
            String currentPath = workspace.getConnectionInfo().getServer();
            String[] arrCurrentPathStr = currentPath.split("/");
            String strCurrentNameStr = arrCurrentPathStr[arrCurrentPathStr.length - 1];
            strTargetDir = currentPath.substring(0, currentPath.length() - strCurrentNameStr.length() - 1);
            String[] arrSrePathStr = importPath.split("/");
            String[] arrSrcWorkspaceName = arrSrePathStr[arrSrePathStr.length - 1].split("\\.");
            //目标文件+importWorkspaceName
            strTargetDir = strTargetDir + "/" + arrSrcWorkspaceName[0];
        }
        boolean bDirReady = true;
        boolean bNewDir = false;
        boolean bDir = false;
        boolean bExist = false;
        File file = new File(strTargetDir);
        bExist = file.exists();
        bDir = file.isDirectory();
        if (!bExist || !bDir) {
            bDirReady = file.mkdirs();
            bNewDir = true;
        }
        if (!bDirReady) {
            return bSucc;
        }

        // 重复的server处理
        //      1.文件型数据源：若bDatasourceRep，关闭原来数据源，拷贝新数据源并重新打开（alian保持原来的）
        //      2.网络型数据源：不再重复打开（alian保持原来的）
        List<String> arrTargetServers = new ArrayList<>();
        List<String> arrTargetAlians = new ArrayList<>();
        Datasources datasources = workspace.getDatasources();
        for (int i = 0; i < datasources.getCount(); i++) {
            Datasource datasource = datasources.get(i);
            DatasourceConnectionInfo datasourceInfo = datasource.getConnectionInfo();
            if (datasourceInfo.getEngineType() == EngineType.UDB || datasourceInfo.getEngineType() == EngineType.IMAGEPLUGINS) {
                //只要名字
                if (bDatasourceRep) {
                    String fullName = datasourceInfo.getServer();
                    String[] arrServer = fullName.split("/");
                    String lastName = arrServer[arrServer.length - 1];
                    String fatherName = fullName.substring(0, fullName.length() - lastName.length() - 1);
                    if (fatherName.equals(strTargetDir)) {
                        //同级目录下的才会被替换
                        arrTargetServers.add(lastName);
                        arrTargetAlians.add(datasourceInfo.getAlias());
                    }
                }
            } else {
                //网络数据集用完整url
                arrTargetServers.add(datasourceInfo.getServer());
                arrTargetAlians.add(datasourceInfo.getAlias());
            }
        }

        //数据源
        Datasources datasourcesTemp = importWorkspace.getDatasources();
        //更名数组
        List<String> arrAlian = new ArrayList<>();
        List<String> arrReAlian = new ArrayList<>();
        for (int i = 0; i < datasourcesTemp.getCount(); i++) {
            Datasource dTemp = datasourcesTemp.get(i);
            if (!dTemp.isOpened()) {
                //没打开就跳过
                continue;
            }
            DatasourceConnectionInfo infoTemp = dTemp.getConnectionInfo();
            String strSrcServer = infoTemp.getServer();
            EngineType engineType = infoTemp.getEngineType();
            String strSrcAlian = infoTemp.getAlias();
            String strSrcUser = infoTemp.getUser();
            String strSrcPassword = infoTemp.getPassword();
            String strTargetAlian = strSrcAlian;

            if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {

                boolean isUDB = engineType == EngineType.UDB;
                // 源文件存在？
                if (!isDatasourceFileExist(strSrcServer, isUDB))
                    continue;

                String[] arrSrcServer = strSrcServer.split("/");
                String strFileName = arrSrcServer[arrSrcServer.length - 1];
                // 导入工作空间名／数据源名字
                String strTargetServer = strTargetDir + "/" + strFileName;

                if (engineType == EngineType.UDB) {

                    String strSrcDatasourcePath = strSrcServer.substring(0, strSrcServer.length() - 4);
                    String strTargetDatasourcePath = strTargetServer.substring(0, strTargetServer.length() - 4);
                    if (!bNewDir) {
                        // 检查重复性
                        bDir = true;
                        File file1 = new File(strTargetServer);
                        bExist = file1.exists();
                        bDir = file1.isDirectory();
                        if (bExist && !bDir) {
                            //存在同名文件
                            if (bDatasourceRep) {
                                //覆盖模式
                                int nIndex = arrTargetServers.indexOf(strFileName);
                                if (nIndex >= 0 && nIndex < arrTargetServers.size()) {
                                    // 替换alian 保证原来map有数据源
                                    strTargetAlian = arrTargetAlians.get(nIndex);
                                    workspace.getDatasources().close(strTargetAlian);
                                    //删文件
                                    File file2 = new File(strTargetDatasourcePath + ".udb");
                                    if (!file2.delete()) {
                                        continue;
                                    }
                                    File file3 = new File(strTargetDatasourcePath + ".udd");
                                    if (!file3.delete()) {
                                        continue;
                                    }

                                } else {
                                    //_worspace外的 直接删
                                    new File(strTargetDatasourcePath + ".udb").delete();
                                    new File(strTargetDatasourcePath + ".udd").delete();
                                }
                            } else {
                                //重名文件
                                strTargetServer = formateNoneExistFileName(strTargetServer, false);
                                strTargetDatasourcePath = strTargetServer.substring(0, strTargetServer.length() - 4);
                            }//rep
                        }//exist
                    }//!New
                    if (!copyFile(strSrcDatasourcePath + ".udb", strTargetDatasourcePath + ".udb")) {
                        continue;
                    }
                    if (!copyFile(strSrcDatasourcePath + ".udd", strTargetDatasourcePath + ".udd")) {
                        continue;
                    }
                } else {
                    if (!bNewDir) {
                        //检查重复性
                        bDir = true;
                        File file1 = new File(strTargetServer);
                        bExist = file1.exists();
                        bDir = file1.isDirectory();
                        if (bExist && !bDir) {
                            //存在同名文件
                            if (bDatasourceRep) {
                                //覆盖模式
                                int nIndex = arrTargetServers.indexOf(strFileName);
                                if (nIndex >= 0 && nIndex < arrTargetServers.size()) {
                                    // 替换alian 保证原来map有数据源
                                    strTargetAlian = arrTargetAlians.get(nIndex);
                                    workspace.getDatasources().close(strTargetAlian);
                                    //删文件
                                    if (!new File(strTargetServer).delete()) {
                                        continue;
                                    }
                                } else {
                                    //_worspace外的 直接删
                                    new File(strTargetServer).delete();
                                }
                            } else {
                                //重名文件
                                strTargetServer = formateNoneExistFileName(strTargetServer, false);
                            }//rep
                        }//exist
                    }//new

                    //拷贝
                    if (!copyFile(strSrcServer, strTargetServer)) {
                        continue;
                    }
                }//bUDB
                //打开
                DatasourceConnectionInfo temp = new DatasourceConnectionInfo();
                temp.setServer(strTargetServer);
                // 更名
                strTargetAlian = formateNoneExistDatasourceAlian(strTargetAlian, workspace);
                temp.setAlias(strTargetAlian);
                temp.setUser(strSrcUser);
                if (strSrcPassword != null && !strSrcPassword.equals("")) {
                    temp.setPassword(strSrcPassword);
                }
                temp.setEngineType(engineType);
                if (workspace.getDatasources().open(temp) == null) {
                    if (!strTargetAlian.equals(strSrcAlian)) {
                        arrAlian.add(strSrcAlian);
                        arrReAlian.add(strTargetAlian);
                    }
                }
            } else {
                //url需要区分大小写吗？
                int nIndex = arrTargetServers.indexOf(strSrcServer);
                if (nIndex >= 0 && nIndex < arrTargetServers.size()) {
                    // 替换alian 保证原来map有数据源
                    strTargetAlian = arrTargetAlians.get(nIndex);
                    if (!strTargetAlian.equals(strSrcAlian)) {
                        arrAlian.add(strSrcAlian);
                        arrReAlian.add(strTargetAlian);
                    }
                } else {
                    strTargetAlian = formateNoneExistDatasourceAlian(strTargetAlian, workspace);
                    // web数据源
                    DatasourceConnectionInfo temp = new DatasourceConnectionInfo();
                    temp.setServer(strSrcServer);
                    temp.setAlias(strTargetAlian);
                    temp.setUser(strSrcUser);
                    if (strSrcPassword != null && !strSrcPassword.equals("")) {
                        temp.setPassword(strSrcPassword);
                    }
                    temp.setDriver(infoTemp.getDriver());
                    temp.setEngineType(infoTemp.getEngineType());

                    if (workspace.getDatasources().open(temp) != null) {
                        if (!strTargetAlian.equals(strSrcAlian)) {
                            arrAlian.add(strSrcAlian);
                            arrReAlian.add(strTargetAlian);
                        }
                    }
                }

            }// if udb

        }//for datasources

        //符号库

        String serverResourceBase = importPath.substring(0, importPath.length() - nSuffixCount);
        String strMarkerPath = serverResourceBase + ".sym";
        String strLinePath = serverResourceBase + ".lsl";
        String strFillPath = serverResourceBase + ".bru";
        if (info.getType() != WorkspaceType.SXWU) {
            //导出
            importWorkspace.getResources().getMarkerLibrary().saveAs(strMarkerPath);
            importWorkspace.getResources().getLineLibrary().saveAs(strLinePath);
            importWorkspace.getResources().getFillLibrary().saveAs(strFillPath);
        }
        workspace.getResources().getMarkerLibrary().appendFromFile(strMarkerPath, bSymbolsRep);
        workspace.getResources().getLineLibrary().appendFromFile(strLinePath, bSymbolsRep);
        workspace.getResources().getFillLibrary().appendFromFile(strFillPath, bSymbolsRep);
        if (info.getType() != WorkspaceType.SXWU) {
            new File(strMarkerPath).delete();
            new File(strLinePath).delete();
            new File(strFillPath).delete();
        }

        com.supermap.mapping.Map mapTemp = new com.supermap.mapping.Map(importWorkspace);
        // map
        for (int i = 0; i < importWorkspace.getMaps().getCount(); i++) {

            mapTemp.open(importWorkspace.getMaps().get(i));
            mapTemp.setDescription("Template" + mapTemp.getName());
            String strSrcMapXML = mapTemp.toXML();
            String strMapName = formateNoneExistMapName(mapTemp.getName());
            mapTemp.close();

            // 替换XML字段
            String strTargetMapXML = modifyXML(strSrcMapXML, arrAlian, arrReAlian);
            workspace.getMaps().add(strMapName, strTargetMapXML);
        }

        importWorkspace.close();
        bSucc = true;


        info.dispose();
        importWorkspace.dispose();
        return bSucc;
    }


    //导出工作空间
    //  失败情况：
    //      a)工作空间未打开
    //      b)导出文件名错误
    //      c)非强制覆盖模式有同名sxm文件
    //  流程：
    //      1.新的工作空间目录，导出文件名可用？
    //      2.新建workspace
    //      3.导出列表中map，加到workspace.maps中
    //      4.遍历datasource，拷贝其中文件数据源（注意覆盖模式），workspace打开数据源
    //      5.导出符号库，workspace打开符号库
    //      5.设置workspaceConnectionInfo，保存workspace

    public boolean exportMapNames(ReadableArray arrMapNames, String strFileName, boolean isFileReplace) {
        Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
        if (SMap.getInstance().getSmMapWC().getWorkspace() == null || strFileName == null || strFileName.length() == 0 || arrMapNames == null || arrMapNames.size() == 0 ||
                workspace.getConnectionInfo().getServer().equalsIgnoreCase(strFileName)) {
            return false;
        }

        WorkspaceType workspaceType = WorkspaceType.DEFAULT;
        String strWorkspaceSuffix;
        if (strFileName.endsWith("sxw")) {
            workspaceType = WorkspaceType.DEFAULT;
            strWorkspaceSuffix = "sxw";
        } else if (strFileName.endsWith("smw")) {
            workspaceType = WorkspaceType.SMW;
            strWorkspaceSuffix = "smw";
        } else if (strFileName.endsWith("sxwu")) {
            workspaceType = WorkspaceType.SXWU;
            strWorkspaceSuffix = "sxwu";
        } else if (strFileName.endsWith("smwu")) {
            workspaceType = WorkspaceType.SMWU;
            strWorkspaceSuffix = "smwu";
        } else {
            return false;
        }

        //建目录
        //String[] desFileNames = strFileName.split("/");
        //String desWorkspaceName = desFileNames[desFileNames.length-1];
        String desWorkspaceName = strFileName.substring(strFileName.lastIndexOf("/") + 1);
        String desDir = strFileName.substring(0, strFileName.length() - desWorkspaceName.length());
        boolean bNewDir = false;
        //WritableArray arrProtectedFile = Arguments.createArray();
        ArrayList<String> arrProtectedFileNames = new ArrayList<String>();

        File desDirFile = new File(desDir);
        if (desDirFile.exists() && desDirFile.isDirectory()) {
            if (isFileReplace) {
                Datasources srcDatasources = workspace.getDatasources();
                for (int i = 0; i < srcDatasources.getCount(); i++) {
                    Datasource srcdatasource = srcDatasources.get(i);
                    DatasourceConnectionInfo datasourceInfo = srcdatasource.getConnectionInfo();
                    if (datasourceInfo.getEngineType() == EngineType.UDB
                            || datasourceInfo.getEngineType() == EngineType.IMAGEPLUGINS) {

                        //只要名字
                        String fullName = datasourceInfo.getServer();
                        String fatherDirName = fullName.substring(0, fullName.lastIndexOf("/"));

                        if (fatherDirName.equalsIgnoreCase(desDir)) {
                            //同级目录下的才会被替换
                            //arrProtectedFile.pushString(fullName);
                            arrProtectedFileNames.add(fullName);
                        }
                    }
                }
            }

            bNewDir = false;
        } else {
            if (!desDirFile.mkdirs()) {
                return false;
            }
            bNewDir = true;
        }

        //文件名
        File desWorkspaceFile = new File(strFileName);
        if (desWorkspaceFile.exists() && desWorkspaceFile.isFile()) {
            if (isFileReplace) {
                desWorkspaceFile.delete();
            } else {
                strFileName = formateNoneExistFileName(strFileName, false);
            }
        }

        Workspace workspaceDes = new Workspace();
        com.supermap.mapping.Map mapExport = new com.supermap.mapping.Map();
        mapExport.setWorkspace(workspace);

        ArrayList<Datasource> arrDatasources = new ArrayList<Datasource>();

        for (int i = 0; i < arrMapNames.size(); i++) {
            String mapName = arrMapNames.getString(i);
            if (workspace.getMaps().indexOf(mapName) != -1) {
                // 打开map
                mapExport.open(mapName);
                // 不重复的datasource保存
                Layers exportLayes = mapExport.getLayers();
                for (int j = 0; j < exportLayes.getCount(); j++) {
                    Datasource datasource = exportLayes.get(j).getDataset().getDatasource();
                    if (!arrDatasources.contains(datasource)) {
                        arrDatasources.add(datasource);
                    }
                }
                String strMapXML = mapExport.toXML();
                workspaceDes.getMaps().add(mapName, strMapXML);

                mapExport.close();
            }
        }


        // 导出datasource
        for (int i = 0; i < arrDatasources.size(); i++) {
            Datasource datasource = arrDatasources.get(i);
            // 文件拷贝
            DatasourceConnectionInfo srcInfo = datasource.getConnectionInfo();
            String strSrcServer = srcInfo.getServer();
            EngineType engineType = srcInfo.getEngineType();
            String strTargetServer = new String(strSrcServer);

            if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {
                if (!isDatasourceFileExist(strSrcServer, engineType == EngineType.UDB)) {
                    continue;
                }

                String strlastname = strSrcServer.substring(strSrcServer.lastIndexOf("/") + 1);
                // 导入工作空间名
                strTargetServer = desDir + strlastname;

                if (engineType == EngineType.UDB) {

                    String strSrcBase = strSrcServer.substring(0, strSrcServer.length() - 4);
                    String strTargetBase = strTargetServer.substring(0, strTargetServer.length() - 4);
                    if (!bNewDir) {
                        // 检查重复
                        if (arrProtectedFileNames.contains(strTargetServer)) {
                            continue;
                        }
                        boolean bExist = false;
                        File targetFileUDB = new File(strTargetBase + ".udb");
                        File targetFileUDD = new File(strTargetBase + ".udd");
                        if (targetFileUDB.exists() && targetFileUDB.isFile()) {
                            bExist = true;
                        } else {
                            if (targetFileUDD.exists() && targetFileUDD.isFile()) {
                                bExist = true;
                            }
                        }
                        //存在同名文件
                        if (bExist) {
                            if (isFileReplace) {
                                //覆盖模式
                                targetFileUDB.delete();
                                targetFileUDD.delete();
                            } else {
                                //重名文件
                                strTargetServer = formateNoneExistFileName(strTargetServer, false);
                                strTargetBase = strTargetServer.substring(0, strTargetServer.length() - 4);
                            }//rep
                        }


                    }//!New

                    // 拷贝
                    if (!copyFile(strSrcBase + ".udb", strTargetBase + ".udb")) {
                        continue;
                    }
                    if (!copyFile(strSrcBase + ".udd", strTargetBase + ".udd")) {
                        continue;
                    }

                } else {

                    if (!bNewDir) {
                        // 检查重复
                        if (arrProtectedFileNames.contains(strTargetServer)) {
                            continue;
                        }
                        File targetFile = new File(strTargetServer);
                        if (targetFile.exists() && targetFile.isFile()) {
                            //存在同名文件
                            if (isFileReplace) {
                                //覆盖模式
                                targetFile.delete();
                            } else {
                                //重名文件
                                strTargetServer = formateNoneExistFileName(strTargetServer, false);
                            }//rep
                        }

                    }//!New

                    // 拷贝
                    if (!copyFile(strSrcServer, strTargetServer)) {
                        continue;
                    }

                }//udb

            }

            DatasourceConnectionInfo desInfo = new DatasourceConnectionInfo();
            desInfo.setServer(strTargetServer);
            desInfo.setDriver(srcInfo.getDriver());
            desInfo.setAlias(srcInfo.getAlias());
            desInfo.setEngineType(engineType);
            desInfo.setUser(srcInfo.getUser());
            desInfo.setPassword(srcInfo.getPassword());

            workspaceDes.getDatasources().open(desInfo);


        }

        // symbol lib
        String serverResourceBase = strFileName.substring(0, strFileName.lastIndexOf("."));
        String strMarkerPath = serverResourceBase + ".sym";
        String strLinePath = serverResourceBase + ".lsl";
        String strFillPath = serverResourceBase + ".bru";
        if (workspaceType != WorkspaceType.SXWU) {
            //重命名
            strMarkerPath = formateNoneExistFileName(strMarkerPath, false);
            strLinePath = formateNoneExistFileName(strLinePath, false);
            strFillPath = formateNoneExistFileName(strFillPath, false);
        }

        workspace.getResources().getMarkerLibrary().saveAs(strMarkerPath);
        workspace.getResources().getLineLibrary().saveAs(strLinePath);
        workspace.getResources().getFillLibrary().saveAs(strFillPath);

        workspaceDes.getResources().getMarkerLibrary().appendFromFile(strMarkerPath, true);
        workspaceDes.getResources().getLineLibrary().appendFromFile(strLinePath, true);
        workspaceDes.getResources().getFillLibrary().appendFromFile(strFillPath, true);

        if (workspaceType != WorkspaceType.SXWU) {
            File fileMarker = new File(strMarkerPath);
            fileMarker.delete();
            File fileLine = new File(strLinePath);
            fileLine.delete();
            File fileFill = new File(strFillPath);
            fileFill.delete();
        }

        // fileName查重
        //WorkspaceConnectionInfo *workspaceInfo = [[WorkspaceConnectionInfo alloc]initWithFile:fileName];
        workspaceDes.getConnectionInfo().setType(workspaceType);
        workspaceDes.getConnectionInfo().setServer(strFileName);
        try {
            workspaceDes.save();
        } catch (Exception e) {
        }

        workspaceDes.close();

        return true;

    }

    private List<Integer> findIntValuesFromXML(String strXml, String strTag) {
        List<Integer> arrValues = new ArrayList<>();
        String strTagHead = "<" + strTag + ">";
        String strTagTail = "</" + strTag + ">";
        String[] arrStrXML = strXml.split(strTagHead);
        for (int i = 1; i < arrStrXML.length; i++) {
            String strTemp = arrStrXML[i];
            String strValue = strTemp.split(strTagTail)[0];
            int nValue = Integer.parseInt(strValue);
            arrValues.add(nValue);
        }
        return arrValues;
    }

    //从srcGroup导入Symbol到desGroup
//bDirRetain 保留srcGroup的目录结构，否则所有的Symbol都放在desGroup而不是其子group中
//bSymReplace 相同id的处理：true替换 false新id


    private void importSymbolsFrom(SymbolGroup srcGroup, SymbolGroup desGroup, boolean bDirRetain, boolean bSymReplace) {
        if (desGroup == null || desGroup.getLibrary() == null) {
            //deGroup必须是必须在Lib中
            return;
        }
        // group的名称 symbol的id 都需要desLib查重名
        SymbolLibrary desLib = desGroup.getLibrary();
        if (srcGroup == null){
            return;
        }
        for (int i = 0; i < srcGroup.getCount(); i++) {
            Symbol sym = srcGroup.get(i);
            if (bSymReplace && desLib.contains(sym.getID())) {
                desLib.remove(sym.getID());
            }
            desLib.add(sym, desGroup);
        }

        SymbolGroup desSubGroup = desGroup;
        SymbolGroups srcChildGroups = srcGroup.getChildGroups();
        if (srcChildGroups == null){
            return;
        }
        for (int j = 0; j < srcChildGroups.getCount(); j++) {
            SymbolGroup subGroup = srcChildGroups.get(j);

            if (bDirRetain) {
                String subName = subGroup.getName();
                int nAddNum = 1;
                while (desLib.getRootGroup().getChildGroups().contains(subName)) {
                    subName = subGroup.getName() + "#" + nAddNum;
                    nAddNum++;
                }
                desSubGroup = desGroup.getChildGroups().create(subName);
            }
            importSymbolsFrom(subGroup, desSubGroup, bDirRetain, bSymReplace);
        }

        return;
    }

//    private String getCustomerDirectory(boolean bPrivate) {
//        if(bPrivate) {
//            String strServer = SMap.getInstance().getSmMapWC().getWorkspace().getConnectionInfo().getServer();
//            String[] arrServer = strServer.split("/");
//            int endIndex = strServer.length() - arrServer[arrServer.length - 1].length() - 1;
//            String strRootFolder = strServer.substring(0, endIndex);
//            return strRootFolder;
//        }else {
//            String rootPath=android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
//            return rootPath+"/iTablet/User/Customer/Data";
//        }
//    }

    private String getRootPath() {
        String rootPath = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
        return rootPath + "/iTablet/User";
    }

    private String getUserName() {
        String strServer = SMap.getInstance().getSmMapWC().getWorkspace().getConnectionInfo().getServer();
        String[] arrServer = strServer.split("/");
        int nCount = arrServer.length;
        if (nCount >= 3) {
            return arrServer[nCount - 3];
        } else {
            return null;
        }
    }

    private String getModuleDirectory(int nModule) {

        switch (nModule) {
            case 0:  /*模块0*/
                return "模块0";
            case 1:  /*模块1*/
                return "模块1";
            default:
                return null;
        }
    }

    private List<Dataset> allDatasetsOfLayerGroup(LayerGroup layerGroup) {
        List<Dataset> arrRes = new ArrayList<Dataset>();
        for (int i = 0; i < layerGroup.getCount(); i++) {
            Layer layerTemp = layerGroup.get(i);
            if (layerTemp.getDataset() == null) {

                if (LayerGroup.class.isInstance(layerTemp)) {

                    List<Dataset> arrTemp = allDatasetsOfLayerGroup((LayerGroup) layerTemp);
                    arrRes.addAll(arrTemp);
                }

            } else {
                arrRes.add(layerTemp.getDataset());
            }

        }
        return arrRes;
    }

    // 导入文件工作空间到程序目录
//      拆分文件工作空间成为多个map.xml及其资源文件到程序相应目录
// 目录结构：
//      Customer:
//          \------->Map:           旗下包含模块子文件夹，存放map.xml和map.exp文件
//          \------->Datasource:    旗下包含模块子文件夹，存放文件数据源文件
//          \------->Resource:      旗下包含模块子文件夹，存放符号库文件（.sym/.lsl./bru）
// 返回结果：NSArray为导入成功的所有地图名
//    public boolean importWorkspaceInfo(Map infoMap, String strModule) {
    public List<String> importWorkspaceInfo(Map infoMap, String strModule) {

        List<String> arrResult = null;
        if (infoMap == null || infoMap.get("server") == null || infoMap.get("type") == null || workspace.getConnectionInfo().getServer().equals(infoMap.get("server"))) {
            return null;
        }
        Workspace importWorkspace = new Workspace();
        WorkspaceConnectionInfo info = setWorkspaceConnectionInfo(infoMap, null);

        if (!importWorkspace.open(info)) {
            importWorkspace.close();
            importWorkspace.dispose();
            return null;
        }

        String strUserName = getUserName();
        if (strUserName == null) {
            return arrResult;
        }
        String strRootPath = getRootPath();
        String strCustomer = strRootPath + "/" + strUserName + "/Data";

        Map<String, String> dicAddition = new HashMap<>();

        //模版
//        if (strModule.equals("Collection")/*采集模块*/) {
        String strServer = (String) infoMap.get("server");
        String[] arrServer = strServer.split("/");
        int endIndex = strServer.length() - arrServer[arrServer.length - 1].length() - 1;
        String strRootDir = strServer.substring(0, endIndex);

        List<String> arrSubs = contentsOfDirectoryAtPath(strRootDir);
        for (int i = 0; i < arrSubs.size(); i++) {
            String strSub = arrSubs.get(i);
            if (strSub.endsWith(".xml")) {
                String strSrcTemplate = strRootDir + "/" + strSub;
                String strDesTemplate = strCustomer + "/Template/" + strSub;
                strDesTemplate = formateNoneExistFileName(strDesTemplate, false);
                //String[] arrDesTemplate = strDesTemplate.split("/");
                //String strNewSub = arrDesTemplate[arrDesTemplate.length - 1];
                String strNewSub = strDesTemplate.substring(strRootPath.length() + 1);

                copyFile(strSrcTemplate, strDesTemplate);
                dicAddition.put("Template", strNewSub);

                break;
            }
        }
//        }

        List<String> arrTemp = new ArrayList<>();
        for (int i = 0; i < importWorkspace.getMaps().getCount(); i++) {
            String strMapName = importWorkspace.getMaps().get(i);
            String strResName = saveMapName(strMapName, importWorkspace, strModule, dicAddition, true, false);
            if (strResName != null) {
                arrTemp.add(strResName);
            }
        }

        if (arrTemp.size() > 0) {
            arrResult = arrTemp;
        }

        importWorkspace.close();
        importWorkspace.dispose();

        return arrResult;

    }

    //
// 导出工作空间中地图到模块
// 参数：
//      strMapAlians: 导出的地图别名（一般即为保存文件名）
//      srcWorkspace: 内存工作空间
//      nModule: 模块id，对应模块名
//      bNew: 是否是外部导入程序的地图；是，则需要检查.xml和.exp命名避免覆盖,另外需要文件数据源和符号库的拷贝；否，则直接替换.xml和.exp
//      bResourcesModified: 导出时是否考虑地图用到的符号库外的符号追加到符号库
// 条件：
//      1.srcWorkspace打开
//      2.srcWorkspace包含地图
//      3.模块存在
//
    public String saveMapName(String strMapAlians, Workspace srcWorkspace, String strModule, Map<String, String> dicAddition, boolean bNew, boolean bResourcesModified) {

        if (srcWorkspace == null || srcWorkspace.getMaps().indexOf(strMapAlians) == -1) {
            return null;
        }

//        String strCustomer = getCustomerDirectory(true);
//        String strModule = getModuleDirectory(nModule);
//        if (strModule == null) {
//            return null;
//        }
        String strUserName = getUserName();
        if (strUserName == null) {
            return null;
        }
        String strRootPath = getRootPath();
        String strCustomer = strRootPath + "/" + strUserName + "/Data";

        com.supermap.mapping.Map mapExport = new com.supermap.mapping.Map(srcWorkspace);
        if (!mapExport.open(strMapAlians)) {
            //打开失败
            return null;
        }

        String desDirMap = strCustomer + "/Map";
        if (strModule != null && !strModule.equals("")) {
            desDirMap = desDirMap + "/" + strModule;
        }
        boolean isDir = false;
        File fileDesDirMap = new File(desDirMap);
        boolean isExist = fileDesDirMap.exists();
        isDir = fileDesDirMap.isDirectory();
        if (!isExist || !isDir) {
            fileDesDirMap.mkdirs();
        }

        String strMapName = strMapAlians;
        // map文件
        String desPathMapXML = desDirMap + "/" + strMapName + ".xml";
        String desPathMapExp;
        if (!bNew) {
            // 删文件
            isDir = true;
            File file = new File(desPathMapXML);
            isExist = file.exists();
            isDir = file.isDirectory();
            if (isExist && !isDir) {
                file.delete();
            }
            desPathMapExp = desDirMap + "/" + strMapName + ".exp";
            File tempExpFile = new File(desPathMapExp);
            isExist = tempExpFile.exists();
            isDir = tempExpFile.isDirectory();
            if (isExist && !isDir) {
                tempExpFile.delete();
            }

        } else {
            // 改名
            desPathMapXML = formateNoneExistFileName(desPathMapXML, false);
            String[] arrDesPathMapXML = desPathMapXML.split("/");
            String desLastMap = arrDesPathMapXML[arrDesPathMapXML.length - 1];
            // map文件名确定后其他文件（符号库）不需要判断，直接覆盖
            strMapName = desLastMap.substring(0, desLastMap.length() - 4);
            desPathMapExp = desDirMap + "/" + strMapName + ".exp";
        }

        // map xml
        String strMapXML = mapExport.toXML();
        try {
            Writer outWriter = new OutputStreamWriter(new FileOutputStream(desPathMapXML, true), encodingUTF8);
            outWriter.write(strMapXML);
            outWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //bResourcesModified时存所有用到的符号id
        Set<Integer> setMarkerIDs = new HashSet<>();
        Set<Integer> setLineIDs = new HashSet<>();
        Set<Integer> setFillIDs = new HashSet<>();

        List<Dataset> arrDatasets = new ArrayList<>();
        for (int i = 0; i < mapExport.getLayers().getCount(); i++) {
            Layer layerTemp = mapExport.getLayers().get(i);
            if (layerTemp.getDataset() == null) {

                if (LayerGroup.class.isInstance(layerTemp)) {
                    List<Dataset> arrTemp = allDatasetsOfLayerGroup((LayerGroup) layerTemp);
                    arrDatasets.addAll(arrTemp);
                }

            } else {
                arrDatasets.add(layerTemp.getDataset());
            }
        }

        //    NSMutableArray *arrMarkerIDs = [[NSMutableArray alloc]init];
        //    NSMutableArray *arrLineIDs = [[NSMutableArray alloc]init];
        //    NSMutableArray *arrFillIDs = [[NSMutableArray alloc]init];
        // datasources
        List<Datasource> arrDatasources = new ArrayList<>();
        for (int i = 0; i < arrDatasets.size(); i++) {
            Dataset dataset = arrDatasets.get(i);
            Datasource datasource = dataset.getDatasource();
            if (!arrDatasources.contains(datasource)) {
                arrDatasources.add(datasource);
            }
            //处理newSymbol
            //cad
            if (bResourcesModified && dataset.getType() == DatasetType.CAD) {
                Recordset recordset = ((DatasetVector) dataset).getRecordset(false, CursorType.STATIC);
                recordset.moveFirst();
                while (recordset.isEOF()) {
                    Geometry geoTemp = recordset.getGeometry();
                    recordset.moveNext();
                    GeoStyle styleTemp = geoTemp.getStyle();
                    int nMarkerID = styleTemp.getMarkerSymbolID();
                    int nLineID = styleTemp.getLineSymbolID();
                    int nFillID = styleTemp.getFillSymbolID();
                    if (nMarkerID > 0) {
                        setMarkerIDs.add(nMarkerID);
                    }
                    if (nLineID > 0) {
                        setMarkerIDs.add(nLineID);
                    }
                    if (nFillID > 0) {
                        setFillIDs.add(nFillID);
                    }
                }
                recordset.close();
            }

        }

        String desDatasourceDir = strCustomer + "/Datasource";
        if (strModule != null && !strModule.equals("")) {
            desDatasourceDir = desDatasourceDir + "/" + strModule;
        }

        List<Map<String, String>> arrExpDatasources = new ArrayList<>();
        //[[NSFileManager defaultManager]createDirectoryAtPath:desDataDir withIntermediateDirectories:YES attributes:nil error:nil];
        // 导出datasource  datasource名=文件名
        for (int i = 0; i < arrDatasources.size(); i++) {
            Datasource datasource = arrDatasources.get(i);
            // 文件拷贝
            DatasourceConnectionInfo srcInfo = datasource.getConnectionInfo();
            String strSrcAlian = srcInfo.getAlias();
            String strSrcServer = srcInfo.getServer();
            EngineType engineType = srcInfo.getEngineType();
            String strTargetServer = strSrcServer;
            //---------》》》》》只有一部分new怎么办？
            if (bNew) {
                if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {

                    // 源文件存在？
                    if (!isDatasourceFileExist(strSrcServer, engineType == EngineType.UDB)) {
                        continue;
                    }

                    String[] arrSrcServer = strSrcServer.split("/");
                    String strFileName = arrSrcServer[arrSrcServer.length - 1];
                    // 导入工作空间名
                    strTargetServer = desDatasourceDir + "/" + strFileName;
                    if (engineType == EngineType.UDB) {

                        String strSrcDatasourcePath = strSrcServer.substring(0, strSrcServer.length() - 4);
                        String strTargetDatasourcePath = strTargetServer.substring(0, strTargetServer.length() - 4);
                        // 检查重复性
                        boolean bDir = true;
                        File targetServerFile = new File(strTargetServer);
                        boolean bExist = targetServerFile.exists();
                        bDir = targetServerFile.isDirectory();
                        if (bExist && !bDir) {
                            //存在同名文件
                            //重名文件
                            strTargetServer = formateNoneExistFileName(strTargetServer, false);
                            strTargetDatasourcePath = strTargetServer.substring(0, strTargetServer.length() - 4);
                        }//exist

                        // 拷贝udb
                        if (!copyFile(strSrcDatasourcePath + ".udb", strTargetDatasourcePath + ".udb")) {
                            continue;
                        }
                        // 拷贝udd
                        if (!copyFile(strSrcDatasourcePath + ".udd", strTargetDatasourcePath + ".udd")) {
                            continue;
                        }

                    } else {

                        boolean bDir = true;
                        File targetServerFile = new File(strTargetServer);
                        boolean bExist = targetServerFile.exists();
                        bDir = targetServerFile.isDirectory();
                        if (bExist && !bDir) {
                            //存在同名文件
                            //重名文件
                            strTargetServer = formateNoneExistFileName(strTargetServer, false);
                        }//exist


                        // 拷贝
                        if (!copyFile(strSrcServer, strTargetServer)) {
                            continue;
                        }
                    }//bUDB
                }
            }

            if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {
                if (!strTargetServer.startsWith(strRootPath + "/" + strUserName) &&
                        !strTargetServer.startsWith(strRootPath + "/Customer")) {
                    continue;
                }
                //strTargetServer =strTargetServer.substring(desDatasourceDir.length()+1);
                strTargetServer = strTargetServer.substring(strRootPath.length() + 1);
            }

            Map<String, String> dicDatasource = new HashMap<>();
            dicDatasource.put("Alians", strSrcAlian);
            dicDatasource.put("Server", strTargetServer);
            dicDatasource.put("Type", engineType.value() + "");
            arrExpDatasources.add(dicDatasource);
            //user password
        }

        String desResourceDir = strCustomer + "/Symbol";
        if (strModule != null && !strModule.equals("")) {
            desResourceDir = desResourceDir + "/" + strModule;
        }

        isDir = false;
        File fileDesResourceDir = new File(desResourceDir);
        isExist = fileDesResourceDir.exists();
        isDir = fileDesResourceDir.isDirectory();
        if (!isExist || !isDir) {
            fileDesResourceDir.mkdirs();
        }

        String desResources = desResourceDir + "/" + strMapName;
        if (bNew || bResourcesModified) {
            // Marker
            {
                SymbolMarkerLibrary markerLibrary = new SymbolMarkerLibrary();
                SymbolGroup desMarkerGroup = markerLibrary.getRootGroup();
                SymbolGroup srcMarkerGroup = srcWorkspace.getResources().getMarkerLibrary().getRootGroup().getChildGroups().get(strMapAlians);
                if (bNew && !bResourcesModified) {
                    // 整个库都倒出
                    srcMarkerGroup = srcWorkspace.getResources().getMarkerLibrary().getRootGroup();
                }
                if (srcMarkerGroup != null) {
                    importSymbolsFrom(srcMarkerGroup, desMarkerGroup, true, false);
                }
                if (bResourcesModified) {
                    List<Integer> arrMarkerFromXML = findIntValuesFromXML(strMapXML, "sml:MarkerStyle");
                    setMarkerIDs.addAll(arrMarkerFromXML);
                    Integer[] arrMarkerIDs = new Integer[setMarkerIDs.size()];
                    setMarkerIDs.toArray(arrMarkerIDs);
                    for (int i = 0; i < arrMarkerIDs.length; i++) {
                        int nMarkerID = arrMarkerIDs[i].intValue();
                        if (!markerLibrary.contains(nMarkerID)) {
                            Symbol symbolTemp = srcWorkspace.getResources().getMarkerLibrary().findSymbol(nMarkerID);
                            if (symbolTemp != null) {
                                //[markerLibrary add:symbolTemp toGroup:desMarkerGroup];
                                markerLibrary.add(symbolTemp);
                            }
                        }
                    }
                }
                markerLibrary.saveAs(desResources + ".sym");
                markerLibrary.dispose();
            }
            // Line
            {
                SymbolLineLibrary lineLibrary = new SymbolLineLibrary();
                SymbolMarkerLibrary markerInlineLibrary = lineLibrary.getInlineMarkerLib();

                SymbolGroup desLineGroup = lineLibrary.getRootGroup();
                SymbolGroup srcLineGroup = srcWorkspace.getResources().getLineLibrary().getRootGroup().getChildGroups().get(strMapAlians);
                if (bNew && !bResourcesModified) {
                    srcLineGroup = srcWorkspace.getResources().getLineLibrary().getRootGroup();
                }
                if (srcLineGroup != null) {
                    importSymbolsFrom(srcLineGroup, desLineGroup, true, false);
                }
                //SymbolGroup *desInlineGroup = [markerInlineLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
                SymbolGroup desInlineGroup = markerInlineLibrary.getRootGroup();
                SymbolGroup srcInlineGroup = srcWorkspace.getResources().getLineLibrary().getInlineMarkerLib().getRootGroup().getChildGroups().get(strMapAlians);
                if (bNew && !bResourcesModified) {
                    srcInlineGroup = srcWorkspace.getResources().getLineLibrary().getInlineMarkerLib().getRootGroup();
                }
                if (srcInlineGroup != null) {
                    importSymbolsFrom(srcInlineGroup, desInlineGroup, true, false);
                }
                if (bResourcesModified) {
                    List<Integer> arrLineFromXML = findIntValuesFromXML(strMapXML, "sml:LineStyle");
                    setLineIDs.addAll(arrLineFromXML);
                    Integer[] arrLineIDs = new Integer[setLineIDs.size()];
                    setLineIDs.toArray(arrLineIDs);
                    for (int i = 0; i < arrLineIDs.length; i++) {
                        int nLineID = arrLineIDs[i].intValue();
                        if (!lineLibrary.contains(nLineID)) {
                            SymbolLine symbolTemp = (SymbolLine) srcWorkspace.getResources().getLineLibrary().findSymbol(nLineID);
                            if (symbolTemp != null) {
                                int[] arrInlineMarkerIds = symbolTemp.customizedPointSymbolIDs();
                                for (int j = 0; j < arrInlineMarkerIds.length; j++) {
                                    int nInlineMarker = arrInlineMarkerIds[j];
                                    if (!markerInlineLibrary.contains(nInlineMarker)) {
                                        Symbol symbolMarker = srcWorkspace.getResources().getLineLibrary().getInlineMarkerLib().findSymbol(nInlineMarker);
                                        markerInlineLibrary.add(symbolMarker);
                                    }
                                }
                                //[lineLibrary add:symbolTemp toGroup:desLineGroup];
                                lineLibrary.add(symbolTemp);
                            }
                        }
                    }
                }
                lineLibrary.saveAs(desResources + ".lsl");
                lineLibrary.dispose();
            }
            // Fill
            {
                SymbolFillLibrary fillLibrary = new SymbolFillLibrary();
                SymbolMarkerLibrary markerInfillLibrary = fillLibrary.getInfillMarkerLib();

                SymbolGroup desFillGroup = fillLibrary.getRootGroup();
                SymbolGroup srcFillGroup = srcWorkspace.getResources().getFillLibrary().getRootGroup().getChildGroups().get(strMapAlians);
                if (bNew && !bResourcesModified) {
                    srcFillGroup = srcWorkspace.getResources().getFillLibrary().getRootGroup();
                }
                if (srcFillGroup != null) {
                    importSymbolsFrom(srcFillGroup, desFillGroup, true, false);
                }
                //SymbolGroup *desInfillGroup = [markerInfillLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
                SymbolGroup desInfillGroup = markerInfillLibrary.getRootGroup();
                SymbolGroup srcInfillGroup = srcWorkspace.getResources().getFillLibrary().getInfillMarkerLib().getRootGroup().getChildGroups().get(strMapAlians);
                if (bNew && !bResourcesModified) {
                    srcInfillGroup = srcWorkspace.getResources().getFillLibrary().getInfillMarkerLib().getRootGroup();
                }
                if (srcInfillGroup != null) {
                    importSymbolsFrom(srcInfillGroup, desInfillGroup, true, false);
                }
                if (bResourcesModified) {
                    List<Integer> arrFillFromXML = findIntValuesFromXML(strMapXML, "sml:FillStyle");
                    setFillIDs.addAll(arrFillFromXML);
                    Integer[] arrFillIDs = new Integer[setFillIDs.size()];
                    setFillIDs.toArray(arrFillIDs);
                    for (int i = 0; i < arrFillIDs.length; i++) {
                        int nFillID = arrFillIDs[i].intValue();
                        if (!fillLibrary.contains(nFillID)) {
                            SymbolFill symbolTemp = (SymbolFill) srcWorkspace.getResources().getFillLibrary().findSymbol(nFillID);
                            if (symbolTemp != null) {
                                int[] arrInfillMarkerIds = symbolTemp.customizedPointSymbolIDs();
                                for (int j = 0; j < arrInfillMarkerIds.length; j++) {
                                    int nInfillMarker = arrInfillMarkerIds[j];
                                    if (!markerInfillLibrary.contains(nInfillMarker)) {
                                        Symbol symbolMarker = srcWorkspace.getResources().getFillLibrary().getInfillMarkerLib().findSymbol(nInfillMarker);
                                        markerInfillLibrary.add(symbolMarker);
                                    }
                                }
                                fillLibrary.add(symbolTemp);
                            }
                        }
                    }
                }
                fillLibrary.saveAs(desResources + ".bru");
//                fillLibrary.dispose();
            }

        }

        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("Resources", desResources.substring(strRootPath.length() + 1));
            JSONArray jsonArray = new JSONArray();
            for (Map<String, String> arrExpDatasource : arrExpDatasources) {
                jsonArray.put(new JSONObject(arrExpDatasource));
            }
            jsonObject.put("Datasources", jsonArray);
            //模板
            if (dicAddition != null) {
                String strTemplate = dicAddition.get("Template");
                if (strTemplate != null) {
                    jsonObject.put("Template", strTemplate);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        String strExplorerJson = jsonObject.toString();
        try {
            Writer outWriter = new OutputStreamWriter(new FileOutputStream(desPathMapExp, true), encodingUTF8);
            outWriter.write(strExplorerJson);
            outWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        mapExport.close();

        return strMapName;
    }

    //大工作空间打开本地地图
    public boolean openMapName(String strMapName, Workspace desWorkspace, String strModule, boolean bPrivate) {

        if (desWorkspace == null || desWorkspace.getMaps().indexOf(strMapName) != -1) {
            return false;
        }

        String strUserName = null;
        if (bPrivate) {
            strUserName = getUserName();
            if (strUserName == null) {
                return false;
            }
        } else {
            strUserName = "Customer";
        }


        String strRootPath = getRootPath();
        String strCustomer = strRootPath + "/" + strUserName + "/Data";


        String srcPathMap;
        if (strModule != null && !strModule.equals("")) {
            srcPathMap = strCustomer + "/Map/" + strModule + "/" + strMapName;
        } else {
            srcPathMap = strCustomer + "/Map/" + strMapName;

        }
        String srcPathXML = srcPathMap + ".xml";
        boolean isDir = true;
        File fileSrcPathXML = new File(srcPathXML);
        boolean isExist = fileSrcPathXML.exists();
        isDir = fileSrcPathXML.isDirectory();
        if (!isExist || isDir) {
            return false;
        }

        String srcPathEXP = srcPathMap + ".exp";
        isDir = true;
        File fileSrcPathEXP = new File(srcPathEXP);
        isExist = fileSrcPathEXP.exists();
        isDir = fileSrcPathEXP.isDirectory();
        if (!isExist || isDir) {
            return false;
        }

        String strMapEXP = stringWithContentsOfFile(srcPathEXP, encodingUTF8);
        // {
        //  "Datasources":
        //                  [ {"Alians":strMapName,"Type":nEngineType,"Server":strDatasourceName} , {...} , {...} ... ] ,
        //  "Resources":
        //                  strMapName
        // }

        List<Map<String, String>> datasourcesList = new ArrayList<>();
        String strResources = "";
        //String templateStr;
        try {
            JSONObject jsonObject = new JSONObject(strMapEXP);
            JSONArray jsonArray = jsonObject.optJSONArray("Datasources");
            if (jsonArray != null) {
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject datasourceObject = jsonArray.getJSONObject(i);
                    Map<String, String> datasourceMap = new HashMap<>();
                    datasourceMap.put("Alians", datasourceObject.optString("Alians"));
                    datasourceMap.put("Type", datasourceObject.optString("Type"));
                    datasourceMap.put("Server", datasourceObject.optString("Server"));
                    datasourcesList.add(datasourceMap);
                }
            }
            strResources = jsonObject.optString("Resources");
            //templateStr = jsonObject.optString("Template");
        } catch (JSONException e) {
            e.printStackTrace();
        }
//        NSDictionary *dicExp = [NSJSONSerialization JSONObjectWithData:[strMapEXP dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        //String srcDatasourceDir=strCustomer+"/Datasource";
        String srcDatasourceDir = strRootPath;
//        if(strModule!=null&&!strModule.equals("")){
//            srcDatasourceDir=srcDatasourceDir+"/"+strModule;
//        }

        // 重复的server处理
        //      1.文件型数据源：若bDatasourceRep，关闭原来数据源，拷贝新数据源并重新打开（alian保持原来的）
        //      2.网络型数据源：不再重复打开（alian保持原来的）
        List<String> arrTargetServers = new ArrayList<>();
        List<String> arrTargetAlians = new ArrayList<>();

        for (int i = 0; i < desWorkspace.getDatasources().getCount(); i++) {
            Datasource datasource = desWorkspace.getDatasources().get(i);
            DatasourceConnectionInfo datasourceInfo = datasource.getConnectionInfo();
            if (datasourceInfo.getEngineType() == EngineType.UDB || datasourceInfo.getEngineType() == EngineType.IMAGEPLUGINS) {
                //只要名字
                String fullName = datasourceInfo.getServer();
                if (fullName.startsWith(strRootPath)) {
                    String relateName = fullName.substring(strRootPath.length() + 1);
                    arrTargetServers.add(relateName);
                    arrTargetAlians.add(datasourceInfo.getAlias());
                }
//                String[] arrServer = fullName.split("/");
//                String lastName = arrServer[arrServer.length - 1];
//                String fatherName = fullName.substring(0, fullName.length() - lastName.length() - 1);
//                if (fatherName.equals(srcDatasourceDir)) {
//                    //同级目录下的才会被替换
//                    arrTargetServers.add(lastName);
//                    arrTargetAlians.add(datasourceInfo.getAlias());
//                }
            } else {
                //网络数据集用完整url
                arrTargetServers.add(datasourceInfo.getServer());
                arrTargetAlians.add(datasourceInfo.getAlias());
            }
        }

        //更名数组
        List<String> arrAlian = new ArrayList<>();
        List<String> arrReAlian = new ArrayList<>();

        for (Map<String, String> datasourceMap : datasourcesList) {
            String strAlian = datasourceMap.get("Alians");
            String strServer = datasourceMap.get("Server");
//            EngineType engineType = EngineType.newInstance(Integer.parseInt(datasourceMap.get("Type")));
            EngineType engineType = (EngineType) Enum.parse(EngineType.class, Integer.parseInt(datasourceMap.get("Type")));
            // Alians重命名 同一个Server不要打开两次
            String strDesAlian = strAlian;

            int nIndex = arrTargetServers.indexOf(strServer);
            if (nIndex >= 0 && nIndex < arrTargetServers.size()) {
                // 替换alian 保证原来map有数据源
                strDesAlian = arrTargetAlians.get(nIndex);
            } else {
                // 保证不重名
                strDesAlian = formateNoneExistDatasourceAlian(strAlian, desWorkspace);
                DatasourceConnectionInfo infoTemp = new DatasourceConnectionInfo();
//                if (engineType.value() == EngineType.UDB.value() || engineType.value() == EngineType.IMAGEPLUGINS.value()) {
                if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {
                    infoTemp.setServer(srcDatasourceDir + "/" + strServer);
                } else {
                    infoTemp.setServer(strServer);
                }
                infoTemp.setEngineType(engineType);
                infoTemp.setAlias(strDesAlian);
                if (desWorkspace.getDatasources().open(infoTemp) == null) {
//                    if(![desWorkspace.datasources open:infoTemp]){
                    continue;
                }
            }
            // xml中需重命名的别名
            if (!strAlian.equals(strDesAlian)) {
                arrAlian.add(strAlian);
                arrReAlian.add(strDesAlian);
            }
        }


        String srcResources = strRootPath + "/" + strResources;// = strCustomer + "/Resource/" + strModule + "/" + strMapName;
//        if(strModule!=null&&!strModule.equals("")){
//            srcResources=strCustomer + "/Symbol/" + strModule + "/" + strMapName;
//        }else {
//            srcResources=strCustomer+"/Symbol/"+strMapName;
//        }
        // Marker
        {
            if (desWorkspace.getResources().getMarkerLibrary().getRootGroup().getChildGroups().indexOf(strMapName) != -1) {
                //删除分组
                //-----??>>>[desWorkspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName];
                desWorkspace.getResources().getMarkerLibrary().getRootGroup().getChildGroups().remove(strMapName, false);
            }
            //新建分组
            SymbolGroup desMarkerGroup = desWorkspace.getResources().getMarkerLibrary().getRootGroup().getChildGroups().create(strMapName);

            String strMarkerPath = srcResources + ".sym";
            isDir = true;
            File fileStrMarker = new File(strMarkerPath);
            isExist = fileStrMarker.exists();
            isDir = fileStrMarker.isDirectory();
            if (isExist && !isDir) {
                SymbolMarkerLibrary markerLibrary = new SymbolMarkerLibrary();
                markerLibrary.appendFromFile(strMarkerPath, true);
                importSymbolsFrom(markerLibrary.getRootGroup(), desMarkerGroup, true, true);
            }
        }
        // Line
        {
            if (desWorkspace.getResources().getLineLibrary().getRootGroup().getChildGroups().indexOf(strMapName) != -1) {
                //删除分组
                desWorkspace.getResources().getLineLibrary().getRootGroup().getChildGroups().remove(strMapName, false);
            }
            if (desWorkspace.getResources().getLineLibrary().getInlineMarkerLib().getRootGroup().getChildGroups().indexOf(strMapName) != -1) {
                //删除inlineMarkerLib
                desWorkspace.getResources().getLineLibrary().getInlineMarkerLib().getRootGroup().getChildGroups().remove(strMapName, false);
            }

            SymbolGroup desLineGroup = desWorkspace.getResources().getLineLibrary().getRootGroup().getChildGroups().create(strMapName);
            SymbolGroup desInlineMarkerGroup = desWorkspace.getResources().getLineLibrary().getInlineMarkerLib().getRootGroup().getChildGroups().create(strMapName);

            String strLinePath = srcResources + ".lsl";
            isDir = true;
            File fileStrLine = new File(strLinePath);
            isExist = fileStrLine.exists();
            isDir = fileStrLine.isDirectory();
            if (isExist && !isDir) {
                SymbolLineLibrary lineLibrary = new SymbolLineLibrary();
                lineLibrary.appendFromFile(strLinePath, true);
                importSymbolsFrom(lineLibrary.getInlineMarkerLib().getRootGroup(), desInlineMarkerGroup, true, true);
                importSymbolsFrom(lineLibrary.getRootGroup(), desLineGroup, true, true);
            }
        }
        // Fill
        {
            if (desWorkspace.getResources().getFillLibrary().getRootGroup().getChildGroups().indexOf(strMapName) != -1) {
                //删除分组
                desWorkspace.getResources().getFillLibrary().getRootGroup().getChildGroups().remove(strMapName, false);
            }
            if (desWorkspace.getResources().getFillLibrary().getRootGroup().getChildGroups().indexOf(strMapName) != -1) {
                //删除infillMarkerLib
                desWorkspace.getResources().getFillLibrary().getInfillMarkerLib().getRootGroup().getChildGroups().remove(strMapName, false);
            }

            SymbolGroup desFillGroup = desWorkspace.getResources().getFillLibrary().getRootGroup().getChildGroups().create(strMapName);
            SymbolGroup desInfillMarkerGroup = desWorkspace.getResources().getFillLibrary().getInfillMarkerLib().getRootGroup().getChildGroups().create(strMapName);

            String strFillPath = srcResources + ".bru";
            isDir = true;
            File fileStrFill = new File(strFillPath);
            isExist = fileStrFill.exists();
            isDir = fileStrFill.isDirectory();
            if (isExist && !isDir) {
                SymbolFillLibrary fillLibrary = new SymbolFillLibrary();
                fillLibrary.appendFromFile(strFillPath, true);
                importSymbolsFrom(fillLibrary.getInfillMarkerLib().getRootGroup(), desInfillMarkerGroup, true, true);
                importSymbolsFrom(fillLibrary.getRootGroup(), desFillGroup, true, true);
            }
        }


        String strMapXML = stringWithContentsOfFile(srcPathXML, encodingUTF8);
        strMapXML = modifyXML(strMapXML, arrAlian, arrReAlian);

        desWorkspace.getMaps().add(strMapName, strMapXML);

        return true;


    }

    public String importUDBFile(String strFile, String strModule) {

        if (!isDatasourceFileExist(strFile, true)) {
            return null;
        }

        String rootPath = getRootPath();
        String userName = getUserName();
        String desDatasourceDir = rootPath + "/" + userName + "/Datasource";
        //String desDatasourceDir =getCustomerDirectory()+"/Datasource";
        if (strModule != null) {
            desDatasourceDir = desDatasourceDir + "/" + strModule;
        }
        boolean isDir = false;
        File fileDatasourceDir = new File(desDatasourceDir);
        boolean isExist = fileDatasourceDir.exists();
        if (!isExist || !isDir) {
            fileDatasourceDir.mkdirs();
        }

        String[] arrSrcServer = strFile.split("/");
        String strFileName = arrSrcServer[arrSrcServer.length - 1];
        // 导入工作空间名
        String strTargetFile = desDatasourceDir + "/" + strFileName;

        String strSrcDatasourcePath = strFile.substring(0, strFile.length() - 4);
        String strTargetDatasourcePath = strFile.substring(0, strTargetFile.length() - 4);

        String strResult = null;
        // 检查重复性
        isDir = true;
        File fileTargetFile = new File(strTargetFile);
        isExist = fileTargetFile.exists();
        isDir = fileTargetFile.isDirectory();
        if (isExist && !isDir) {
            //存在同名文件
            //重名文件
            strTargetFile = formateNoneExistFileName(strTargetFile, false);
            String[] arrTargetFile = strTargetFile.split("/");
            strResult = arrTargetFile[arrTargetFile.length - 1];
            strTargetDatasourcePath = strTargetFile.substring(0, strTargetFile.length() - 4);
        }//exist

        // 拷贝udb
        if (!copyFile(strSrcDatasourcePath + ".udb", strTargetDatasourcePath + ".udb")) {
            return null;
        }
        // 拷贝udd
        if (!copyFile(strSrcDatasourcePath + ".udd", strTargetDatasourcePath + ".udd")) {
            return null;
        }
        return strResult;

    }

    public String importDatasourceFile(String strFile, String strModule) {

        String[] arrFile = strFile.split(".");
        String strSuffix = arrFile[arrFile.length - 1];
        if (strSuffix.toLowerCase().equals("udb")) {
            return importUDBFile(strFile, strModule);
        } else {
            if (!isDatasourceFileExist(strFile, false)) {
                return null;
            }
            String rootPath = getRootPath();
            String userName = getUserName();
            String desDatasourceDir = rootPath + "/" + userName + "/Datasource";
            //String desDatasourceDir =getCustomerDirectory()+"/Datasource";
            if (strModule != null) {
                desDatasourceDir = desDatasourceDir + "/" + strModule;
            }
            boolean isDir = false;
            File fileDesDatasourceDir = new File(desDatasourceDir);
            boolean isExist = fileDesDatasourceDir.exists();
            isDir = fileDesDatasourceDir.isDirectory();
            if (!isExist || !isDir) {
                fileDesDatasourceDir.mkdirs();
            }
            String[] arrSrcServer = strFile.split("/");
            String strFileName = arrSrcServer[arrSrcServer.length - 1];
            // 导入工作空间名
            String strTargetFile = desDatasourceDir + "/" + strFileName;
            isDir = true;
            File fileTargetFile = new File(strTargetFile);
            isExist = fileTargetFile.exists();
            isDir = fileTargetFile.isDirectory();
            String strResult = null;
            if (isExist && !isDir) {
                //存在同名文件
                //重名文件
                strTargetFile = formateNoneExistFileName(strTargetFile, false);
                String[] arrTargetFile = strTargetFile.split("/");
                strResult = arrTargetFile[arrTargetFile.length - 1];
            }//exist


            // 拷贝
            if (!copyFile(strFile, strTargetFile)) {
                return null;
            }

            return strResult;
        }
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


    protected String formateNoneExistFileName(String strOrg, boolean isDir) {
        String strName = strOrg;
        String strSuffix = "";
        if (!isDir) {
            int index = strOrg.lastIndexOf(".");
            strName = strOrg.substring(0, index);
            strSuffix = strOrg.substring(index);
        } else {
            strName = strOrg.substring(0, strOrg.length() - 1);
            strSuffix = "/";
        }
        String result = strOrg;
        int nAddNum = 1;
        while (true) {
            File fileTemp = new File(result);
            if (!fileTemp.exists()) {
                return result;
            } else if (isDir != fileTemp.isDirectory()) {
                return result;
            } else {
                result = strName + "_" + nAddNum + strSuffix;
                nAddNum++;
            }
        }
    }


    protected boolean isDatasourceFileExist(String strpath, boolean isUDB) {
        if (isUDB) {
            return isUDBFileExist(strpath);
        } else {
            File datasoueceFile = new File(strpath);
            if (!datasoueceFile.exists() || !datasoueceFile.isFile()) {
                return false;
            } else {
                return true;
            }
        }
    }

    protected boolean isUDBFileExist(String strpath) {
        if (!strpath.endsWith(".udb")) {
            return false;
        }
        File udbFile = new File(strpath);
        if (!udbFile.exists() || !udbFile.isFile()) {
            return false;
        }
        String strBase = strpath.substring(0, strpath.length() - 4);
        File uddFile = new File(strBase + ".udd");
        if (!uddFile.exists() || !uddFile.isFile()) {
            return false;
        } else {
            return true;
        }
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
        //        int bytesum = 0;
        //        int byteread = 0;
        //        try{
        //            int bytesum = 0;
        //            int byteread = 0;
        //            File oldfile = new File(oldPath);
        //            File newfile = new File(newPath);
        //            if (oldfile.exists()){
        //                if (newfile.exists()){
        //                    newfile.delete();
        //                }
        //                newfile.createNewFile();
        //                InputStream inStream = new FileInputStream(oldPath);
        //                FileOutputStream fs = new FileOutputStream(newPath);
        //                byte[] buffer = new byte[1444];
        //                int length;
        //                while( (byteread = inStream.read(buffer)) != -1 ){
        //                    bytesum += byteread;
        //                    System.out.println(bytesum);
        //                    fs.write(buffer,0,byteread);
        //                }
        //                inStream.close();
        //                return true;
        //            }else{
        //                return false;
        //            }
        //
        //        }
        //        catch (Exception e){
        //            return false;
        //        }
    }

}
