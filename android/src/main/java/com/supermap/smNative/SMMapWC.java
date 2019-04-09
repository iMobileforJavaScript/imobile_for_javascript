package com.supermap.smNative;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.FileUtil;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.analyst.spatialanalyst.RasterClip;
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
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.GeoRegion;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Resources;
import com.supermap.data.Symbol;
import com.supermap.data.SymbolFill;
import com.supermap.data.SymbolFillLibrary;
import com.supermap.data.SymbolGroup;
import com.supermap.data.SymbolGroups;
import com.supermap.data.SymbolLibrary;
import com.supermap.data.SymbolLine;
import com.supermap.data.SymbolLineLibrary;
import com.supermap.data.SymbolMarkerLibrary;
import com.supermap.data.SymbolType;
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
import java.nio.DoubleBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
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
//            Boolean isOpen = ds != null && data.get("server") != null
//                    && ds.getConnectionInfo().getServer().equals(data.get("server"))
//                    && ds.getConnectionInfo().getAlias().equals(data.get("alias"))
//                    && ds.isOpened();
            Boolean isOpen = ds != null && ds.isOpened();

            String alias = "";
            String server = "";
            if (data.containsKey("alias")) {
                alias = data.get("alias").toString();
            }
            if (data.containsKey("server")) {
                server = data.get("server").toString();
            }
            if (ds != null && data.get("server") != null) {
                String currentDSAlias = ds.getConnectionInfo().getAlias();
                String currentDSServer = ds.getConnectionInfo().getServer();
                if (currentDSAlias.equals(alias) && !currentDSServer.equals(server)) {
                    int index = 1;
                    while (currentDSAlias.equals(alias) || SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().get(alias) != null) {
                        alias = currentDSAlias + "_" + index;
                        index++;
                    }
                    isOpen = false;
                }
            }
            Datasource dataSource = isOpen ? ds : null;
            if (!isOpen) {
                if (data.containsKey("alias")) {
//                    String alias = data.get("alias").toString();
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
                    info.setServer(server);
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

    private boolean reNameFile(String strOldName, String strNewName, String strFolder) {
        String strOld = strFolder + "/" + strOldName;
        String strNew = strFolder + "/" + strNewName;

//        boolean bFolder=true;
        File oldFile = new File(strOld);
        if (oldFile.exists() && !oldFile.isDirectory()) {
            //存在
            File newFile = new File(strNew);
            if (newFile.exists() && !newFile.isDirectory()) {
                newFile.delete();
            }
            copyFile(strOld, strNew);
            return true;
        } else {
            return false;
        }
    }

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

    public boolean exportMapNames(ReadableArray arrMapNames, String strFileName, boolean isFileReplace, ReadableMap extraMap) {
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

        ReadableMap notExportMap = null;
        if (extraMap != null && extraMap.hasKey("notExport")) {
            notExportMap = extraMap.getMap("notExport");
        }
        for (int i = 0; i < arrMapNames.size(); i++) {
            String mapName = arrMapNames.getString(i);
            if (workspace.getMaps().indexOf(mapName) != -1) {
                // 打开map
                mapExport.open(mapName);

                Layers exportLayes = mapExport.getLayers();

                //判断是否有不需要导出的图层
                if (notExportMap != null && notExportMap.hasKey(mapName)) {
                    ReadableArray indexArray = notExportMap.getArray(mapName);
                    ArrayList<Object> list = indexArray.toArrayList();
                    ArrayList<Integer> list2 = new ArrayList<>();
                    for (int i1 = 0; i1 < list.size(); i1++) {
                        String ind = list.get(i1).toString();
                        if (ind.lastIndexOf(".") > 0) {
                            ind = ind.substring(0, ind.lastIndexOf("."));
                        }
                        list2.add(Integer.parseInt(ind));
                    }
                    Collections.reverse(list2);
                    for (int index = 0; index < list2.size(); index++) {
                        exportLayes.remove(list2.get(index));
                    }
                }

                // 不重复的datasource保存
                List<Dataset> datasourceList = new ArrayList<>();
                for (int j = 0; j < exportLayes.getCount(); j++) {
                    Layer layer = exportLayes.get(j);
                    if (layer.getDataset() == null) {
                        if (layer instanceof LayerGroup) {
                            datasourceList.addAll(allDatasetsOfLayerGroup((LayerGroup) layer));
                        }
                    } else {
                        datasourceList.add(layer.getDataset());
                    }
                }

                for (int j = 0; j < datasourceList.size(); j++) {
                    Datasource datasource = datasourceList.get(j).getDatasource();
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

        boolean marker = workspaceDes.getResources().getMarkerLibrary().fromFile(strMarkerPath);
        workspaceDes.getResources().getLineLibrary().fromFile(strLinePath);
        workspaceDes.getResources().getFillLibrary().fromFile(strFillPath);

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


    private ArrayList<String> importSymbolsFrom(SymbolGroup srcGroup, SymbolGroup desGroup, boolean bDirRetain, boolean bSymReplace) {
        ArrayList<String> arrResult = null;
        if (desGroup == null || desGroup.getLibrary() == null) {
            //deGroup必须是必须在Lib中
            return arrResult;
        }
        if (srcGroup.getLibrary()!=null && srcGroup.getLibrary() == desGroup.getLibrary() ){
            //不支持
            return arrResult;
        }
        // group的名称 symbol的id 都需要desLib查重名
        SymbolLibrary desLib = desGroup.getLibrary();
        if (srcGroup == null) {
            return arrResult;
        }
        for (int i = 0; i < srcGroup.getCount(); i++) {
            Symbol sym = srcGroup.get(i);
            int nId = sym.getID();
            boolean bOld = (desLib.findSymbol(sym.getID()) != null);
            if (bOld){
                if (bSymReplace){
                    desLib.remove(nId);
                    desLib.add(sym,desGroup);
                }else{
                    int nIdNew = desLib.add(sym,desGroup);
                    String strResult = "" + nId + ":" + nIdNew;
                    if (arrResult==null){
                        arrResult = new ArrayList<String>();
                    }
                    arrResult.add(strResult);
                }

            }else{
                desLib.add(sym,desGroup);
            }
        }

        SymbolGroup desSubGroup = desGroup;
        SymbolGroups srcChildGroups = srcGroup.getChildGroups();
        if (srcChildGroups == null) {
            return arrResult;
        }
        for (int j = 0; j < srcChildGroups.getCount(); j++) {
            SymbolGroup subGroup = srcChildGroups.get(j);

            if (bDirRetain) {
                String subName = subGroup.getName();
                int nAddNum = 1;
//                while (desLib.getRootGroup().getChildGroups().contains(subName)) {
                while (desGroup.getChildGroups().contains(subName)) {
                    subName = subGroup.getName() + "#" + nAddNum;
                    nAddNum++;
                }
                desSubGroup = desGroup.getChildGroups().create(subName);
            }
            ArrayList<String> arrSubRersult = importSymbolsFrom(subGroup, desSubGroup, bDirRetain, bSymReplace);
            if (arrSubRersult!=null){
                if (arrResult==null){
                    arrResult = new ArrayList<String>();
                }
                arrResult.addAll(arrSubRersult);
            }

        }

        return arrResult;
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
//        String[] arrServer = strServer.split("/");
//        int nCount = arrServer.length;
//        if (nCount >= 3) {
//            return arrServer[nCount - 3];
//        } else {
//            return null;
//        }
        String strRoot = getRootPath();
        String strSub = strServer.substring(strRoot.length() + 1);
        String[] arrServer = strSub.split("/");
        return arrServer[0];
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
    public List<String> importWorkspaceInfo(Map infoMap, String strModule, boolean bPrivate) {

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

        String strUserName;
        if (!bPrivate) {
            strUserName = "Customer";
        } else {
            strUserName = getUserName();
            if (strUserName == null) {
                return arrResult;
            }
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

        String strMapRename = (String) infoMap.get("name_for_map");
        String strDataRename = (String) infoMap.get("name_for_data");

        int indexForData = 0;

        String strDesMapDir = strCustomer + "/Map";
        if (strModule != null && !strModule.equals("")) {
            strDesMapDir = strDesMapDir + "/" + strModule;
        }

        List<String> arrTemp = new ArrayList<>();
        for (int i = 0; i < importWorkspace.getMaps().getCount(); i++) {
            String strMapName = importWorkspace.getMaps().get(i);
            String strResName = saveMapName(strMapName, importWorkspace, strModule, dicAddition, true, false, bPrivate);
            if (strResName != null) {
//                arrTemp.add(strResName);

                {
                    if (strMapRename != null && !strMapRename.equals("")) {
                        //1. 重命名xml和exp
                        reNameFile(strResName + ".xml", strMapRename + ".xml", strDesMapDir);

                        reNameFile(strResName + ".exp", strMapRename + ".exp", strDesMapDir);

                        String strPathEXP = strDesMapDir + "/" + strMapRename + ".exp";

                        String strMapEXP = stringWithContentsOfFile(strPathEXP, encodingUTF8);
                        List<Map<String, String>> arrDatasources = new ArrayList<>();
                        String strResources = "";
                        String templateStr = null;
                        try {
                            JSONObject jsonObject = new JSONObject(strMapEXP);
                            JSONArray jsonArray = jsonObject.optJSONArray("Datasources");
                            if (jsonArray != null) {
                                for (int index = 0; index < jsonArray.length(); index++) {
                                    JSONObject datasourceObject = jsonArray.getJSONObject(index);
                                    Map<String, String> datasourceMap = new HashMap<>();
                                    datasourceMap.put("Alians", datasourceObject.optString("Alians"));
                                    datasourceMap.put("Type", datasourceObject.optString("Type"));
                                    datasourceMap.put("Server", datasourceObject.optString("Server"));
                                    arrDatasources.add(datasourceMap);
                                }
                            }
                            strResources = jsonObject.optString("Resources", null);
                            templateStr = jsonObject.optString("Template", null);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        //2. 更名datasource
                        List<Map<String, String>> arrNewDatasources = new ArrayList<>();
                        if (strDataRename != null && !strDataRename.equals("")) {
                            //datasource
                            for (int k = 0; k < arrDatasources.size(); k++) {
                                Map<String, String> dicTemp = arrDatasources.get(k);
                                EngineType engineType = (EngineType) Enum.parse(EngineType.class, Integer.parseInt(dicTemp.get("Type")));
                                if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {
                                    String strDsRename = strDataRename + "_" + indexForData;
                                    if (indexForData == 0) {
                                        strDsRename = strDataRename;
                                    }
                                    indexForData++;

                                    String strOldServer = dicTemp.get("Server");
                                    String[] arrOldServer = strOldServer.split("/");
                                    String strOldName = arrOldServer[arrOldServer.length - 1];
                                    String[] arrOldName = strOldName.split("\\.");
                                    String strSuffix = arrOldName[arrOldName.length - 1];

                                    String strNewServer = strOldServer.substring(0, strOldServer.length() - strOldName.length() - 1) + "/" + strDsRename + "." + strSuffix;
                                    reNameFile(strOldServer, strNewServer, strRootPath);

                                    if (engineType == EngineType.UDB) {
                                        reNameFile((strOldServer.substring(0, strOldServer.length() - 4) + ".udd")
                                                , strNewServer.substring(0, strNewServer.length() - 4) + ".udd"
                                                , strRootPath);
                                    }

                                    Map<String, String> dicNew = new HashMap<>();
                                    dicNew.putAll(dicTemp);
                                    dicNew.put("Server", strNewServer);
                                    arrNewDatasources.add(dicNew);

                                } else {
                                    arrNewDatasources.add(dicTemp);
                                }
                            }
                        } else {
                            arrNewDatasources.addAll(arrDatasources);
                        }

                        //resource
                        String strOldResource = strResources;
                        String[] arrOldResource = strOldResource.split("/");
                        String strOldName = arrOldResource[arrOldResource.length - 1];
                        String strNewResource = strOldResource.substring(0, strOldResource.length() - strOldName.length()) + strMapRename;
                        reNameFile(strOldResource + ".sym", strNewResource + ".sym", strRootPath);
                        reNameFile(strOldResource + ".lsl", strNewResource + ".lsl", strRootPath);
                        reNameFile(strOldResource + ".bru", strNewResource + ".bru", strRootPath);


                        JSONObject jsonObject = new JSONObject();
                        try {
                            jsonObject.put("Resources", strNewResource);
                            JSONArray jsonArray = new JSONArray();
                            for (Map<String, String> arrExpDatasource : arrNewDatasources) {
                                jsonArray.put(new JSONObject(arrExpDatasource));
                            }
                            jsonObject.put("Datasources", jsonArray);
                            //模板
                            if (templateStr != null) {
                                jsonObject.put("Template", templateStr);
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        String strExplorerJson = jsonObject.toString();
                        try {
                            Writer outWriter = new OutputStreamWriter(new FileOutputStream(strPathEXP, false), encodingUTF8);
                            outWriter.write(strExplorerJson);
                            outWriter.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        arrTemp.add(strMapRename);
                        strMapRename = new String(strMapRename + "_" + i);
                    } else {

                        //2. 更名datasource symbol
                        if (strDataRename != null && !strDataRename.equals("")) {
                            String strPathEXP = strDesMapDir + "/" + strResName + ".exp";

                            String strMapEXP = stringWithContentsOfFile(strPathEXP, encodingUTF8);
                            List<Map<String, String>> arrDatasources = new ArrayList<>();
                            String strResources = "";
                            String templateStr = null;
                            try {
                                JSONObject jsonObject = new JSONObject(strMapEXP);
                                JSONArray jsonArray = jsonObject.optJSONArray("Datasources");
                                if (jsonArray != null) {
                                    for (int index = 0; index < jsonArray.length(); index++) {
                                        JSONObject datasourceObject = jsonArray.getJSONObject(index);
                                        Map<String, String> datasourceMap = new HashMap<>();
                                        datasourceMap.put("Alians", datasourceObject.optString("Alians"));
                                        datasourceMap.put("Type", datasourceObject.optString("Type"));
                                        datasourceMap.put("Server", datasourceObject.optString("Server"));
                                        arrDatasources.add(datasourceMap);
                                    }
                                }
                                strResources = jsonObject.optString("Resources", "");
                                templateStr = jsonObject.optString("Template", null);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            List<Map<String, String>> arrNewDatasources = new ArrayList<>();
                            arrNewDatasources.addAll(arrDatasources);
                            for (int k = 0; k < arrDatasources.size(); k++) {
                                Map<String, String> dicTemp = arrDatasources.get(k);
                                EngineType engineType = (EngineType) Enum.parse(EngineType.class, Integer.parseInt(dicTemp.get("Type")));
                                if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {

                                    String strDsRename = strDataRename + "_" + indexForData;
                                    if (indexForData == 0) {
                                        strDsRename = strDataRename;
                                    }
                                    indexForData++;

                                    String strOldServer = dicTemp.get("Server");
                                    String[] arrOldServer = strOldServer.split("/");
                                    String strOldName = arrOldServer[arrOldServer.length - 1];
                                    String[] arrOldName = strOldName.split("\\.");
                                    String strSuffix = arrOldName[arrOldName.length - 1];

                                    String strNewServer = strOldServer.substring(0, strOldServer.length() - strOldName.length() - 1)
                                            + "/" + strDsRename + "." + strSuffix;
                                    reNameFile(strOldServer, strNewServer, strRootPath);

                                    if (engineType == EngineType.UDB) {
                                        reNameFile(strOldServer.substring(0, strOldServer.length() - 4) + ".udd"
                                                , strNewServer.substring(0, strNewServer.length() - 4) + ".udd", strRootPath);
                                    }

                                    dicTemp.put("Server", strNewServer);
                                    arrNewDatasources.add(dicTemp);
                                } else {
                                    arrNewDatasources.add(dicTemp);
                                }


                            }

                            JSONObject jsonObject = new JSONObject();
                            try {
                                jsonObject.put("Resources", strResources);
                                JSONArray jsonArray = new JSONArray();
                                for (Map<String, String> arrExpDatasource : arrNewDatasources) {
                                    jsonArray.put(new JSONObject(arrExpDatasource));
                                }
                                jsonObject.put("Datasources", jsonArray);
                                //模板
                                if (templateStr != null) {
                                    jsonObject.put("Template", templateStr);
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            String strExplorerJson = jsonObject.toString();
                            try {
                                Writer outWriter = new OutputStreamWriter(new FileOutputStream(strPathEXP, false), encodingUTF8);
                                outWriter.write(strExplorerJson);
                                outWriter.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                        arrTemp.add(strResName);
                    }
                }
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
    public String saveMapName(String strMapAlians, Workspace srcWorkspace, String strModule, Map<String, String> dicAddition, boolean bNew, boolean bResourcesModified, boolean bPrivate) {

        if (srcWorkspace == null || srcWorkspace.getMaps().indexOf(strMapAlians) == -1) {
            return null;
        }

//        String strCustomer = getCustomerDirectory(true);
//        String strModule = getModuleDirectory(nModule);
//        if (strModule == null) {
//            return null;
//        }

        String strUserName;
        if (!bPrivate) {
            strUserName = "Customer";
        } else {
            strUserName = getUserName();
            if (strUserName == null) {
                return null;
            }
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

            String strTargetServer = null;
            if (engineType == EngineType.UDB || engineType == EngineType.IMAGEPLUGINS) {

                // 源文件存在？
                if (!isDatasourceFileExist(strSrcServer, engineType == EngineType.UDB)) {
                    continue;
                }

                if (!bNew && strSrcServer.startsWith(desDatasourceDir)) {
                    // 不需要拷贝的UDB
                    strTargetServer = strSrcServer;
                } else {

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
                strTargetServer = strTargetServer.substring(strRootPath.length() + 1);

            } else {
                strTargetServer = strSrcServer;
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

    public boolean openMap(ReadableMap mapInfo, Workspace desWorkspace) {
        if (mapInfo != null) {

            String strMapName = mapInfo.getString("MapName");
            if (strMapName != null) {
//                String strModule = mapInfo.get("Module");
//                Boolean isPrivate = false;//默认公共目录
//                if (mapInfo.containsKey("IsPrivate")) {
//                    isPrivate = Boolean.parseBoolean(mapInfo.get("IsPrivate"));
//                }
//                return openMapName(strMapName, desWorkspace, strModule, isPrivate);
                return openMapName(strMapName,desWorkspace,mapInfo);
            }

        }
        return false;
    }

    //大工作空间打开本地地图
    // strModule 所在模块文件夹名称
    // bPrivate 是否在私人目录下（否则在Customer目录下）
    // bSymbolReplace 新地图符号库的导入是否采用覆盖模式（覆盖模式指遇到同名id处理方式是替换掉原来的符号）
    public boolean openMapName(String strMapName, Workspace desWorkspace,ReadableMap dicParam ) {

        if (desWorkspace == null || desWorkspace.getMaps().indexOf(strMapName) != -1) {
            return false;
        }

        boolean bPrivate = true;
        if (dicParam.hasKey("IsPrivate")){
            bPrivate = dicParam.getBoolean("IsPrivate");
        }
        boolean bSymbolReplace = true;
        if (dicParam.hasKey("IsReplaceSymbol")){
            bSymbolReplace = dicParam.getBoolean("IsReplaceSymbol");
        }

        String strModule = null;
        if (dicParam.hasKey("Module")){
            strModule = dicParam.getString("Module");
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

        String strMapXML = stringWithContentsOfFile(srcPathXML, encodingUTF8);
        strMapXML = modifyXML(strMapXML, arrAlian, arrReAlian);

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
                ArrayList<String> arrayList = importSymbolsFrom(markerLibrary.getRootGroup(), desMarkerGroup, true, bSymbolReplace);
                if (arrayList!=null){
                    for (int i=0;i<arrayList.size();i++){
                        String strReplace = arrayList.get(i);
                        String[] arrReplace = strReplace.split(":");
                        String strOld = "<sml:MarkerStyle>" + arrReplace[0] + "</sml:MarkerStyle>";
                        String strNew = "<sml:MarkerStyle>" + arrReplace[1] + "</sml:MarkerStyle>";
                        strMapXML = strMapXML.replace(strOld,strNew);
                    }

                }
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
                importSymbolsFrom(lineLibrary.getInlineMarkerLib().getRootGroup(), desInlineMarkerGroup, true, bSymbolReplace);
                ArrayList<String> arrayList = importSymbolsFrom(lineLibrary.getRootGroup(), desLineGroup, true, bSymbolReplace);
                if (arrayList!=null){
                    for (int i=0;i<arrayList.size();i++){
                        String strReplace = arrayList.get(i);
                        String[] arrReplace = strReplace.split(":");
                        String strOld = "<sml:LineStyle>" + arrReplace[0] + "</sml:LineStyle>";
                        String strNew = "<sml:LineStyle>" + arrReplace[1] + "</sml:LineStyle>";
                        strMapXML = strMapXML.replace(strOld,strNew);
                    }

                }
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
                importSymbolsFrom(fillLibrary.getInfillMarkerLib().getRootGroup(), desInfillMarkerGroup, true, bSymbolReplace);
                ArrayList<String> arrayList = importSymbolsFrom(fillLibrary.getRootGroup(), desFillGroup, true, bSymbolReplace);
                if (arrayList!=null){
                    for (int i=0;i<arrayList.size();i++){
                        String strReplace = arrayList.get(i);
                        String[] arrReplace = strReplace.split(":");
                        String strOld = "<sml:FillStyle>" + arrReplace[0] + "</sml:FillStyle>";
                        String strNew = "<sml:FillStyle>" + arrReplace[1] + "</sml:FillStyle>";
                        strMapXML = strMapXML.replace(strOld,strNew);
                    }

                }
            }
        }


//        String strMapXML = stringWithContentsOfFile(srcPathXML, encodingUTF8);
//        strMapXML = modifyXML(strMapXML, arrAlian, arrReAlian);

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

    public String importSymbolLibFile(String strFile ,String strModule,boolean bPrivate){
        String type = strFile.substring(strFile.lastIndexOf(".") + 1).toLowerCase();
        if (type.equals("bru") || type.equals("lsl") || type.equals("sym")) {
            File file = new File(strFile);
            if (!file.exists() || !file.isFile()) {
                return null;
            }
            String strUserName = null;
            if (bPrivate) {
                strUserName = getUserName();
                if (strUserName == null) {
                    return null;
                }
            } else {
                strUserName = "Customer";
            }
            String strRootPath = getRootPath();
            String strCustomer = strRootPath + "/" + strUserName + "/Data";
            String desResourceDir = strCustomer+ "/Symbol";
            if (strModule!=null && strModule.length()>0){
                desResourceDir = desResourceDir + "/" + strModule;
            }
            File fileResourceDir = new File(desResourceDir);
            if (!fileResourceDir.exists() || !fileResourceDir.isDirectory()) {
                fileResourceDir.mkdirs();
            }
            String[] arrFile = strFile.split("/");
            String strName = arrFile[arrFile.length - 1];
            String strTargetFile = desResourceDir + "/" + strName;
            strTargetFile = formateNoneExistFileName(strTargetFile,false);

            // 拷贝
            if (!copyFile(strFile, strTargetFile)) {
                return null;
            }else{
                strName = strTargetFile.substring( desResourceDir.length() + 1 );
                return strName;
            }
        } else {
            return null;
        }
    }

    public String saveSymbols(ArrayList<Integer> arrIds , SymbolType nType ,Resources resources,String strTargetName ,String strModule,boolean isprivate){

        if (arrIds==null || arrIds.size()==0 || resources==null || strTargetName==null || strTargetName.length()==0 ){
            return null;
        }
        String strUserName = null;
        if (isprivate) {
            strUserName = getUserName();
            if (strUserName == null) {
                return null;
            }
        } else {
            strUserName = "Customer";
        }
        String strRootPath = getRootPath();
        String strCustomer = strRootPath + "/" + strUserName + "/Data";
        String desResourceDir = strCustomer+ "/Symbol";
        if (strModule!=null && strModule.length()>0){
            desResourceDir = desResourceDir + "/" + strModule;
        }
        SymbolLibrary srcLib ;
        SymbolLibrary desLib ;
        String strDesFile = desResourceDir + "/" + strTargetName;

        switch (nType.value()){
//            case SymbolType.MARKER:{
            case 0:{
                srcLib = resources.getMarkerLibrary();
                desLib = new SymbolMarkerLibrary();
                strDesFile = strDesFile + ".sym";
            }
            break;

//            case SymbolType.LINE:{
            case 1:{
                srcLib = resources.getLineLibrary();
                desLib = new SymbolLineLibrary();
                strDesFile = strDesFile + ".lsl";
                SymbolLibrary srcInnerLib = ((SymbolLineLibrary)srcLib).getInlineMarkerLib();
                SymbolLibrary desInnerLib = ((SymbolLineLibrary)desLib).getInlineMarkerLib();
                importSymbolsFrom(srcInnerLib.getRootGroup(),desInnerLib.getRootGroup(),true,true);
            }
            break;

//            case SymbolType.FILL:{
            case 2:{
                srcLib = resources.getFillLibrary();
                desLib = new SymbolFillLibrary();
                strDesFile = strDesFile + ".bru";
                SymbolLibrary srcInnerLib = ((SymbolFillLibrary)srcLib).getInfillMarkerLib();
                SymbolLibrary desInnerLib = ((SymbolFillLibrary)desLib).getInfillMarkerLib();
                importSymbolsFrom(srcInnerLib.getRootGroup(),desInnerLib.getRootGroup(),true,true);
            }
            break;

            default:
                return null;

        }

        strDesFile = formateNoneExistFileName(strDesFile,false);

        for (int i=0;i<arrIds.size();i++){
            int nid = arrIds.get(i);
            if (srcLib.contains(nid)){
                Symbol sym = srcLib.findSymbol(nid);
                desLib.add(sym);
            }
        }

        if (desLib.saveAs(strDesFile)){
            return strDesFile;
        }else {
            return null;
        }
    }

    public ArrayList<String> addSymbolsFromFile(String strFile,Resources resources,String strGroupName,boolean bRepalceSymbol){

        File file = new File(strFile);
        if (!file.exists() || !file.isFile()) {
            return null;
        }
        SymbolLibrary lib = null;
        SymbolLibrary resLib = null;
        String type = strFile.substring(strFile.lastIndexOf(".") + 1).toLowerCase();
        if (type.equals("bru")) {
            lib = new SymbolFillLibrary();
            resLib = resources.getFillLibrary();
        } else if (type.equals("lsl")) {
            lib = new SymbolLineLibrary();
            resLib = resources.getLineLibrary();
        } else if (type.equals("sym")) {
            lib = new SymbolMarkerLibrary();
            resLib = resources.getMarkerLibrary();
        }
        if (lib == null) return null;

        lib.appendFromFile(strFile, bRepalceSymbol);

        SymbolGroup desGroup = null;
        if (strGroupName==null || strGroupName.length()==0 || resLib.getRootGroup().getName()==strGroupName){
            desGroup = resLib.getRootGroup();
        }else if (resLib.getRootGroup().getChildGroups().indexOf(strGroupName)!=-1){
            desGroup = resLib.getRootGroup().getChildGroups().get(strGroupName);
        }else{
            desGroup = resLib.getRootGroup().getChildGroups().create(strGroupName);
        }

        return importSymbolsFrom(lib.getRootGroup(),desGroup,true,bRepalceSymbol);
    }

    public boolean appendFromFile(Resources resources, String path, boolean isReplace) {
        try {
            File file = new File(path);
            if (!file.exists() || !file.isFile()) {
                return false;
            }
            SymbolLibrary lib = null;
            SymbolLibrary resLib = null;
            String type = path.substring(path.lastIndexOf(".") + 1).toLowerCase();
            if (type.equals("bru")) {
                lib = new SymbolFillLibrary();
                resLib = resources.getFillLibrary();
            } else if (type.equals("lsl")) {
                lib = new SymbolLineLibrary();
                resLib = resources.getLineLibrary();
            } else if (type.equals("sym")) {
                lib = new SymbolMarkerLibrary();
                resLib = resources.getMarkerLibrary();
            }
            if (lib == null) return false;
            boolean result = lib.appendFromFile(path, isReplace);
            if (result) {
                importSymbolsFrom(lib.getRootGroup(), resLib.getRootGroup(), true, isReplace);
            }
            return result;
        } catch (Exception e) {
            return false;
        }
    }



    public boolean copyDataset(String strSrcUDB, String strDesUDB) {

        boolean result = false;

        Workspace workspaceTemp = new Workspace();

        DatasourceConnectionInfo srcinfo = new DatasourceConnectionInfo();
        srcinfo.setServer(strSrcUDB);
        srcinfo.setEngineType(EngineType.UDB);
        srcinfo.setAlias("src");
        Datasource srcDs = workspaceTemp.getDatasources().open(srcinfo);
        if (srcDs != null) {
            DatasourceConnectionInfo desinfo = new DatasourceConnectionInfo();
            desinfo.setServer(strDesUDB);
            desinfo.setEngineType(EngineType.UDB);
            desinfo.setAlias("des");
            Datasource desDs = workspaceTemp.getDatasources().open(desinfo);
            if (desDs != null) {
                for (int i = 0; i < srcDs.getDatasets().getCount(); i++) {
                    Dataset dataset = srcDs.getDatasets().get(i);
                    String strDesName = dataset.getName();
                    int nAddNum = 1;
                    while (desDs.getDatasets().contains(strDesName)) {
                        strDesName = dataset.getName() + "_" + nAddNum;
                        nAddNum++;
                    }
                    desDs.copyDataset(dataset, strDesName, dataset.getEncodeType());
                }
                desDs.saveDatasource();
                result = true;
            }
            desinfo.dispose();
        }
        srcinfo.dispose();

        workspaceTemp.close();
        workspaceTemp.dispose();

        return result;
    }

    private ReadableMap getMapInfoFromJson(String jsonMap) {
        if (jsonMap == null) {
            return null;
        }
        JSONObject jsonObject = null;
        try {
            jsonObject = new JSONObject(jsonMap);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        String strMapName = jsonObject.optString("MapName");
        if (strMapName == null) {
            return null;
        }

       WritableMap mapInfo = Arguments.createMap();
        mapInfo.putString("MapName", strMapName);
        if (jsonObject.has("Module")) {
            mapInfo.putString("Module", jsonObject.optString("Module"));
        }
        if (jsonObject.has("IsPrivate")) {
            mapInfo.putBoolean("IsPrivate", jsonObject.optBoolean("IsPrivate"));
        }
        return mapInfo;

    }

    //
    // 以面对象region裁减地图map 并保存为 strResultName
    // 通过图层确定裁减数据集，支持矢量和本地删格数据集，layer可以不参加裁减（不参加，意思是在结果数据集中layer.dataset不变）但同一数据集的layer裁减参数一致（以第一个layer参数为准）
    // jsonParam ：
    //          LayerName 需裁减Layer名（实际为裁减Layer对应dataset，裁减结果为新数据集保留到dataset所在datasource，新地图中Layer指向新数据集）
    //          IsClipInRegion 裁减区域在面内还是面外
    //          IsErase 是否擦除模式
    //          IsExactClip 是否精确裁减（删格涂层才有该选项）
    //          DatasourceTarget
    //          DatasetTarget
    // Eg:
    //  @"[{\"LayerName\":\"%@\",\"IsClipInRegion\":false,\"IsErase\":false,\"IsExactClip\":true},\
    //     {\"LayerName\":\"%@\",\"DatasourceTarget\":\"%@\",\"IsErase\":false,\"IsExactClip\":true},\
    //     {\"LayerName\":\"%@\",\"IsExactClip\":false,\"DatasourceTarget\":\"%@\",\"DatasetTarget\":\"%@\"}]"
    //
    // 返回值说明：裁减完地图尝试以strResultName保存到map.workspace.maps中，若已存在同名则重命名为strResultName#1，把最终命名结果返回
    //
    public boolean clipMap(com.supermap.mapping.Map _srcMap, GeoRegion clipRegion, /*String jsonParam*/ReadableArray arrLayers, String[] strResultName) {

        try {
            if (_srcMap == null || _srcMap.getLayers().getCount() <= 0 || clipRegion == null || clipRegion.getBounds().isEmpty()) {
                return false;
            }

            ArrayList<Dataset> arrDatasetCliped = new ArrayList<Dataset>();
            ArrayList<Dataset> arrDatasetResult = new ArrayList<Dataset>();

            String strClipMapName = strResultName[0];
            com.supermap.mapping.Map _clipMap = null;
            if (strClipMapName != null) {
                int nAddNum = 1;
                while (_srcMap.getWorkspace().getMaps().indexOf(strClipMapName) != -1) {
                    strClipMapName = strResultName[0] + nAddNum;
                    nAddNum++;
                }

                _srcMap.getWorkspace().getMaps().add(strClipMapName, _srcMap.toXML());

                _clipMap = new com.supermap.mapping.Map(_srcMap.getWorkspace());
                _clipMap.open(strClipMapName);
                strResultName[0] = strClipMapName;
            }

//        JSONArray arrLayers;
//        try {
//            arrLayers = new JSONArray(jsonParam);
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }

            for (int i = 0; i < arrLayers.size(); i++) {
                ReadableMap dicLayer = arrLayers.getMap(i);
                // 图层名称
                String strLayerName = dicLayer.getString("LayerName");
                Layer layerTemp = _srcMap.getLayers().find(strLayerName);
                Dataset datasetTemp = layerTemp.getDataset();

                if (datasetTemp == null) {
                    //1.datasetTemp==nil
                    // layerGroup或其他没有dataset的情况
                    continue;
                }

                // 所在数据源

                int index = arrDatasetCliped.indexOf(datasetTemp);

                Dataset datasetResult = null;
                Datasource datasourceResult = null;

                if (index >= 0 && index < arrDatasetCliped.size()) {
                    //2.已经处理过的Dataset
                    // 说明：形同数据集裁减参数是一致的，否则只支持第一出线layer的裁减参数
                    datasetResult = arrDatasetResult.get(index);
                    datasourceResult = datasetResult.getDatasource();
                } else {
                    if (dicLayer.hasKey("DatasourceTarget") && dicLayer.getString("DatasourceTarget") != null) {
                        datasourceResult = _srcMap.getWorkspace().getDatasources().get(dicLayer.getString("DatasourceTarget"));
                        if (datasourceResult == null
                                || datasourceResult.getConnectionInfo().getEngineType() != EngineType.UDB) {
                            //没找到datasource 或 不是udb
                            continue;
                        }
                    } else {
                        datasourceResult = datasetTemp.getDatasource();
                    }

                    // 新dataset的名字

                    String strDatasetResultName;
                    if (dicLayer.hasKey("DatasetTarget") && dicLayer.getString("DatasetTarget") != null) {
                        strDatasetResultName = dicLayer.getString("DatasetTarget");
                    } else {
                        strDatasetResultName = datasetTemp.getName();
                    }

                    String strTempName = strDatasetResultName;
                    int nAddNum = 1;
                    while (datasourceResult.getDatasets().contains(strDatasetResultName)) {
                        strDatasetResultName = strTempName + "_" + nAddNum;
                        nAddNum++;
                    }

                    if (DatasetVector.class.isInstance(datasetTemp)) {
                        //3.datasetVector 有效参数：IsClipInRegion，IsErase
                        boolean bClipInRegion = true;
                        if (dicLayer.hasKey("IsClipInRegion")) {
                            bClipInRegion = dicLayer.getBoolean("IsClipInRegion");
                        }

                        boolean bErase = false;
                        if (dicLayer.hasKey("IsErase")) {
                            bErase = dicLayer.getBoolean("IsErase");
                        }

                        DatasetVectorInfo datasetResultInfo = new DatasetVectorInfo(strDatasetResultName, (DatasetVector) datasetTemp);
                        datasetResult = datasourceResult.getDatasets().create(datasetResultInfo);
                        if (datasetResult == null) {
                            // 创建失败
                            continue;
                        }

                        // 如果是面内裁减则region与clipRegion相同，否则clipRegion需要加上一个外包的矩形
                        GeoRegion region = new GeoRegion();
                        if (!bClipInRegion) {
                            Rectangle2D datasetBounds = datasetTemp.getBounds();
                            Point2D[] arrBounds = new Point2D[4];
                            arrBounds[0] = new Point2D( datasetBounds.getLeft(),datasetBounds.getTop() );
                            arrBounds[1] = new Point2D( datasetBounds.getLeft(),datasetBounds.getBottom() );
                            arrBounds[2] = new Point2D( datasetBounds.getRight(),datasetBounds.getBottom() );
                            arrBounds[3] = new Point2D( datasetBounds.getRight(),datasetBounds.getTop() );
                            Point2Ds bounds_point2d = new Point2Ds(arrBounds);
                            region.addPart(bounds_point2d);
                        }

                        for (int j = 0; j < clipRegion.getPartCount(); j++) {
                            Point2Ds partPoint2Ds = clipRegion.getPart(j);
                            region.addPart(partPoint2Ds);
                        }

                        boolean bResult = false;

                        OverlayAnalystParameter parame = new OverlayAnalystParameter();

                        FieldInfos fieldsinfos = ((DatasetVector) datasetTemp).getFieldInfos();
                        int nCount = fieldsinfos.getCount();
                        String[] arrFiels = new String[nCount];
                        for (int k = 0; k < nCount; k++) {
                            FieldInfo field = fieldsinfos.get(k);
                            arrFiels[k] = field.getName();
                        }
                        parame.setSourceRetainedFields(arrFiels);

                        Geometry[] arrRegionTemp = new Geometry[1];
                        arrRegionTemp[0] = region;

                        if (bErase) {

                            bResult = OverlayAnalyst.erase((DatasetVector) datasetTemp, arrRegionTemp, (DatasetVector) datasetResult, parame);

                        } else {

                            bResult = OverlayAnalyst.clip((DatasetVector) datasetTemp, arrRegionTemp, (DatasetVector) datasetResult, parame);

                        }

                        if (bResult == false) {
                            datasourceResult.getDatasets().delete(strDatasetResultName);
                            continue;
                        }

                    } else if (datasetTemp.getType() == DatasetType.GRID || datasetTemp.getType() == DatasetType.IMAGE) {
                        //4.datasetRaster 有效参数：IsClipInRegion，IsExactClip
                        boolean bClipInRegion = true;
                        if (dicLayer.hasKey("IsClipInRegion")) {
                            bClipInRegion = dicLayer.getBoolean("IsClipInRegion");
                        }

                        boolean bExactClip = false;
                        if (dicLayer.hasKey("IsExactClip")) {
                            bExactClip = dicLayer.getBoolean("IsExactClip");
                        }

                        datasetResult = RasterClip.clip(datasetTemp, clipRegion, bClipInRegion, bExactClip, datasourceResult, strDatasetResultName);
                        if (datasetResult == null) {
                            // 裁减失败
                            continue;
                        }

                    } else {

                        continue;

                    }

                    arrDatasetCliped.add(datasetTemp);
                    arrDatasetResult.add(datasetResult);

                }

                if (_clipMap != null) {
                    //5.替换LayerXML
                    Layer layerResult = _clipMap.getLayers().find(strLayerName);
                    String strXML = layerResult.toXML();

                    if(layerResult.getTheme()!=null){
                        // 专题图中某些字段不规范需要处理
                        String[] arrStrTemp = strXML.split("<sml:FieldExpression>");
                        String strTemp = arrStrTemp[arrStrTemp.length-1];
                        String strExpressionOld = strTemp.split("</sml:FieldExpression>")[0];
                        String strNameOld = datasetTemp.getName() + ".";
                        String strNameNew = datasetResult.getName() + ".";
                        String strExpressionNew = strExpressionOld.replace(strNameOld,strNameNew);
                        String strFieldOld = "<sml:FieldExpression>" + strExpressionOld + "</sml:FieldExpression>";
                        String strFieldNew = "<sml:FieldExpression>" + strExpressionNew + "</sml:FieldExpression>";
                        strXML = strXML.replace(strFieldOld, strFieldNew);
                    }


                    String strDatasourceOld = "<sml:DataSourceAlias>" + datasetTemp.getDatasource().getAlias() + "</sml:DataSourceAlias>";
                    String strDatasourceNew = "<sml:DataSourceAlias>" + datasourceResult.getAlias() + "</sml:DataSourceAlias>";

                    strXML = strXML.replace(strDatasourceOld, strDatasourceNew);

                    String strDatasetOld = "<sml:DatasetName>" + datasetTemp.getName() + "</sml:DatasetName>";
                    String strDatasetNew = "<sml:DatasetName>" + datasetResult.getName() + "</sml:DatasetName>";

                    strXML = strXML.replace(strDatasetOld, strDatasetNew);

                    if (layerResult.getParentGroup() == null) {
                        //直接在layers下
                        int nLayerPos = _clipMap.getLayers().indexOf(strLayerName);
                        _clipMap.getLayers().remove(nLayerPos);
                        _clipMap.getLayers().insert(nLayerPos, strXML);

                    } else {
                        //layergroup下 xml删除within字段 先加入layers再移动到layergroup下
                        String strWithinGroup = "<sml:WithinLayerGroup>" + layerResult.getParentGroup().getName() + "</sml:WithinLayerGroup>";//layerResult.parentGroup.name];
                        strXML = strXML.replace(strWithinGroup, "");

                        LayerGroup layerGroup = layerResult.getParentGroup();
                        int nLayerPos = layerGroup.indexOf(layerResult);
                        layerGroup.remove(layerResult);

                        Layer newLayerResult = _clipMap.getLayers().insert(0, strXML);
                        layerGroup.insert(nLayerPos, newLayerResult);
                    }

                }

                datasourceResult.saveDatasource();

            }

            if (_clipMap != null) {
                try {
                    _clipMap.save();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                _clipMap.close();
                _clipMap.dispose();
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }


    // 从Exp的map里 拷贝所有layer到当前map的一个layerGroup下，layerGroup.name为被拷贝地图名
    public boolean addLayersFromMap(String srcMapName, com.supermap.mapping.Map desMap ,ReadableMap dicParam) {

        if (srcMapName.equals(desMap.getName())) {
            return false;
        }
        boolean bResult = false;
//        String strTempLib = getRootPath() + "/Customer/Resources/__Temp__" + srcMapName;
//
//        String strMarker = strTempLib + ".sym";
//        String strLine = strTempLib + ".lsl";
//        String strFill = strTempLib + ".bru";
//
//        desMap.getWorkspace().getResources().getMarkerLibrary().saveAs(strMarker);
//        desMap.getWorkspace().getResources().getLineLibrary().saveAs(strLine);
//        desMap.getWorkspace().getResources().getFillLibrary().saveAs(strFill);

        WritableMap dic = Arguments.createMap();
        dic.merge(dicParam);
        dic.putBoolean("IsReplaceSymbol",false);

        if (openMapName(srcMapName, desMap.getWorkspace(), dic)) {

            desMap.addLayersFromMap(srcMapName, true);
            desMap.getWorkspace().getMaps().remove(srcMapName);
            bResult = true;

        }

//        desMap.getWorkspace().getResources().getMarkerLibrary().clear();
//        desMap.getWorkspace().getResources().getMarkerLibrary().appendFromFile(strMarker, true);
//        File markerFile = new File(strMarker);
//        markerFile.delete();
//
//        desMap.getWorkspace().getResources().getLineLibrary().clear();
//        desMap.getWorkspace().getResources().getLineLibrary().appendFromFile(strLine, true);
//        File lineFile = new File(strLine);
//        lineFile.delete();
//
//        desMap.getWorkspace().getResources().getFillLibrary().clear();
//        desMap.getWorkspace().getResources().getFillLibrary().appendFromFile(strFill, true);
//        File fillFile = new File(strFill);
//        fillFile.delete();

        return bResult;
    }

    // 从Exp1的map里 拷贝所有layer到Exp2的map的一个layerGroup下，layerGroup.name为被拷贝地图名
    public boolean addLayersFromMapJson(String jsonSrcMap, String jsonDesMap) {

        if (jsonSrcMap == null || jsonDesMap == null) {
            return false;
        }
        // 先把两个map在同一工作空间中打开 [desMap addLayersFrom:srcmap] save到des目录下desMap

        // 源Map打开信息字典
        ReadableMap srcInfo = getMapInfoFromJson(jsonSrcMap);
        ReadableMap desInfo = getMapInfoFromJson(jsonDesMap);
        if (srcInfo == null || desInfo == null) {
            return false;
        }

        if ( !srcInfo.hasKey("MapName") || !desInfo.hasKey("MapName")){
            return false;
        }

        String strSrcName = srcInfo.getString("MapName");
        String strSrcModule = null;
        if (srcInfo.hasKey("Module")){
            strSrcModule  = srcInfo.getString("Module");
        }
        boolean isSrcPrivate = false;
        if (srcInfo.hasKey("IsPrivate")) {
            isSrcPrivate = srcInfo.getBoolean("IsPrivate");
//            isSrcPrivate=Boolean.valueOf(srcInfo.get("IsPrivate"));
        }

        String strDesName = desInfo.getString("MapName");
        String strDesModule = null;
        if (desInfo.hasKey("Module")){
            strDesModule = desInfo.getString("Module");
        }
        boolean isDesPrivate = false;
        if (desInfo.hasKey("IsPrivate")) {
            isDesPrivate = desInfo.getBoolean("IsPrivate");
        }

        Boolean bSrcRename = false;//同名Map需要srcMap打开后重命名，同一Map不能合并
        if (strSrcName.equals(strDesName)) {
            Boolean bSame = true;
            if (strSrcModule == null) {
                if (strDesModule != null) {
                    bSame = false;
                }
            } else if (strDesModule == null) {
                bSame = false;
            } else {
                if (!strSrcModule.equals(strDesModule)) {
                    bSame = false;
                }
            }
            if (isSrcPrivate != isDesPrivate) {
                bSame = false;
            }

            if (bSame) {
                return false;
            }

            // 同名处理
            bSrcRename = true;

        }


        Boolean bResult = false;
        Workspace workspace = new Workspace();
        if (openMap(srcInfo, workspace)) {
            if (bSrcRename) {
                // 替换的命名
                String strSrcReplace = strSrcName + "#1";
                // 重命名Map：1.Map打开toXML 2.maps删除源map名 3.maps从XML添加新map名
                com.supermap.mapping.Map mapTemp = new com.supermap.mapping.Map(workspace);
                mapTemp.open(strSrcName);
                String strXMLTemp = mapTemp.toXML();
                mapTemp.close();
                mapTemp.dispose();
                workspace.getMaps().remove(strSrcName);
                workspace.getMaps().add(strSrcReplace, strXMLTemp);

                // 重命名Resources中symbolGroup
                // Marker
                {
                    SymbolGroup group = workspace.getResources().getMarkerLibrary().getRootGroup().getChildGroups().get(strSrcName);
                    group.setName(strSrcReplace);

                }
                // Line
                {
                    SymbolGroup group = workspace.getResources().getLineLibrary().getRootGroup().getChildGroups().get(strSrcName);
                    group.setName(strSrcReplace);

                }
                // Fill
                {
                    SymbolGroup group = workspace.getResources().getFillLibrary().getRootGroup().getChildGroups().get(strSrcName);
                    group.setName(strSrcReplace);

                }


                strSrcName = strSrcReplace;
            }

            if (openMap(desInfo, workspace)) {
                com.supermap.mapping.Map map = new com.supermap.mapping.Map(workspace);

                Map<String, String> dicAddition = null;
                {
                    String strUserName;
                    if (!isDesPrivate) {
                        strUserName = "Customer";
                    } else {
                        strUserName = getUserName();
                    }
                    String strRootPath = getRootPath();
                    String strCustomer = strRootPath + "/" + strUserName + "/Data";
                    String strPathEXP;
                    if (strDesModule != null && !strDesModule.equals("")) {
                        strPathEXP = strCustomer + "/Map/" + strDesModule + "/" + strDesName + ".exp";
                    } else {
                        strPathEXP = strCustomer + "/Map/" + strDesName + ".exp";
                    }

                    String strMapEXP = stringWithContentsOfFile(strPathEXP, encodingUTF8);
                    String templateStr = null;
                    try {
                        JSONObject jsonObject = new JSONObject(strMapEXP);
                        templateStr = jsonObject.optString("Template", null);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    if (templateStr != null) {
                        dicAddition = new HashMap<>();
                        dicAddition.put("Template", templateStr);
                    }
                }

                if (map.open(strDesName) &&
                        map.addLayersFromMap(strSrcName, true)) {

                    try {
                        map.save();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    map.close();
                    map.dispose();
                    String strDesMap = saveMapName(strDesName, workspace, strDesModule, dicAddition, false, true, isDesPrivate);

                    if (strDesMap != null) {
                        bResult = true;
                    }
                }
            }
        }

        workspace.close();
        workspace.dispose();
        return true;

    }

}
