/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:横向滑动组件,提供backgrouColor;width;
                          pageOneImageOne;pageOneImageTwo;pageOneText;
                          pageTwoButtonOneText;pageTwoButtonTwoText;pageTwoButtonThreeText;
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ 
  ScrollView,
  Image,
  Text,
  View,
  StyleSheet,
  Dimensions,
  PixelRatio,
  TouchableHighlight 
} from 'react-native'

import SMScrollPageTwoButton from './SMScrollPageTwoButton';
import SMScrollPageOneButton from './SMScrollPageOneButton';

export default class ScrollPage extends Component{                                  
  render() {
    return(
      <View style={[styles.container,{backgroundColor:this.props.backgroundColor}]}>
        <ScrollView horizontal={true}
                    pagingEnabled={true}
                    style={styles.scrollViewStyle}
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}>
          <View style={[styles.pageOneStyle,{width:this.props.width ? this.props.width :Dimensions.get('window').width}]}>
            <SMScrollPageOneButton clickButton ={this.props.clickPageOneBtn}
                                   imageOne ={this.props.pageOneImageOne ? this.props.pageOneImageOne : require('../resource/file.png')}
                                   imageTwo ={this.props.pageOneImageTwo ? this.props.pageOneImageTwo : require('../resource/arrow.png')}
                                   text ={this.props.pageOneText ? this.props.pageOneText : '未命名工作空间'}/>
          </View>
          <View style={[styles.pageTwoStyle,{width:this.props.width ? this.props.width : Dimensions.get('window').width}]}>
            <SMScrollPageTwoButton source={require('../resource/star.png')}
                                   text={this.props.pageTwoButtonOneText ? this.props.pageTwoButtonOneText :'保存工作空间'}
                                   clickButton ={this.props.clickPageTwoBtnOne}/>
            <SMScrollPageTwoButton source={require('../resource/star.png')}
                                   text={this.props.pageTwoButtonTwoText ? this.props.pageTwoButtonTwoText :'另存工作空间'}
                                   clickButton ={this.props.clickPageTwoBtnTwo}/>
            <SMScrollPageTwoButton source={require('../resource/star.png')}
                                   text={this.props.pageTwoButtonThreeText ? this.props.pageTwoButtonThreeText :'关闭工作空间'}
                                   clickButton ={this.props.clickPageTwoBtnThree}/>
          </View>
        </ScrollView>
        <View style={styles.separator}/>
      </View>
           );
  }
    
};

var styles = StyleSheet.create({
  container: {
    backgroundColor:'#F5FCFF'
  },
  scrollViewStyle: {
    backgroundColor:'transparent',
  },
  pageOneStyle: {
    backgroundColor:'transparent',
    height:60,
  },
  pageTwoStyle: {
    backgroundColor:'transparent',
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