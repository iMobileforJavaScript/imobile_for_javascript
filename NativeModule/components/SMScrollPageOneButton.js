/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:SMScrollPage子组件，提供imageOne;imageTwo;text;backgroundColor;
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ 
  ScrollView,
  Image,
  Text,
  View,
  StyleSheet,
  TouchableHighlight 
} from 'react-native'

export default class ScrollPageOneButton extends Component{
  render(){
    return(
      <TouchableHighlight style={[styles.pageOneButton,{backgroundColor:this.props.backgroundColor}]} onPress={this.props.clickButton} underlayColor={'rgba(34,26,38,0.1)'}>
        <View style={styles.buttonOuterView}>
          <View style={styles.buttonInnerView}>
            <Image style={styles.pageOneImage} source={this.props.imageOne} />
            <Text style={styles.pageOneText}>
              { this.props.text }
            </Text>
          </View>
          <Image style={styles.pageOneImageTwo} source={this.props.imageTwo}/>
        </View>
      </TouchableHighlight>                                  
    );
  }
};

var styles = StyleSheet.create({
  pageOneButton: {
    margin:0,
    backgroundColor:'#F5FCFF',
  },
  buttonOuterView: {
    margin:0,
    backgroundColor:'transparent',
    display:'flex',
    flexDirection:'row',
    justifyContent:'space-between', 
  },
  buttonInnerView: {
    margin:0,
    backgroundColor:'transparent',
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
    backgroundColor:'transparent',
    alignSelf:'center',
  },
  pageOneImageTwo:{
    width:50,
    height:50,
    marginTop:5,
    marginBottom:5,
    backgroundColor:'transparent',
  },
  pageOneText:{
    marginLeft:5,
    alignSelf:'center',
    backgroundColor:'transparent',
  },
});