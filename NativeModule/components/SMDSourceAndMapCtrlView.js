/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:基于SMScrollPage封装的navigation控件中使用的数据源管理页面。
 
 **********************************************************************************/

import React from 'react';
import {
    AppRegistry,
    Text,
    View,
    Button,
} from 'react-native';
import { StackNavigator } from 'react-navigation';
import ScrollPage from './SMScrollPage';

class DSAndMapCtrlScreen extends React.Component {
    static navigationOptions = {
    title: '工作空间管理',
    };
    render() {
        const { navigate } = this.props.navigation;
        return (
                <View>
                <ScrollPage titleText={'数据源    '}
                            clickPageOneBtn={() => navigate('DSList')}
                            titleImage={require('./dataSource.png')}
                            pageTwoButtonOneText={'新建数据源'}
                            clickPageTwoBtnOne={() => navigate('DSCreate')}
                            pageTwoButtonTwoText={'打开数据源'}
                            pageTwoButtonThreeText={'关闭数据源'}
                />
                <ScrollPage titleText={'地图      '} titleImage={require('./dataSource.png')}/>
                </View>
                );
    }
}

module.exports = DSAndMapCtrlScreen;
