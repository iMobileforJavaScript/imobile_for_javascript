/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:基于SMScrollPage封装的navigation控件中使用的工作空间管理页面，同时也作为home页面。
 
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

class HomeScreen extends React.Component {
    static navigationOptions = {
    title: '工作空间管理',
    };
    render() {
        const { navigate } = this.props.navigation;
        return (
                <View>
                <ScrollPage clickPageTwoBtnTwo={() => navigate('SaveAs')}
                            clickPageOneBtn={() => navigate('DSAndMap')}/>
                </View>
                );
    }
}

module.exports = HomeScreen;
