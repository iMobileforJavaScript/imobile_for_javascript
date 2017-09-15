/**
 * Created by will on 2017/3/22.
 */
let React = require('react');
let {
    requireNativeComponent,
    View,
    StyleSheet,
    ViewPropTypes,
}=require('react-native');
import SceneControl from './../SceneControl';

class SMSceneView extends React.Component{

    _onChange = (event) => {
        if(!this.props.onGetScene){
            console.error("no onGetScene property!");
            return;

        }
        console.log("has SceneControl id:"+event.nativeEvent.sceneControlId);

        this.sceneControl = new SceneControl();
        this.sceneControl.sceneControlId = event.nativeEvent.sceneControlId;
        this.props.onGetScene(this.sceneControl);
    };

    static propTypes = {
        onGetScene:React.PropTypes.func,
        ...ViewPropTypes,
    };

    render(){
        var props = {...this.props};
        props.returnId = true;

        return (
            <View style={styles.views}>
                <RCTSceneView {...props} style={styles.map} onChange={this._onChange}></RCTSceneView>
            </View>
        );
    }
}

var RCTSceneView = requireNativeComponent('RCTSceneView',SMSceneView,{nativeOnly:{
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

export default SMSceneView;