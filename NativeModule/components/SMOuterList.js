/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:数据源展示列表。
 
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
        PixelRatio,
        TouchableHighlight } from 'react-native'

import InnerList from './SMInnerList';

var OuterCell = React.createClass({
 getInitialState: function() {
   return {highLight:false};
 },
                                  
 _onPress: function() {
   this.setState({highLight:!this.state.highLight});
 },
                                  
  render: function() {
    return (
      <View>
        <View style={styles.pageOneStyle}>
          <TouchableHighlight style={styles.pageOneButton}
                              onPress={
                                this._onPress}>
            <View style={styles.buttonInnerView}>
              <View style={styles.buttonInnerView}>
                <Image style={styles.pageOneImage} source={this.props.titleImage ? this.props.titleImage : require('./file.png')} />
                <Text style={styles.pageOneText}>{this.props.titleText ? this.props.titleText :'未命名数据源'}</Text>
              </View>
              <Image style={styles.pageOneImageTwo}/>
            </View>
         </TouchableHighlight>
       </View>
       <View style={styles.separator} />
       {this.state.highLight && <InnerList/>}
     </View>
    );
  }

});

var DataSourceListPage = React.createClass({
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
                                 
    _renderRow: function(rowData: string,sectionID: number, rowID: number, highlightRow: boolean) {
//        var imgSource = THUMB_URLS[rowID][1];
//        var id = THUMB_URLS[rowID][0];
        return (
                <OuterCell/>
        );
    },
                                 
});

var styles = StyleSheet.create({
                                 container: {
                                   width:Dimensions.get('window').width,
                                   backgroundColor:'white',
                                 },
                               pageOneStyle: {
                               width:Dimensions.get('window').width,
                               height:60,
                               },
                               pageOneButton: {
                               margin:0,
                               backgroundColor:'white',
                               },
                               buttonInnerView: {
                               margin:0,
                               backgroundColor:'white',
                               display:'flex',
                               flexDirection:'row',
                               justifyContent:'space-between',
                               },
                               pageOneImage:{
                               width:50,
                               height:50,
                               marginTop:5,
                               marginBottom:5,
                               marginLeft:30,
                               backgroundColor:'white',
                               alignSelf:'center',
                               },
                               pageOneImageTwo:{
                               width:50,
                               height:50,
                               marginTop:5,
                               marginBottom:5,
                               backgroundColor:'white',
                               },
                               pageOneText:{
                               marginLeft:5,
                               alignSelf:'center',
                               },
                               separator: {
                               height: 1 / PixelRatio.get(),
                               backgroundColor: '#bbbbbb',
                               marginLeft: 15,
                               },
                              });

module.exports = DataSourceListPage;
