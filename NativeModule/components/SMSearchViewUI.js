/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:搜索控件，显示搜索结果。
 
 **********************************************************************************/

'use strict';
  var ReactNative =require('react-native');
  var React = require('react');
  var {
      AppRegistry,
      PixelRatio,
      Image,
      ListView,
      TouchableHighlight,
      StyleSheet,
      Text,
      View,
      Dimensions,
  } = ReactNative;

  var SMPage = require('./SMPage');

var THUMB_URLS11 = ['中国',
                  '韩国',
                  '日本',
                  '美国',
                  '加拿大',
                  '俄罗斯',
                  '西班牙',
                  '葡萄牙',
                  '挪威',
                  '冰岛',
                  '丹麦',
                  '名字很长很长很长的国家'];

  var SMSearchView = React.createClass({
    statics: {
      title: '搜索结果',
    },

  getInitialState: function() {
    var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
    return {
      dataSource: ds.cloneWithRows(this._genRows({})),
    };
  },

  _pressData: ({}: {[key: number]: boolean}),
                                       
  componentWillMount: function() {
    this._pressData = {};
  },
         
                                       
  render: function() {
    return (
      <SMPage
        style={styles.list}
        title={this.props.navigator ? null : '查询控件'}
        noSpacer={true}
        noScroll={true}>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this._renderRow}
        />
      </SMPage>
    );
  },
                                       
  _renderRow: function(rowData: string, sectionID: number, rowID: number) {
    //var rowHash = Math.abs(hashCode(rowData));
    var imgSource = THUMB_URLS[rowID];
    return (
      <TouchableHighlight onPress={() => this._pressRow(rowID)}>
        <View>
          <View style={styles.row}>
            <Text style={styles.text}>
            {THUMB_URLS11[rowID]}
            </Text>
            <View style={styles.description}>
              <Image style={styles.thumb} source={imgSource} />
              <Text style={styles.contentText}>
                {rowData}
              </Text>
            </View>
          </View>
          <View style={styles.separator} />
        </View>
      </TouchableHighlight>
     );
  },
    
  _genRows: function(pressData: {[key: number]: boolean}): Array<string> {
    var dataBlob = [];
    for (var ii = 0; ii < 12; ii++) {
      var pressedText = pressData[ii] ? ' (pressed)' : '';
      dataBlob.push('超长文本，这是一个超长文本长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长' + ii + pressedText +'!');
    }
    return dataBlob;
  },
                                       
  _pressRow: function(rowID: number) {
    this._pressData[rowID] = !this._pressData[rowID];
    this.setState({dataSource: this.state.dataSource.cloneWithRows(
    this._genRows(this._pressData)
    )});
  },
});

var THUMB_URLS = [require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png'),
                  require('./../plotImage/star.png')];

/* eslint no-bitwise: 0 */
  var hashCode = function(str) {
    var hash = 15;
    for (var ii = str.length - 1; ii >= 0; ii--) {
        hash = ((hash << 5) - hash) + str.charCodeAt(ii);
    }
    return hash;
};

var styles = StyleSheet.create({
                               list: {
                               width:Dimensions.get('window').width,
                               height: 100,
                               },
                               text: {
                               marginLeft:15,
                               fontSize:18,
                               },
                               contentText: {
                               marginLeft:15,
                               fontSize:25,
                               textAlign:'center',
                               justifyContent: 'center',
                               },
                               row: {
                               width:Dimensions.get('window').width,
                               backgroundColor: 'white',
                               justifyContent: 'center',
                               paddingHorizontal: 15,
                               paddingVertical: 8,
                               display:'flex',
                               flexDirection:'column',
                               },
                               description: {
                               display:'flex',
                               flexDirection:'row',
                               },
                               separator: {
                               height: 1 / PixelRatio.get(),
                               backgroundColor: '#bbbbbb',
                               marginLeft: 15,
                               },
                               });

module.exports = SMSearchView;
