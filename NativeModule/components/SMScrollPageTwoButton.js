/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:底层组件
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ ScrollView,
    Image,
    Text,
    View,
    StyleSheet,
    TouchableHighlight } from 'react-native'

var ScrollButton = React.createClass({

  render(){
    return(
           <TouchableHighlight style={styles.buttonStyle} onPress={this.props.clickButton}>
        <View style={styles.innerContainer}>
           <Image style={styles.imageStyle} source={this.props.source}/>
           <View style={styles.textStyle}>
             <Text>{this.props.text}</Text>
           </View>
        </View>
      </TouchableHighlight>
                                     
    );
  }
});

var styles = StyleSheet.create({
                               buttonStyle:{
                               display:'flex',
                               flexDirection:'column',
                               height:60,
                               alignSelf:'center',
                               justifyContent:'space-between',
                               backgroundColor:'white',
                               },
                               innerContainer:{
                               backgroundColor:'white',
                               },
                               imageStyle:{
                               height:28,
                               width:28,
                               margin:1,
                               alignSelf:'center',
                               backgroundColor:'white',
                               },
                               textStyle:{
                               height:28,
                               margin:1,
                               alignItems:'center',
                               justifyContent: 'center',
                               backgroundColor:'white',
                               }

});

module.exports = ScrollButton;
