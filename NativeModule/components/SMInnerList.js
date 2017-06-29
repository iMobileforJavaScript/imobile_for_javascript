/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:数据集展示列表。
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ ScrollView,
        Image,
        Text,
        View,
        TextInput,
        StyleSheet,
        Dimensions,
        ListView,
        TouchableHighlight } from 'react-native'

import DatasetCell from './SMDataSetCellPage';

var InnerListPage = React.createClass({
    getInitialState: function() {
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        return {
            dataSource:ds.cloneWithRows(['row1', 'row 2','row 3','row 4','row 5','row 6','row 7','row 8','row 9','row10','row 11','row 12']),
        };
    },
    _pressData: ({}: {[key: number]: boolean}),
    componentWillMount: function() {
        this._pressData = {};
    },
                                 
    render: function() {
        return (
            <ListView
                initialListSize={11}
                contentContainerStyle={styles.container}
                dataSource={this.state.dataSource}
                renderRow={this._renderRow}/>
                );
    },
                                 
    _renderRow: function(rowData: string,sectionID: number, rowID: number) {
//        var imgSource = THUMB_URLS[rowID][1];
//        var id = THUMB_URLS[rowID][0];
        return (
                <DatasetCell  titleText={'Day_1'}/>
        );
    },
                                 
});

var styles = StyleSheet.create({
                                 container: {
                                   width:Dimensions.get('window').width,
                                   backgroundColor:'white',
                                 },
                              });

module.exports = InnerListPage;
