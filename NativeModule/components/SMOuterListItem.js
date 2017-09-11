/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  Dimensions,
  Image
} from 'react-native';

import InnerListComponent from './SMInnerListComponent.js';

export default class OuterListItem extends Component {
  constructor(props){
    super(props);
    this.state={highLight:false,
                data:[{key:'_SMDset001',text:'aaa',image:require('../resource/line.png')},{key:'_SMDset002',text:'bbb',image:require('../resource/star.png')},{key:'_SMDset003',text:'bbb',image:require('../resource/star.png')}],
                };
  }

  _onPress = ()=>{
    this.setState({highLight:!this.state.highLight});
  }
  render() {
    return (
      <View style={styles.container}>
        <TouchableHighlight style={styles.touchableContainer} onPress={this._onPress} underlayColor={'white'} activeOpacity={0.1}>
          <View style={styles.touchableSubView}>
            <Image style={styles.itemImage} source={this.props.Image}/>
            <Text style={styles.itemText}>{this.props.Text}</Text>
          </View>
        </TouchableHighlight>
        {this.state.highLight && <InnerListComponent data={this.state.data}/>}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor:'transparent',
  },
  touchableSubView: {
    backgroundColor: 'transparent',
    display: 'flex',
    flexDirection: 'row',
  },
  touchableContainer: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'flex-start',
    width: Dimensions.get('window').width,
    height: 50,
    backgroundColor:'transparent',
  },
  itemImage: {
    width:40,
    height:40,
    marginTop:5,
    marginBottom:5,
    marginLeft:25,
    backgroundColor:'transparent',
  },
  itemText: {
    marginLeft:10,
    lineHeight:50,
    backgroundColor:'transparent',
  }
});