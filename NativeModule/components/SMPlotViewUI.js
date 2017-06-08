 /**
 * Created by wangzihao on 2017/6/8.
 */

'use strict';
var ReactNative =require('react-native');
var React = require('react');
var {
    AppRegistry,
    Image,
    ListView,
    TouchableHighlight,
    StyleSheet,
    Text,
    View,
} = ReactNative;

var THUMB_URLS = [
                  [10,require('./../plotImage/10.png')],
                  [14,require('./../plotImage/14.png')],
                  [56,require('./../plotImage/56.png')],
                  [10100,require('./../plotImage/10100.png')],
                  [30307,require('./../plotImage/30307.png')],
                  [30308,require('./../plotImage/30308.png')],
                  [30502,require('./../plotImage/30502.png')],
                  [30709,require('./../plotImage/30709.png')],
                  [40503,require('./../plotImage/40503.png')],
                  [70100,require('./../plotImage/70100.png')],
                  [80102,require('./../plotImage/80102.png')],
                  [80106,require('./../plotImage/80106.png')],
                  [80400,require('./../plotImage/80400.png')],
                  [80201,require('./../plotImage/80201.png')],
                  [1001,require('./../plotImage/1001.png')],
                  [1002,require('./../plotImage/1002.png')],
                  [1003,require('./../plotImage/1003.png')],
                  [1004,require('./../plotImage/1004.png')],
                  [1005,require('./../plotImage/1005.png')],
                  [1006,require('./../plotImage/1006.png')],
                  [1007,require('./../plotImage/1007.png')],
                  [1008,require('./../plotImage/1008.png')],
                  [1009,require('./../plotImage/1009.png')],
                  ];

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
