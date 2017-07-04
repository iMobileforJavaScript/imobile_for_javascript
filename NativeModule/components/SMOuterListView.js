/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:基于SMOuterList封装的navigation控件中使用的数据源展示列表页。
 
 **********************************************************************************/

import React from 'react';
import {
    AppRegistry,
    Text,
    View,
    Button,
} from 'react-native';
import { StackNavigator } from 'react-navigation';
import DataSourceList from './SMOuterList';

class DataSourceListScreen extends React.Component {
    static navigationOptions = {
    title: '数据源',
    };
    render() {
        const { navigate } = this.props.navigation;
        return (
                <View>
                <DataSourceList/>
                </View>
                );
    }
}

module.exports = DataSourceListScreen;
