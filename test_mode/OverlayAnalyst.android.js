/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow 图层管理、比例尺、图例控件测试案例。
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  View
} from 'react-native';
import Workspace from './../NativeModule/Workspace.js';
import ServerMapView from './../NativeModule/components/SMMapViewUI.js';
import DatasourceConnectionInfo from './../NativeModule/DatasourceConnectionInfo';
import Dataset from './../NativeModule/Dataset';
import Datasource from './../NativeModule/Datasource';
import OverlayAnalyst from './../NativeModule/OverlayAnalyst';
import OverlayAnalystParameter from './../NativeModule/OverlayAnalystParameter';

export default class GeometryInfo extends Component {
  state = {
    mapId:false,
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
          var datasourceModule = new DatasourceConnectionInfo();
          var overlayAnalystParameterModule = new OverlayAnalystParameter();
          var overlayAnalystModule = new OverlayAnalyst();

          //加载工作空间等一系列打开地图的操作
          (async function () {
              try {
                  this.workspace = await workspaceModule.createObj();
                  var datasourceConnectionInfo = await datasourceModule.createObj();
                  await datasourceConnectionInfo.setServer("/SampleData/GeometryInfo1/World.udb");
                  var targetDatasource = await this.workspace.openDatasource({server:"/SampleData/GeometryInfo1/World.udb",engineType:219});
                  var d1 = await targetDatasource.getDataset("Rivers_clipped");
                  var clippedDataset = await d1.toDatasetVector();
                  var d2 = await targetDatasource.getDataset("Lakes_clip");
                  var clipDataset = await d2.toDatasetVector();


                  var d3 = await targetDatasource.getDataset("resultDatasetClip");
                  var resultDatasetClip = await d3.toDatasetVector();

                  // var resultDatasetClip = await targetDatasource.createDatasetVector("resultDatasetClip5",Dataset.TYPE.LINE,Datasource.EncodeType.NONE);

                  var overlayAnalystParameter = await overlayAnalystParameterModule.createObj();
                  await overlayAnalystParameter.setTolerance(0.0122055608);

                  var clipped = await overlayAnalystModule.clip(clippedDataset,clipDataset,resultDatasetClip,overlayAnalystParameter);

                  console.warn("clipped:" + clipped);


                  this.mapControl = await this.mapView.getMapControl();
                  this.map = await this.mapControl.getMap();
                  await this.map.setWorkspace(this.workspace);

                  // await this.map.addDataset(d3,true);
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
  }
});

AppRegistry.registerComponent('GeometryInfo', () => GeometryInfo);
