package com.supermap.smNative;

import com.facebook.react.bridge.ReadableArray;
import com.supermap.RNUtils.FileUtil;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EngineType;
import com.supermap.data.Enum;
import com.supermap.data.Workspace;
import com.supermap.data.WorkspaceConnectionInfo;
import com.supermap.data.WorkspaceType;
import com.supermap.data.WorkspaceVersion;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.data.DatasetType;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

    public boolean openWorkspace(Map data) {
        try {
            boolean result = true;
            Workspace newWS = null;

            Workspace _workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            if (_workspace!= null && _workspace.getCaption().equals("UntitledWorkspace")) {
                newWS = new Workspace();
                SMap.getInstance().getSmMapWC().setWorkspace(newWS);
            }
            if (data != null && data.get("server") != null && !SMap.getInstance().getSmMapWC().getWorkspace().getConnectionInfo().getServer().equals(data.get("server"))) {
                WorkspaceConnectionInfo info = setWorkspaceConnectionInfo(data, null);

                result = SMap.getInstance().getSmMapWC().getWorkspace().open(info);
                info.dispose();
                SMap.getInstance().getSmMapWC().getMapControl().getMap().setWorkspace(SMap.getInstance().getSmMapWC().getWorkspace());
            }

            // 先设置在释放
            if (_workspace != null && _workspace.getCaption().equals("UntitledWorkspace")) {
                _workspace.dispose();
                setWorkspace(newWS);
            }
            return result;
        } catch (Exception e) {
            throw e;
        }
    }

    public Datasource openDatasource(Map data) {
        try {
            DatasourceConnectionInfo info = new DatasourceConnectionInfo();
            Datasource ds = data.get("alias") != null ? SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().get((String)data.get("alias")) : null;
            Boolean isOpen = ds != null && data.get("server") != null && ds.getConnectionInfo().getServer().equals(data.get("server")) && ds.isOpened();
            Datasource dataSource = isOpen ? ds : null;
            if (!isOpen) {
                if (data.containsKey("alias")){
                    String alias = data.get("alias").toString();
                    info.setAlias(alias);

//                    if (this.workspace.getDatasources().indexOf(alias) != -1) {
//                        dataSource = this.workspace.getDatasources().get(alias);
//                        info.dispose();
//
//                        return dataSource;
//                    }
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
                DatasetVectorInfo info = new DatasetVectorInfo(dsAvailableName, (DatasetType)Enum.parse(DatasetType.class, datasetType));
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

    private String formateNoneExistDatasourceAlian(String alian) {
        String resultAlian = alian;
        int nAddNumber = 1;
        while (workspace.getDatasources().indexOf(resultAlian) != -1) {
            resultAlian = alian + "#"+nAddNumber;
            nAddNumber++;
        }
        return resultAlian;
    }

    private String formateNoneExistMapName(String name) {
        String resultName = name;
        int nAddNumber = 1;
        while (workspace.getMaps().indexOf(resultName) != -1) {
            resultName = name + "#"+nAddNumber;
            nAddNumber++;
        }
        return resultName;
    }

    private String modifyXML(String strXML, List<String> arrAlian, List<String> arrNewAlian){
        // 倒着替换 不然会把先前替换过的名字再次替换出错
        String strResult = strXML;
        for (int i = arrAlian.size() - 1; i >= 0; i--) {
            String strAlian = arrAlian.get(i);
            String strNewAlian = arrNewAlian.get(i);
            String strSrc = "<sml:DataSourceAlias>%@</sml:DataSourceAlias>" + strAlian;
            String strReplace = "<sml:DataSourceAlias>%@</sml:DataSourceAlias>" + strNewAlian;
            strResult = strResult.replaceAll(strSrc, strReplace);
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
                strTargetAlian = formateNoneExistDatasourceAlian(strTargetAlian);
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
                    strTargetAlian = formateNoneExistDatasourceAlian(strTargetAlian);
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

    public boolean exportMapNames (ReadableArray arrMapNames , String strFileName , boolean isFileReplace ){
        Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
        if (SMap.getInstance().getSmMapWC().getWorkspace()==null || strFileName==null || strFileName.length()==0 || arrMapNames==null || arrMapNames.size()==0 ||
            workspace.getConnectionInfo().getServer().equalsIgnoreCase(strFileName)){
            return false;
        }
        
        WorkspaceType workspaceType = WorkspaceType.DEFAULT;
        String strWorkspaceSuffix ;
        if (strFileName.endsWith("sxw")){
            workspaceType = WorkspaceType.DEFAULT;
            strWorkspaceSuffix = "sxw";
        }else if (strFileName.endsWith("smw")){
            workspaceType = WorkspaceType.SMW;
            strWorkspaceSuffix = "smw";
        }else if (strFileName.endsWith("sxwu")){
            workspaceType = WorkspaceType.SXWU;
            strWorkspaceSuffix = "sxwu";
        }else if (strFileName.endsWith("smwu")){
            workspaceType = WorkspaceType.SMWU;
            strWorkspaceSuffix = "smwu";
        }else {
            return false;
        }
        
        //建目录
        //String[] desFileNames = strFileName.split("/");
        //String desWorkspaceName = desFileNames[desFileNames.length-1];
        String desWorkspaceName = strFileName.substring(strFileName.lastIndexOf("/")+1);
        String desDir = strFileName.substring(0, strFileName.length()-desWorkspaceName.length() );
        boolean bNewDir = false;
        //WritableArray arrProtectedFile = Arguments.createArray();
        ArrayList<String> arrProtectedFileNames = new ArrayList<String>();
        
        File desDirFile = new File(desDir);
        if ( desDirFile.exists() &&  desDirFile.isDirectory() ){
            if (isFileReplace){
                Datasources srcDatasources = workspace.getDatasources();
                for (int i=0; i<srcDatasources.getCount(); i++) {
                    Datasource srcdatasource = srcDatasources.get(i);
                    DatasourceConnectionInfo datasourceInfo = srcdatasource.getConnectionInfo();
                    if (datasourceInfo.getEngineType() == EngineType.UDB
                        || datasourceInfo.getEngineType() == EngineType.IMAGEPLUGINS) {
                        
                        //只要名字
                        String  fullName = datasourceInfo.getServer();
                        String  fatherDirName = fullName.substring(0, fullName.lastIndexOf("/"));
                        
                        if (fatherDirName.equalsIgnoreCase(desDir)) {
                            //同级目录下的才会被替换
                            //arrProtectedFile.pushString(fullName);
                            arrProtectedFileNames.add(fullName);
                        }
                    }
                }
            }
            
            bNewDir = false;
        }else{
            if(!desDirFile.mkdirs()){
                return false;
            }
            bNewDir = true;
        }
        
        //文件名
        File desWorkspaceFile = new File(strFileName);
        if ( desWorkspaceFile.exists() && desWorkspaceFile.isFile() ) {
            if(isFileReplace){
                desWorkspaceFile.delete();
            }else{
                strFileName = formateNoneExistFileName(strFileName,false);
            }
        }
        
        Workspace workspaceDes = new Workspace();
        com.supermap.mapping.Map mapExport = new com.supermap.mapping.Map();
        mapExport.setWorkspace(workspace);
        
        ArrayList<Datasource> arrDatasources = new ArrayList<Datasource>();
        
        for (int i=0;i<arrMapNames.size();i++){
            String mapName = arrMapNames.getString(i);
            if (workspace.getMaps().indexOf(mapName)!=-1){
                // 打开map
                mapExport.open(mapName);
                // 不重复的datasource保存
                Layers exportLayes = mapExport.getLayers();
                for (int j=0; j<exportLayes.getCount(); j++) {
                    Datasource datasource = exportLayes.get(j).getDataset().getDatasource();
                    if (!arrDatasources.contains(datasource)) {
                        arrDatasources.add(datasource);
                    }
                }
                String strMapXML = mapExport.toXML();
                workspaceDes.getMaps().add(mapName,strMapXML);
                
                mapExport.close();
            }
        }
        
        
        // 导出datasource
        for (int i=0; i<arrDatasources.size(); i++) {
            Datasource datasource = arrDatasources.get(i);
            // 文件拷贝
            DatasourceConnectionInfo srcInfo = datasource.getConnectionInfo();
            String strSrcServer = srcInfo.getServer();
            EngineType engineType = srcInfo.getEngineType();
            String strTargetServer = new String(strSrcServer);
            
            if (engineType==EngineType.UDB || engineType==EngineType.IMAGEPLUGINS){
                if ( !isDatasourceFileExist(strSrcServer,engineType==EngineType.UDB) ){
                    continue;
                }
                
                String strlastname = strSrcServer.substring( strSrcServer.lastIndexOf("/")+1 );
                // 导入工作空间名
                strTargetServer = desDir+strlastname;
                
                if (engineType==EngineType.UDB){
                    
                    String strSrcBase = strSrcServer.substring(0,strSrcServer.length()-4);
                    String strTargetBase = strTargetServer.substring(0,strTargetServer.length()-4);
                    if (!bNewDir) {
                        // 检查重复
                        if (arrProtectedFileNames.contains(strTargetServer)) {
                            continue;
                        }
                        boolean bExist = false;
                        File targetFileUDB = new File(strTargetBase+".udb");
                        File targetFileUDD = new File(strTargetBase+".udd");
                        if (targetFileUDB.exists() && targetFileUDB.isFile()){
                            bExist = true;
                        }else{
                            if (targetFileUDD.exists() && targetFileUDD.isFile()){
                                bExist = true;
                            }
                        }
                        //存在同名文件
                        if (bExist){
                            if (isFileReplace) {
                                //覆盖模式
                                targetFileUDB.delete();
                                targetFileUDD.delete();
                            }else{
                                //重名文件
                                strTargetServer = formateNoneExistFileName(strTargetServer,false);
                                strTargetBase = strTargetServer.substring(0,strTargetServer.length()-4);
                            }//rep
                        }
                        
                        
                    }//!New
                    
                    // 拷贝
                    if (!copyFile(strSrcBase+".udb",strTargetBase+".udb")){
                        continue;
                    }
                    if (!copyFile(strSrcBase+".udd",strTargetBase+".udd")){
                        continue;
                    }
                    
                }else{
                    
                    if (!bNewDir) {
                        // 检查重复
                        if (arrProtectedFileNames.contains(strTargetServer)) {
                            continue;
                        }
                        File targetFile = new File(strTargetServer);
                        if (targetFile.exists() && targetFile.isFile()){
                            //存在同名文件
                            if (isFileReplace) {
                                //覆盖模式
                                targetFile.delete();
                            }else{
                                //重名文件
                                strTargetServer = formateNoneExistFileName(strTargetServer,false);
                            }//rep
                        }
                        
                    }//!New
                    
                    // 拷贝
                    if (!copyFile(strSrcServer,strTargetServer)){
                        continue;
                    }
                    
                }//udb
                
            }
            
            DatasourceConnectionInfo desInfo = new DatasourceConnectionInfo();
            desInfo.setServer( strTargetServer );
            desInfo.setDriver( srcInfo.getDriver() );
            desInfo.setAlias( srcInfo.getAlias() );
            desInfo.setEngineType(engineType);
            desInfo.setUser(srcInfo.getUser());
            desInfo.setPassword( srcInfo.getPassword() );
            
            workspaceDes.getDatasources().open(desInfo);
            
            
            
        }
        
        // symbol lib
        String serverResourceBase = strFileName.substring(0,strFileName.lastIndexOf("."));
        String strMarkerPath = serverResourceBase + ".sym";
        String strLinePath = serverResourceBase + ".lsl";
        String strFillPath = serverResourceBase + ".bru";
        if (workspaceType!=WorkspaceType.SXWU) {
            //重命名
            strMarkerPath = formateNoneExistFileName(strMarkerPath,false);
            strLinePath = formateNoneExistFileName(strLinePath,false);
            strFillPath = formateNoneExistFileName(strFillPath,false);
        }
        
        workspace.getResources().getMarkerLibrary().saveAs(strMarkerPath);
        workspace.getResources().getLineLibrary().saveAs(strLinePath);
        workspace.getResources().getFillLibrary().saveAs(strFillPath);
        
        workspaceDes.getResources().getMarkerLibrary().appendFromFile(strMarkerPath,true);
        workspaceDes.getResources().getLineLibrary().appendFromFile(strLinePath,true);
        workspaceDes.getResources().getFillLibrary().appendFromFile(strFillPath,true);
        
        if (workspaceType!=WorkspaceType.SXWU) {
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
        }catch (Exception e) {}
        
        workspaceDes.close();
        
        return true;
        
    }
    
    protected String formateNoneExistFileName(String strOrg,boolean isDir){
        String strName = strOrg;
        String strSuffix = "";
        if (!isDir){
            int index = strOrg.lastIndexOf(".");
            strName = strOrg.substring(0,index);
            strSuffix = strOrg.substring(index);
        }else{
            strName = strOrg.substring(0,strOrg.length()-1);
            strSuffix = "/";
        }
        String result = strOrg;
        int nAddNum = 1;
        while (true){
            File fileTemp = new File(result);
            if ( !fileTemp.exists() ){
                return result;
            }else if (isDir!=fileTemp.isDirectory()){
                return result;
            }else {
                result = strName+"#"+nAddNum+strSuffix;
                nAddNum++;
            }
        }
    }
    
    
    protected boolean isDatasourceFileExist(String strpath ,boolean isUDB){
        if (isUDB){
            return isUDBFileExist(strpath);
        }else{
            File datasoueceFile = new File(strpath);
            if ( !datasoueceFile.exists() || !datasoueceFile.isFile() ){
                return false;
            }else {
                return  true;
            }
        }
    }
    
    protected  boolean isUDBFileExist(String strpath){
        if (!strpath.endsWith(".udb")){
            return false;
        }
        File udbFile = new File(strpath);
        if( !udbFile.exists() || !udbFile.isFile() ){
            return false;
        }
        String strBase = strpath.substring(0,strpath.length()-4);
        File uddFile = new File(strBase+".udd");
        if ( !uddFile.exists() || !uddFile.isFile() ){
            return false;
        }else {
            return  true;
        }
    }
    
    protected boolean copyFile( String oldPath , String newPath){
        
        File oldfile = new File(oldPath);
        File newfile = new File(newPath);
        if (oldfile.exists()) {
            if (newfile.exists()) {
                newfile.delete();
            }
            
            try{
                newfile.createNewFile();
                FileInputStream input = new FileInputStream(oldPath);
                BufferedInputStream inBuff = new BufferedInputStream(input);
                FileOutputStream output = new FileOutputStream(newPath);
                BufferedOutputStream outBuff = new BufferedOutputStream(output);
                
                byte[] b = new byte[1024*5];
                int len;
                while ( (len = inBuff.read(b)) != -1 ){
                    outBuff.write(b,0,len);
                }
                outBuff.flush();
                
                inBuff.close();
                outBuff.close();
                output.close();
                input.close();
            }catch (IOException e){
                
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
