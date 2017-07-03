import React from 'react';
import {
    AppRegistry,
    Text,
    View,
    Button,
} from 'react-native';
import { StackNavigator } from 'react-navigation';
import HomeScreen from './SMWSpaceCtrlHomeView';
import SaveAsScreen from './SMSaveAsView';
import DSAndMapCtrlScreen from './SMDSourceAndMapCtrlView';
import DSCreateScreen from './SMCreateDSView';
import DSListScreen from './SMOuterListView';

var navigation = StackNavigator({
                                  Map: {screen: MapScreem},
                                  Home: { screen: HomeScreen },
                                  SaveAs: { screen: SaveAsScreen },
                                  DSAndMap: {screen: DSAndMapCtrlScreen},
                                  DSCreate:{ screen: DSCreateScreen},
                                  DSList:{screen:DSListScreen},
                                  });

module.exports = navigation;
