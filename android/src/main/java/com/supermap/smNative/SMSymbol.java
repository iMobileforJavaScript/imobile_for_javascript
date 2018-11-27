package com.supermap.smNative;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.DataUtil;
import com.supermap.data.Resources;
import com.supermap.data.Symbol;
import com.supermap.data.SymbolGroup;
import com.supermap.data.SymbolGroups;
import com.supermap.data.SymbolLibrary;

import java.util.ArrayList;
import java.util.List;

public class SMSymbol {

    public static WritableArray getSymbolGroups(Resources resources, String type, String path) {
        SymbolLibrary symbolLibrary;
        WritableArray groupArr = Arguments.createArray();
        SymbolGroup group;

        if (type.equals("") && path.equals("")) {
            SymbolGroup rootGroup = resources.getFillLibrary().getRootGroup();
            rootGroup = resources.getMarkerLibrary().getRootGroup();
            WritableMap markerGroup = Arguments.createMap();
            markerGroup.putString("name", "点符号库");
            markerGroup.putInt("count", rootGroup.getCount());
            markerGroup.putArray("childGroups", findAllSymbolGroups(rootGroup, "marker", path));
            markerGroup.putString("path", rootGroup.getName());
            markerGroup.putString("type", "marker");
            groupArr.pushMap(markerGroup);

            rootGroup = resources.getLineLibrary().getRootGroup();
            WritableMap lineGroup = Arguments.createMap();
            lineGroup.putString("name", "线型符号库");
            lineGroup.putInt("count", rootGroup.getCount());
            lineGroup.putArray("childGroups", findAllSymbolGroups(rootGroup, "line", path));
            lineGroup.putString("path", rootGroup.getName());
            lineGroup.putString("type", "line");
            groupArr.pushMap(lineGroup);

            WritableMap fillGroup = Arguments.createMap();
            fillGroup.putString("name", "填充符号库");
            fillGroup.putInt("count", rootGroup.getCount());
            fillGroup.putArray("childGroups", findAllSymbolGroups(rootGroup, "fill", path));
            fillGroup.putString("path", rootGroup.getName());
            fillGroup.putString("type", "fill");
            groupArr.pushMap(fillGroup);
        } else if (type.equals("") && !path.equals("")) {
            groupArr.pushArray(findAllSymbolGroups(resources.getMarkerLibrary().getRootGroup(), type, path));
            groupArr.pushArray(findAllSymbolGroups(resources.getLineLibrary().getRootGroup(), type, path));
            groupArr.pushArray(findAllSymbolGroups(resources.getFillLibrary().getRootGroup(), type, path));
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
            groupInfo.putString("type", type);
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

    public static List<Symbol> findSymbolsByIDs(Resources resources, String type, List IDs) {
        List<Symbol> symbols = new ArrayList<>();

        if (IDs.isEmpty()) {
            return symbols;
        }

        SymbolLibrary lib;
        if (type.equals("fill")) {
            lib = resources.getFillLibrary();
        } else if (type.equals("line")) {
            lib = resources.getLineLibrary();
        } else {
            lib = resources.getMarkerLibrary();
        }

        for (int i = 0; i < IDs.size(); i++) {
            Symbol symbol;
            Object data = IDs.get(i);
            int id;
            if (DataUtil.getDataType(data).equals("Double")) {
                id = ((Double) data).intValue();
            } else {
                id = (Integer) data;
            }
            if (type.equals("")) {
                symbol = findSymbolsByID(resources, id);
            } else {
                symbol = lib.findSymbol(id);
            }
            if (symbol != null) {
                symbols.add(symbol);
            }
        }

        return symbols;
    }

  public static Symbol findSymbolsByID(Resources resources, int ID) {
        try {
            Symbol symbol;
            symbol = resources.getFillLibrary().findSymbol(ID);
            if (symbol != null) return symbol;

            symbol = resources.getLineLibrary().findSymbol(ID);
            if (symbol != null) return symbol;

            symbol = resources.getMarkerLibrary().findSymbol(ID);
            if (symbol != null) return symbol;

            return symbol;
        } catch (Exception e) {
            return null;
        }
    }
}
