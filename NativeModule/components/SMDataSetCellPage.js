/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:数据集管理控件。
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ ScrollView,
        Image,
        Text,
        View,
        StyleSheet,
        Dimensions,
        PixelRatio,
        TouchableHighlight } from 'react-native'

import SMScrollButon from './SMScrollPageTwoButton';

var ScrollPage = React.createClass({
                                   
  render() {
    return(
           <View style={styles.container}>
           <ScrollView horizontal={true}
                       pagingEnabled={true}
                       style={styles.scrollViewStyle}
                       showsHorizontalScrollIndicator={false}
                       showsVerticalScrollIndicator={false}>
           <View style={styles.pageOneStyle}>
           <TouchableHighlight style={styles.pageOneButton} onPress={this.props.clickPageOneBtn}>
           <View style={styles.buttonInnerView}>
           <View style={styles.buttonInnerView}>
           <Image style={styles.pageOneImage} source={this.props.titleImage ? this.props.titleImage : require('./file.png')} />
           <Text style={styles.pageOneText}>{
           this.props.titleText ? this.props.titleText :'未命名数据集'
           }</Text>
           </View>
           <Image style={styles.pageOneImageTwo}/>
           </View>
           </TouchableHighlight>
           </View>
           <View style={styles.pageTwoStyle}>
           <SMScrollButon source={require('./star.png')}
                          text={this.props.pageTwoButtonOneText ? this.props.pageTwoButtonOneText :'复制数据集'}
                          clickButton ={
                            this.props.clickPageTwoBtnOne
                          }/>
           <SMScrollButon source={require('./star.png')}
                          text={this.props.pageTwoButtonTwoText ? this.props.pageTwoButtonTwoText :'关闭数据集'}
                          clickButton ={this.props.clickPageTwoBtnTwo}/>
           <SMScrollButon source={require('./star.png')}
                          text={this.props.pageTwoButtonThreeText ? this.props.pageTwoButtonThreeText :'删除数据集'}
                          clickButton ={this.props.clickPageTwoBtnThree}/>
           <SMScrollButon source={require('./star.png')}
                          text={this.props.pageTwoButtonFourText ? this.props.pageTwoButtonFourText :'重命名数据集'}
                          clickButton ={this.props.clickPageTwoBtnFour}/>
           <SMScrollButon source={require('./star.png')}
                          text={this.props.pageTwoButtonFiveText ? this.props.pageTwoButtonFiveText :'添加到地图'}
                          clickButton ={this.props.clickPageTwoBtnFive}/>
           </View>
           </ScrollView>
           <View style={styles.separator} />
           </View>
           );
  }
    
});

var styles = StyleSheet.create({
                                 container: {
                                   backgroundColor:'white'
                                 },
                                 scrollViewStyle: {
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
                                 pageTwoStyle: {
                                   width:Dimensions.get('window').width,
                                   height:60,
                                   display:'flex',
                                   flexDirection:'row',
                                   justifyContent:'space-around',
                                 },
                                   separator: {
                                     height: 1 / PixelRatio.get(),
                                     backgroundColor: '#bbbbbb',
                                     marginLeft: 15,
                                   },
                                 });

module.exports = ScrollPage;
