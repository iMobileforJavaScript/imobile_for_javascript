package com.supermap.smNative;

import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.EngineType;
import com.supermap.data.Enum;

import java.util.Map;

/**
 * @Author: shanglongyang
 * Date:        2018/12/10
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class SMDatasource {
    public static DatasourceConnectionInfo convertDicToInfo(Map data) {
        try {
            DatasourceConnectionInfo info = new DatasourceConnectionInfo();
            if (data.containsKey("alias")){
                String alias = data.get("alias").toString();
                info.setAlias(alias);
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

            return info;
        } catch (Exception e) {
            throw e;
        }
    }
}
 