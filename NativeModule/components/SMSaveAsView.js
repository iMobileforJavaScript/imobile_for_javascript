/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:基于SMSaveAsPage封装的navigation控件中使用的地图另存页面。
 
 **********************************************************************************/

import React from 'react';
import {
    AppRegistry,
    Text,
    View,
    Button,
} from 'react-native';
import { StackNavigator } from 'react-navigation';
import SaveAsPage from './SMSaveAsPage';

class ChatScreen extends React.Component {
    static navigationOptions = {
    title: '另存工作空间',
    };
    render() {
        return (
                <View>
                <SaveAsPage/>
                </View>
                );
    }
}

module.exports = ChatScreen;
