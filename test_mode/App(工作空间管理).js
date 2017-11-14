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
    SMWorkspaceManagerView,
} from 'imobile_for_javascript';

export default class App extends Component<{}> {
    constructor(props){
        super(props);
        this.state = {
            mapCtrId: false,
            path: Platform.OS ==='ios' ? '/Documents/China400.smwu':'/SampleData/China400/China400.smwu'
        }
    }

    _onGetInstance = (mapView) => {
        this.mapView = mapView;
        this._addMap();
    }

    render() {
      return (
        <View style={styles.container}>
            <SMWorkspaceManagerView path={this.state.path}/>
        </View>
      );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5FCFF',
      },
});
