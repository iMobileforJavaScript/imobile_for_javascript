# imobile_for_reactnative

iMobile for ReactNative, 是SuperMap iMobile推出的一款基于React-Native框架的移动应用开发工具，基于该开发工具,用户可以
使用JavaScript XML开发语言，开发出在Android和iOS操作系统下运行的原声移动GIS应用,入门门槛低，一次开发，处处运行。

## Getting started

iMobile for ReactNative is based on ReactNative.Please ensure that you have initialized the RN project before executing the following command and that it is already under the project path.

`$ npm install imobile_for_reactnative --save`

### Mostly automatic installation

`$ react-native link imobile_for_reactnative`

### Manual installation


#### iOS

1. In XCode, in the project navigator, click `General` ➜ `Linked Frameworks and Libraries`,add Frameworks and c++ library required by iMobile.
2. Add SuperMap.framework and MessageQueue.framework.
3. Add bundle file and license.
4. Write and run your project (`Cmd+R`).

#### Android

3. Add license.
4. Write and run your project (`^+R`).

## Usage

For this Example.After install the pack we offered,  You will easily make a project of map inflating the whole screen by following the steps below.

1. Setup the liscense file into the path "./Supermap/licsence".
2. Setup the Sample Data into a specified path that will be refer as a 
argument in the function setServer() of WorkspaceConnection object in the next step;
3. type the follow codes in an initiated React Native Project

```javascript

...
import {
  Workspace,
    SMMapView,
} from 'imobile_for_reactnative';

class XXX extends Component {

  //Required funtion for obtaining the MapView object.
  _onGetInstance = (mapView) => {
    this.mapView = mapView;
    this._addMap();
  }

  /**
   * 初始化地图  Function for initiating the Map
   * @private
   */
  _addMap = () => {
    try {
      //创建workspace模块对象
      //Create workspace object
      var workspaceModule = new Workspace();

      //加载工作空间等一系列打开地图的操作
      //Operations for loading workspace and opening map
      (async function () {
        try {
          this.workspace = await workspaceModule.createObj();

          await this.workspace.open("/SampleData/City/Changchun.smwu");

          this.mapControl = await this.mapView.getMapControl();
          this.map = await this.mapControl.getMap();

          await this.map.setWorkspace(this.workspace);
          var mapName = await this.workspace.getMapName(0);

          await this.map.open(mapName);
          await this.map.refresh();
        } catch (e) {
          console.error(e);
        }
      }).bind(this)();
    } catch (e) {
      console.error(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <SMMapView ref="mapView" style={styles.map} onGetInstance={this._onGetInstance}/>
      </View>
    );
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
    flex: 1,
    alignSelf: 'stretch',
  },
});

AppRegistry.registerComponent('XXX', () => XXX);

```
  
