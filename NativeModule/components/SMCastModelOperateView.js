import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View, InteractionManager, Platform
} from "react-native";
import PropTypes from 'prop-types'
import {
  SCastModelOperateView,
} from 'imobile_for_reactnative'
import Orientation from "react-native-orientation"
// import constants from "../../../../src/containers/workspace/constants"

/**
 * AR投射
 */
class SMCastModelOperateView extends React.Component {

  props: {
    language: String,
  }

  constructor() {
    super()
  }

  state = {
    viewId: 0,
  }

  static propTypes = {
    ...ViewPropTypes,
  };

  componentWillMount() {
    Orientation.lockToPortrait()
  }

  componentDidMount() {
  }

  componentDidUpdate(prevProps) {
  }

  componentWillUnmount() {
    SCastModelOperateView.onDestroy()
  }

  render() {
    var props = { ...this.props };

    return (
      <View
        style={styles.container}
      >
        <RCTCastModelOperateView
          ref={ref => this.RCTCastModelOperateView = ref}
          {...props}
          style={styles.view}
        />
      </View>
    );
  }
}

var styles = StyleSheet.create({
  view: {
    flex: 1,
    alignSelf: 'stretch',
  },
  container: {
    position: 'absolute',
    top: 45,
    bottom: 0,
    left: 0,
    right: 0,
    // backgroundColor: '#rgba(255, 255, 255, 0)',
  },
});

var RCTCastModelOperateView = requireNativeComponent('RCTCastModelOperateView', SMCastModelOperateView)

export default SMCastModelOperateView