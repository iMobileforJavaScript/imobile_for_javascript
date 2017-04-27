/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow 图层管理、比例尺、图例控件测试案例。
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';
import Workspace from './../NativeModule/Workspace.js';
import ServerMapView from './../NativeModule/components/SMMapViewUI.js';
import Theme from './../NativeModule/Theme';

export default class GeometryInfo extends Component {
    state = {
        mapId: false,
    }

    _onGetInstance = (mapView) => {
        this.mapView = mapView;
        this._addMap();
    }

    /**
     * 初始化地图
     * @private
     */
    _addMap = () => {
        try {
            //创建workspace模块对象
            var workspaceModule = new Workspace();
            var ThemeModule = new Theme();

            //加载工作空间等一系列打开地图的操作
            (async function () {
                try {
                    this.workspace = await workspaceModule.createObj();

                    await this.workspace.open("/SampleData/GeometryInfo1/World.smwu");
                    var datasource = await this.workspace.getDatasource(0);
                    var dataset = await datasource.getDataset("Countries")
                    var  datasetVector = await dataset.toDatasetVector();

                    var theme = await ThemeModule.makeThemeUnique({datasetVector:datasetVector,uniqueExpression:"CONTINENT",colorGradientType:Theme.ColorGradientType.BLUERED});
                    console.warn("theme" + theme.themeId);

                    this.mapControl = await this.mapView.getMapControl();
                    this.map = await this.mapControl.getMap();

                    await this.map.setWorkspace(this.workspace);
                    var mapName = await this.workspace.getMapName(0);

                    await this.map.open(mapName);
                    await this.map.addThemeLayer(dataset,theme,true);

                    await this.map.refresh();

                } catch (e) {
                    console.error(e);
                }
            }).bind(this)();
        } catch (e) {
            console.error(e);
        }
    }

    render() {
        return (
            <View style={styles.container}>
                <ServerMapView ref="mapView" style={styles.map} onGetInstance={this._onGetInstance}/>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    map: {
        flex: 1,
        alignSelf: 'stretch',
    },
});

AppRegistry.registerComponent('GeometryInfo', () => GeometryInfo);
