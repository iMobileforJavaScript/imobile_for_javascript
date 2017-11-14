/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    TouchableHighlight,
} from 'react-native';
import{
    Workspace,
    SMMapView,
    Utility,
    GridHotChart,
    Point2D,
    ColorScheme,
    ChartPoint,
    BarChartData,
    BarChartDataItem,
    PieChartData,
    SMBarChartView
} from 'imobile_for_javascript';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {
    state = {
        barData : false,
    }
    _onGetInstance = (mapView) => {
        this.mapView = mapView;
        this._addMap();
    }
    render() {
      return (
        <View style={styles.container}>
            <SMMapView ref="mapView" style={styles.map} onGetInstance={this._onGetInstance}/>
            {this.state.barData && <SMBarChartView isValueAlongXAxis={true} style={styles.chart} 
                                                   title={'chart'} isValueAlongXAxis ={true} 
                                                   data={this.state.barData}/>}
            <View style={styles.buttons}>
                <TouchableHighlight style={styles.button} onPress = {this._barChart}>
                    <Text style={styles.button_text}>BarChart</Text>
                </TouchableHighlight>
                <TouchableHighlight style={styles.button} onPress = {this._gridHotChart}>
                    <Text style={styles.button_text}>GridHotChart</Text>
                </TouchableHighlight>
            </View>
        </View>

      );
    }

    _addMap=()=> {
        var workspaceModule = new Workspace();
        (async function () {
            this.workspace = await workspaceModule.createObj();
            this.mapControl = await this.mapView.getMapControl();
            this.map = await this.mapControl.getMap();

            var filePath = '/SampleData/hotMap.smwu';
            if (Platform.OS === 'ios') {
                filePath = await Utility.appendingHomeDirectory('/Documents/hotMap.smwu');
            }
            var openWk = await this.workspace.open(filePath);
            this.datasource = await this.workspace.getDatasource(0);

            await this.map.setWorkspace(this.workspace);
            var mapName = await this.workspace.getMapName(0);
            await this.map.open(mapName);
            await this.map.refresh();
        }).bind(this)();
    }

    _barChart = async() => {
        var layer = await this.map.getLayer(0);
        var dataset = await layer.getDataset();
        await console.log("name:"+layer.getName());
        var datasetVector = await dataset.toDatasetVector();
        var lables = ["四川","河南","广东","山西","山东"];
        var barChartDataMoudle = new BarChartData();
        var barChartDataItemMouble = new BarChartDataItem();

        var datas1 = [];
        var datas2 = [];
        //调色板
        var colorsArr = [[188,254,151],[255,245,151],[126,237,253],[255,205,147.0],[125,125,151]];

        for(var i = 0;i < lables.length;i++) {
            var value1 = await datasetVector.getFieldValue("NAME = '"+lables[i]+"'",'HIGHSCHOOL_1990');
            var id = await datasetVector.getFieldValue("NAME = '"+lables[i]+"'",'SmID');
            var value2 = await datasetVector.getFieldValue("NAME = '"+lables[i]+"'",'HIGHSCHOOL_2000');
            console.log("value1:"+value1+";value2:"+value2+";id:"+id);
            var barChartDataItem = await barChartDataItemMouble.createObj(value1[0],colorsArr[i],lables[i],id[0]);
            var barChartDataItem1 = await barChartDataItemMouble.createObj(value2[0],colorsArr[i],lables[i],id[0]);
            await datas1.push(barChartDataItem);
            await datas2.push(barChartDataItem1);
        }
        var barChartData = await barChartDataMoudle.createObj('2000',datas1);
        var dataArr = [];
        await dataArr.push(barChartData.barChartDataId);
        var barChartData1 = await barChartDataMoudle.createObj('2001',datas2);
        await dataArr.push(barChartData1.barChartDataId);
        this.setState({
                barData : dataArr,
            }
        );

    }


    //数据量大，显示性能极低；
    _gridHotChart = async() => {
        var layersCount = await this.map.getLayersCount();
        for(var i = 0;i < layersCount;i++) {
            var layer = await this.map.getLayer(i);
            await layer.setVisible(false);
        }
        var layer = await this.map.getLayer("Provinces_R@hotMap");
        await layer.setVisible(true);

        var pointMoudle = new Point2D();
        var center = await pointMoudle.createObj(116.58764784354724,39.823781647298183);
        await this.map.setCenter(center);
        await this.map.refresh();

        var gridHotChartMoudle = new GridHotChart();
        var gridHotChart = await gridHotChartMoudle.createObj(this.mapControl);

        // await gridHotChart.setTitle("热力图");
        // var legend = await gridHotChart.getLegend();


        var colorsMoudle = new ColorScheme();
        var colorsArr = [[252,165,93],[227,74,51],[165,0,38]];
        var colors = await colorsMoudle.createObj();
        await colors.setColors(colorsArr);
        var values = [1,5,15];
        await colors.setSegmentValue(values);
        await gridHotChart.setColorScheme(colors);


        var dataset = await this.datasource.getDataset(5);
        var datasetVector = await dataset.toDatasetVector();
        var points = await datasetVector.getGeoInnerPoint("SMID <= 20000");
        var chartpointMoudle = new ChartPoint();
        var dataArr = [];
    
        for(var i = 0; i < points.length; i++) {
            var x = await points[i][0];
            var y = await points[i][1];
            var chartpoint = await chartpointMoudle.createObj(8,x,y);
            dataArr.push(chartpoint);
        }

        await gridHotChart.addChartData(dataArr);
        // await gridHotChart.update();
        this.forceUpdate();
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    map: {
        flex: 0.8,
        alignSelf: 'stretch',
    },
    list: {
        flex:0.2,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent:'space-between',
        alignContent:'flex-start',
    },
    chart: {
        flex: .8,
        backgroundColor: '#ffffff',
        alignSelf: 'stretch',
    },
    buttons: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'flex-start',
        top:20,
        left:10,
        width: 100,
        height: 300,
        position:'absolute',
    },
    button: {
        flex: 0,
        width:100,
        height:20,
        marginBottom: 8,
        opacity:.6,
        backgroundColor: '#333333',
        borderRadius: 5,
    },
    button_text: {
        textAlign: 'center',
        color: '#f0f8ff',
        padding: 4,
        fontSize:12,

    },


});
