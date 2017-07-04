/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:工作空间管理控件控件，用于对工作空间的数据进行管理。
 
 **********************************************************************************/

'use strict';
  var ReactNative =require('react-native');
  var React = require('react');
  var {
      PixelRatio,
      Navigator,
      ScrollView,
      StyleSheet,
      Text,
      TouchableHighlight,
      TouchableOpacity,
      View,
  } = ReactNative;

class NavButton extends React.Component {
    render() {
        return (
                <TouchableHighlight
                style={styles.button}
                underlayColor="#B5B5B5"
                onPress={this.props.onPress}>
                <Text style={styles.buttonText}>{this.props.text}</Text>
                </TouchableHighlight>
                );
    }
}

var NavigationBarRouteMapper = {
    
LeftButton: function(route, navigator, index, navState) {
    if (index === 0) {
        return null;
    }
    
    var previousRoute = navState.routeStack[index - 1];
    return (
            <TouchableOpacity
            onPress={() => navigator.pop()}>
            <View style={styles.navBarLeftButton}>
            <Text style={[styles.navBarText, styles.navBarButtonText]}>
            <
            </Text>
            </View>
            </TouchableOpacity>
            );
},
    
Title: function(route, navigator, index, navState) {
    return (
            <Text style={[styles.navBarText, styles.navBarTitleText]}>
            工作空间管理
            </Text>
            );
},
    
};

var SMWorkSpaceControlView = React.createClass({
                                            
  render: function() {
    return (
      <Navigator
        debugOverlay={false}
        style={styles.appContainer}
            initialRoute={()=>{return {title: '工作空间管理'}}}
        renderScene={(route, navigator) => (
          <ScrollView style={styles.scene}>
            <Text style={styles.messageText}>World</Text>
            <NavButton
              onPress={() => {
//                navigator.immediatelyResetRouteStack([
//                  newRandomRoute(),
//                  newRandomRoute(),
//                  newRandomRoute(),
//                ]);
                                            console.log('click');
              }}
              text="World2"
            />
            <NavButton
              onPress={() => {
                this.props.navigator.pop();
              }}
              text="pop"
            />
          </ScrollView>
        )}
        navigationBar={
          <Navigator.NavigationBar
            routeMapper={NavigationBarRouteMapper}
            style={styles.navBar}
          />
        }
      />
    );
  },
                                            
});

var styles = StyleSheet.create({
                               messageText: {
                               fontSize: 17,
                               fontWeight: '500',
                               padding: 15,
                               marginTop: 50,
                               marginLeft: 15,
                               },
                               button: {
                               backgroundColor: 'white',
                               padding: 15,
                               borderBottomWidth: 1 / PixelRatio.get(),
                               borderBottomColor: '#CDCDCD',
                               },
                               buttonText: {
                               fontSize: 17,
                               fontWeight: '500',
                               },
                               navBar: {
                               backgroundColor: 'white',
                               },
                               navBarText: {
                               fontSize: 16,
                               marginVertical: 10,
                               },
                               navBarTitleText: {
                               color: cssVar('fbui-bluegray-60'),
                               fontWeight: '500',
                               marginVertical: 9,
                               },
                               navBarLeftButton: {
                               paddingLeft: 10,
                               },
                               navBarRightButton: {
                               paddingRight: 10,
                               },
                               navBarButtonText: {
                               color: cssVar('fbui-accent-blue'),
                               },
                               scene: {
                               flex: 1,
                               paddingTop: 20,
                               backgroundColor: '#EAEAEA',
                               },
                               });

module.exports = SMWorkSpaceControlView;
