/**
 * Created by will on 2016/6/15.
 */
let React = require('react');
let {
        requireNativeComponent,
        View,
        StyleSheet,
        Image,
        NativeModules,
        PixelRatio  /*像素转换工具*/
    }=require('react-native');
let resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource'); /*解析静态图片工具*/
import MapView from '../MapView.js';
import Point2D from '../Point2D.js';
import Point from '../Point.js';

let MC = NativeModules.JSMapControl;
let MV = NativeModules.JSMapView;
/**
 * ServerMapView视图标签，提供onGetInstance属性，该属性值的类型为函数，
 * 且函数参数为从Native层返回的MapViewId，在使用该标签时，必须通过此属性获得MapViewId
 */
const STARTPOINT = require('./../resource/startpoint.png');
const DESTPOINT = require('./../resource/destpoint.png');

class SMMapView extends React.Component{
    state = {
        startPoint:{},
        callouts:[],
        path:require('./../resource/startpoint.png'),
    }

    constructor(){
        super();
        this._onChange = this._onChange.bind(this);
    }

    componentWillMount(){
        this.setState({
            callouts:this.props.callouts,
        });
    }

    _onChange(event){
        if(!this.props.onGetInstance){
            console.error("no onGetInstance property!");
            return;
        }
        console.log("has onGetInstance:"+event.nativeEvent.mapViewId);

        this.mapView = new MapView();
        this.mapView.mapViewId = event.nativeEvent.mapViewId;
        this.props.onGetInstance(this.mapView);

        (async function () {
            try{
                this.mapControl = await this.mapView.getMapControl();
                this.map = await this.mapControl.getMap();

                this.mapControl.setRefreshListener(
                    //刷新地图重绘callouts
                    async () => {
                        if(this.state.callouts.length !== 0) {
                            var arr = this.state.callouts;
                            for(var i = 0 ; i < arr.length; i++){
                                var Point2DFac = new Point2D();
                                console.log("SMMapViewUI:mapPoint:" + arr[i].mapX + "," + arr[i].mapY);
                                var point2D = await Point2DFac.createObj(arr[i].mapX,arr[i].mapY);
                                var pixalPoint = await this.map.mapToPixel(point2D);
                                console.log("SMMapViewUI:pixalPoint:" + pixalPoint.x + "," + pixalPoint.y);
                                //转布局坐标
                                arr[i].top = pixalPoint.y / PixelRatio.get();
                                arr[i].left = pixalPoint.x / PixelRatio.get();

                                //调整图标锚点位置
                                const sourceBody = resolveAssetSource(arr[i].uri);
                                let {width,height} = sourceBody;
                                var offY = arr[i].top - height;
                                var offX = arr[i].left - width/2;

                                var indexer = "callout" + i;
                                this.refs[indexer].setNativeProps({
                                    style:{
                                        top:offY,
                                        left:offX,
                                    }
                                });
                            }
                        }
                    }
                );


            }catch (e){
                console.log(e);
            }
        }).bind(this)();
    }

    /**
     * 长按添加图片callout监听器
     * @param callout - callout对象，e.g:{uri:require('./../resource/destpoint.png'),mapX:mapPoint.x,mapY:mapPoint.y}
     * @private
     */
    async _addCallouts(callout,index){
        await this.mapControl.setGestureDetector({longPressHandler:(e)=>{
            console.log('MapControl:Longpress:' + JSON.stringify(e));

            (async function () {
                var pointFac = new Point();
                var point = await pointFac.createObj(e.x,e.y);
                var mapPoint = await this.map.pixelToMap(point);

                var arr = this.state.callouts;
                if(!index){
                    arr.push(callout);
                }else{
                    arr[index] = callout;
                }
                this.setState({
                    callouts:arr,
                });

            }).bind(this)();
            //像素单位转布局单位
            // var layoutY = e.y/PixelRatio.get();
            // var layoutX = e.x/PixelRatio.get();
            // console.log('MapControl:Longpress:' + layoutX + ", " + layoutY);
            // var arr = this.state.callouts;
            // arr.push({uri:require('./resource/destpoint.png'),top:layoutY,left:layoutX});
            // this.setState({
            //     callouts:arr,
            // });
        }});
    }

    static propTypes = {
        onGetInstance:React.PropTypes.func,
        callouts:React.PropTypes.array,
        addCalloutByLongPress:React.PropTypes.bool,
        ...View.propTypes,
    };

    static defaultProps = {
        callouts:[],
        addCalloutByLongPress:false,
    }

    render(){
        var props = {...this.props};
        props.returnId = true;

        return (
            <View style={styles.views}>
                <RCTMapView {...props} style={styles.map} onChange={this._onChange}></RCTMapView>
                { !this.state.callouts ||
                    this.state.callouts.filter(function (item) {
                        if(!item.uri) {return false;}
                        return true;
                    }).map((item,index) => {
                        const sourceBody = resolveAssetSource(item.uri);
                        let {width,height} = sourceBody;
                        var offY = item.top - height;
                        var offX = item.left - width/2;
                        var indexer = "callout" + index;
                        return <Image key={index} ref={indexer} source={item.uri} style={
                                                       [styles.pic,{
                                                           top:offY,
                                                           left:offX,
                                                       }]
                                                   }></Image>} )
                }
            </View>
        );
    }
}

var RCTMapView = requireNativeComponent('RCTMapView',SMMapView,{nativeOnly:{
    returnId:true,
    onChange:true,
}});

var styles = StyleSheet.create({
    views: {
        flex: 1,
        alignSelf: 'stretch',
        backgroundColor: '#ffbcbc',
        alignItems: 'center',
        justifyContent: 'center',
        overflow:'hidden',
    },
    map:{
        flex:1,
        alignSelf:'stretch',
    },
    pic:{
        position:'absolute',
        top:-100,
        left:-100,
    }
});

export default SMMapView;
