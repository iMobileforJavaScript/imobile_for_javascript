/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:基于SMCreateDSPage封装的navigation控件中使用的数据源创建页面。
 
 **********************************************************************************/

import React from 'react';
import {
    AppRegistry,
    Text,
    View,
    Button,
} from 'react-native';
import { StackNavigator } from 'react-navigation';
import SMCreateDSPage from './SMCreateDSPage';

class DSCreateScreen extends React.Component {
    static navigationOptions = {
    title: '新建数据源',
    };
    render() {
        const { navigate } = this.props.navigation;
        return (
                <View>
                <SMCreateDSPage/>
                </View>
                );
    }
}

module.exports = DSCreateScreen;
