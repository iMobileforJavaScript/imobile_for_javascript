package com.supermap.smNative;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Resources;
import com.supermap.data.Symbol;
import com.supermap.data.SymbolGroup;
import com.supermap.data.SymbolGroups;
import com.supermap.data.SymbolLibrary;

public class SMSymbol {

    public static WritableArray getSymbolGroups(Resources resources, String type, String path) {
        SymbolLibrary symbolLibrary;
        WritableArray groupArr = Arguments.createArray();
        SymbolGroup group;

        if (type.equals("") && path.equals("")) {
            SymbolGroup rootGroup = resources.getFillLibrary().getRootGroup();
            WritableMap fillGroup = Arguments.createMap();
            fillGroup.putString("name", rootGroup.getName());
            fillGroup.putInt("count", rootGroup.getCount());
            fillGroup.putArray("childGroups", findAllSymbolGroups(rootGroup, type, path));
            fillGroup.putString("path", rootGroup.getName());
            fillGroup.putString("type", "fill");
            groupArr.pushMap(fillGroup);

            rootGroup = resources.getLineLibrary().getRootGroup();
            WritableMap lineGroup = Arguments.createMap();
            lineGroup.putString("name", rootGroup.getName());
            lineGroup.putInt("count", rootGroup.getCount());
            lineGroup.putArray("childGroups", findAllSymbolGroups(rootGroup, type, path));
            lineGroup.putString("path", rootGroup.getName());
            lineGroup.putString("type", "line");
            groupArr.pushMap(lineGroup);

            rootGroup = resources.getMarkerLibrary().getRootGroup();
            WritableMap markerGroup = Arguments.createMap();
            markerGroup.putString("name", rootGroup.getName());
            markerGroup.putInt("count", rootGroup.getCount());
            markerGroup.putArray("childGroups", findAllSymbolGroups(rootGroup, type, path));
            markerGroup.putString("path", rootGroup.getName());
            markerGroup.putString("type", "marker");
            groupArr.pushMap(markerGroup);
        } else if (type.equals("") && !path.equals("")) {
            groupArr.pushArray(findAllSymbolGroups(resources.getFillLibrary().getRootGroup(), type, path));
            groupArr.pushArray(findAllSymbolGroups(resources.getLineLibrary().getRootGroup(), type, path));
            groupArr.pushArray(findAllSymbolGroups(resources.getMarkerLibrary().getRootGroup(), type, path));
        } else if (!type.equals("")) {
            if (type.equals("fill")) {
                symbolLibrary = resources.getFillLibrary();
            } else if (type.equals("line")) {
                symbolLibrary = resources.getLineLibrary();
            } else {
                symbolLibrary = resources.getMarkerLibrary();
            }
            String _path = path.equals("") ? symbolLibrary.getRootGroup().getName() : path;

            if (path.equals("")) {
                group = symbolLibrary.getRootGroup();
                _path = group.getName();
            } else {
                group = findSymbolGroups(resources, type, _path);
                _path = group.getName();
            }

            WritableMap groupInfo = Arguments.createMap();
            groupInfo.putString("name", group.getName());
            groupInfo.putInt("count", group.getCount());
            groupInfo.putArray("childGroups", findAllSymbolGroups(group, type, _path));
            groupInfo.putString("path", _path);
            groupInfo.putString("type", "line");
            groupArr.pushMap(groupInfo);
        }

        return groupArr;
    }

    public static WritableArray findAllSymbolGroups(SymbolGroup symbolGroup, String type, String path) {
        WritableArray groupArr = Arguments.createArray();
        SymbolGroups groups = symbolGroup.getChildGroups();

        for (int i = 0; i < groups.getCount(); i++) {
            SymbolGroup group = groups.get(i);
            WritableArray childGroupArr = Arguments.createArray();
            if (group.getChildGroups().getCount() > 0) {
                childGroupArr = findAllSymbolGroups(group, type, path + '/' + group.getName());
            }
            WritableMap groupInfo = Arguments.createMap();
            groupInfo.putString("name", group.getName());
            groupInfo.putInt("count", group.getCount());
            groupInfo.putArray("childGroups", childGroupArr);
            groupInfo.putString("path", path + '/' + group.getName());
            groupInfo.putString("type", type);

            groupArr.pushMap(groupInfo);
        }
        return groupArr;
    }

    public static SymbolGroup findSymbolGroups(Resources resources, String type, String path) {

        if (type.equals("") || path.equals("")) return null;

        SymbolGroup group;
        String[] pathParams = path.split("/");

        if (type.equals("fill")) {
            group = resources.getFillLibrary().getRootGroup();
        } else if (type.equals("line")) {
            group = resources.getLineLibrary().getRootGroup();
        } else {
            group = resources.getMarkerLibrary().getRootGroup();
        }

        if (pathParams.length > 1) {
            for (int i = 1; i < pathParams.length; i++) {
                group = group.getChildGroups().get(pathParams[i]);
            }
        }
        return group;
    }

    public static WritableArray findSymbolsByGroups(Resources resources, String type, String path) {

        if (type.equals("") || path.equals("")) return null;

        WritableArray symbols = Arguments.createArray();
        SymbolGroup group = findSymbolGroups(resources, type, path);

        for (int i = 0; i< group.getCount(); i++) {
            Symbol symbol = group.get(i);
            WritableMap symbolInfo = Arguments.createMap();

            symbolInfo.putString("groupPath", path);
            symbolInfo.putString("name", symbol.getName());
            symbolInfo.putInt("id", symbol.getID());
            symbolInfo.putString("type", type);

            symbols.pushMap(symbolInfo);
        }
        return symbols;
    }
}
