 /**
 * Created by wangzihao on 2017/6/8.
 */

'use strict';
import PropTypes from 'prop-types';
import React,{Component} from 'react';
import {
    Image,
    View,
    Text,
    TouchableHighlight,
    FlatList,
    StyleSheet,
    Dimensions,
} from 'react-native';

var itemData = [
  {key:'_SMPlot1',id:10,imageSource:require('./../plotImage/10.png')},
  {key:'_SMPlot2',id:14,imageSource:require('./../plotImage/14.png')},
  {key:'_SMPlot3',id:56,imageSource:require('./../plotImage/56.png')},
  {key:'_SMPlot4',id:10100,imageSource:require('./../plotImage/10100.png')},
  {key:'_SMPlot5',id:30307,imageSource:require('./../plotImage/30307.png')},
  {key:'_SMPlot6',id:30308,imageSource:require('./../plotImage/30308.png')},
  {key:'_SMPlot7',id:30502,imageSource:require('./../plotImage/30502.png')},
  {key:'_SMPlot8',id:30709,imageSource:require('./../plotImage/30709.png')},
  {key:'_SMPlot9',id:40503,imageSource:require('./../plotImage/40503.png')},
  {key:'_SMPlot10',id:70100,imageSource:require('./../plotImage/70100.png')},
  {key:'_SMPlot11',id:80102,imageSource:require('./../plotImage/80102.png')},
  {key:'_SMPlot12',id:80106,imageSource:require('./../plotImage/80106.png')},
  {key:'_SMPlot13',id:80400,imageSource:require('./../plotImage/80400.png')},
  {key:'_SMPlot14',id:80201,imageSource:require('./../plotImage/80201.png')},
  {key:'_SMPlot15',id:1001,imageSource:require('./../plotImage/1001.png')},
  {key:'_SMPlot16',id:1002,imageSource:require('./../plotImage/1002.png')},
  {key:'_SMPlot17',id:1003,imageSource:require('./../plotImage/1003.png')},
  {key:'_SMPlot18',id:1004,imageSource:require('./../plotImage/1004.png')},
  {key:'_SMPlot19',id:1005,imageSource:require('./../plotImage/1005.png')},
  {key:'_SMPlot21',id:1006,imageSource:require('./../plotImage/1006.png')},
  {key:'_SMPlot22',id:1007,imageSource:require('./../plotImage/1007.png')},
  {key:'_SMPlot23',id:1008,imageSource:require('./../plotImage/1008.png')},
  {key:'_SMPlot24',id:1009,imageSource:require('./../plotImage/1009.png')},
];
export default class SMPlotView extends Component{
  constructor(props) {
    super(props);
  }

  render() {
    var num
    return (
      <View>
        <FlatList
          ref={(flatList)=>this._flatList = flatList}
          ItemSeparatorComponent={this._separator}
          renderItem={this._renderItem}
          // numColumns ={Dimensions.get('window').width/45}
          // columnWrapperStyle={{borderWidth:2,borderColor:'black',paddingLeft:20}}
          horizontal={true}
          data={itemData}/>
      </View>
    );
  }

  _renderItem = (Obj) => {
    console.log(Obj.item.id);
    return (
      <TouchableHighlight underlayColor="red" onPress={()=>this._buttonPress(Obj.item.id)}>
        <View style={{justifyContent: 'center',padding: 5,margin: 3,width: 85,height: 85,backgroundColor: '#F6F6F6',alignItems: 'center',borderWidth: 1,borderRadius: 5,borderColor: '#CCC'}}>
          <Image style={{width: 45,height: 45}} source={Obj.item.imageSource}/>
          <Text style={{flex: 1,marginTop: 5,fontWeight: 'bold'}}>
            {Obj.item.id}
          </Text>
        </View>
      </TouchableHighlight>
    );
}

_buttonPress = (id) => {
  var libId = this.props.libId;
  (async function () {
  await (this.props.mapCtr).setAction(3000);
  await (this.props.mapCtr).setPlotSymbol(libId,id);
  }).bind(this)();
}

_separator = () => {
  return <View style={{height:2,backgroundColor:'black'}}/>;
}

}

/*
var SMPlotView =React.createClass({
                                getInitialState: function() {
                                var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
                                return {
                                dataSource:ds.cloneWithRows(this._genRows({})),
                                };
                                },
                                _pressData: ({}: {[key: number]: boolean}),
                                componentWillMount: function() {
                                this._pressData = {};
                                },
                                render: function() {
                                return (
                                        <ListView
                                        initialListSize={THUMB_URLS.length}
                                        contentContainerStyle={this.props.style ? this.props.style : styles.list}
                                        dataSource={this.state.dataSource}
                                        renderRow={this._renderRow}
                                        />
                                        );
                                },
                                _renderRow: function(rowData: string,sectionID: number, rowID: number) {
                                var imgSource = THUMB_URLS[rowID][1];
                                var id = THUMB_URLS[rowID][0];
                                return (
                                        <TouchableHighlight underlayColor="red" onPress={()=>this._buttonPress(id)}>
                                        <View>
                                        <View style={styles.row}>
                                        <Image style={styles.thumb} source={imgSource} />
                                        <Text style={styles.text}>
                                        {
                                        id
                                        }
                                        </Text>
                                        </View>
                                        </View>
                                        </TouchableHighlight>
                                        );
                                },
                                _genRows: function(pressData: {[key: number]:boolean}): Array<string> {
                                var dataBlob = [];
                                for (var ii = 0; ii < THUMB_URLS.length;ii++) {
                                dataBlob.push('单元格 ' + ii);
                                }
                                return dataBlob;
                                },
                                _buttonPress: function(id1){
                                  (this.props.mapCtr).setAction(3000);
                                  (this.props.mapCtr).setPlotSymbol(this.props.libId,id1);
                                },
                                });
var styles =StyleSheet.create({
                              list: {
                              marginTop:5,
                              alignContent:'space-around',
                              flexDirection: 'row',
                              flexWrap: 'wrap'
                              },
                              row: {
                              justifyContent: 'center',
                              padding: 5,
                              margin: 3,
                              width: 85,
                              height: 85,
                              backgroundColor: '#F6F6F6',
                              alignItems: 'center',
                              borderWidth: 1,
                              borderRadius: 5,
                              borderColor: '#CCC'
                              },
                              thumb: {
                              width: 45,
                              height: 45
                              },
                              text: {
                              flex: 1,
                              marginTop: 5,
                              fontWeight: 'bold'
                              },
                              });
module.exports = SMPlotView;
*/
