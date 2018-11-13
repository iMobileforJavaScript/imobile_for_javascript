/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:Title控件,提供text;width;backgroundColor三种属性参数。
 
 **********************************************************************************/

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  TouchableHighlight,
  Image,
} from 'react-native';

export default class TitlePage extends Component {

  render() {
    return (
      <View style={[styles.containerS,{width:this.props.width},{backgroundColor:this.props.backgroundColor}]}>
        {this.props.backBtnDisplay && 
          <TouchableHighlight style ={styles.backBtn} onPress={this.props.clickBtn} underlayColor={'rgba(34,26,38,0.1)'} >
            <Image style={styles.btnImage} source={require('../resource/leftArrow.png')}></Image>
          </TouchableHighlight>}
          <View style={[styles.textContainer,{width: this.props.backBtnDisplay ? Dimensions.get('window').width-27*2 :Dimensions.get('window').width}]}>
            <Text style={styles.instructions}>
              {this.props.text ? this.props.text : 'TitleText'}
            </Text>
        </View>
      </View>
    );
  }
}



const styles = StyleSheet.create({
  containerS: {
    display: 'flex',
    flexDirection:'row',
    alignItems: 'center',
    height:60,
    width: Dimensions.get('window').width,
    borderBottomWidth: 1,
    borderBottomColor:'#bbbbbb',
    backgroundColor: '#F5FCFF',
  },
  textContainer:{
    height:60,
    width: Dimensions.get('window').width-27*2,
    justifyContent: 'center',
    alignItems: 'center',
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    backgroundColor: 'transparent',
  },
  backBtn: {
    marginLeft:5,
    height:22,
    width:22,
    backgroundColor:'transparent',
    borderRadius:11,
  },
  btnImage: {
    height:20,
    width:20,
    margin:1,
  },
});