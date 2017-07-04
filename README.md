# imobile_for_ReactNative

## Getting started

`$ npm install imobile_for_reactnative --save`

### Mostly automatic installation

`$ react-native link imobile_for_reactnative`

### Manual installation


#### iOS

Supermap SDK base on RN for IOS is coming soon...

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `imobile_for_reactnative` and add `Supermap.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libSupermap.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.supermap.rnsupermap.SupermapPackage;` to the imports at the top of the file
  - Add `new SupermapPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':supermap'
  	project(':supermap').projectDir = new File(rootProject.projectDir, 	'../node_modules/supermap/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':supermap')
  	```

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
  
