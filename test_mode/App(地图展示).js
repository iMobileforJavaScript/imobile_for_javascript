/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    View,
    Platform,
} from 'react-native';
import{
    Workspace,
    SMMapView,
    Utility,
} from 'imobile_for_javascript';

export default class App extends Component<{}> {

    _onGetInstance = (mapView) => {
        this.mapView = mapView;
        this._addMap();
    }

    render() {
      return (
        <View style={styles.container}>
            <SMMapView style={styles.map} onGetInstance={this._onGetInstance}/>
        </View>
      );
    }

    _addMap=()=> {
        var workspaceModule = new Workspace();
        (async function () {
            this.workspace = await workspaceModule.createObj();
            this.mapControl = await this.mapView.getMapControl();
            this.map = await this.mapControl.getMap();
         
            var filePath = '/SampleData/China400/China400.smwu';
            if(Platform.OS === 'ios'){
                filePath = await Utility.appendingHomeDirectory('/Documents/China400.smwu');
            }

            var openWk = await this.workspace.open(filePath);
            await this.map.setWorkspace(this.workspace);
            var mapName = await this.workspace.getMapName(0);
            await this.map.open(mapName);
            await this.map.refresh();
        }).bind(this)();
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
