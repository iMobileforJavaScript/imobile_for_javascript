import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View, InteractionManager, Platform,
  AppState,
} from "react-native";
import PropTypes from 'prop-types'
import { scaleSize } from "../../../../src/utils";
import { getLanguage } from "../../../../src/language";
import {
  SMeasureView,
} from 'imobile_for_reactnative'
import constants from "../../../../src/containers/workspace/constants"

class SMMeasureView extends React.Component {

  constructor() {
    super()

    this.state = {
      viewId: 0,
      visible: false,
    }
    AppState.addEventListener('change', this.handleStateChange)
    this.stateChangeCount = 0
  }

  static propTypes = {
    visible: PropTypes.bool,
    ...ViewPropTypes,
  };

  static defaultProps = {
    visible: false,
  }

  componentDidMount() {
    GLOBAL.Type === constants.MAP_AR &&
    this.setState({
      visible: true,
    })
  }

  componentDidUpdate(prevProps) {
  }

  componentWillUnmount() {
    AppState.removeEventListener('change', this.handleStateChange)
  }

  /************************** 处理状态变更 ***********************************/

  handleStateChange = async appState => {
    if (Platform.OS === 'android') {
      return
    }
    if (appState === 'inactive') {
      return
    }
    let count = this.stateChangeCount + 1
    this.stateChangeCount = count
    if (this.stateChangeCount !== count) {
      return
    } else if (this.prevAppstate === appState) {
      return
    } else {
      this.prevAppstate = appState
      this.stateChangeCount = 0
      if (appState === 'active') {
        SMeasureView.startARSession()
      } else if (appState === 'background') {
        // this.disconnectService()
        SMeasureView.endARSession()
      }
    }
  }

  setVisible = (visible) => {
    if (this.state.visible === visible) return
    this.setState({
      visible: visible,
    }, () => {
      if (visible) {
        SMeasureView.setEnableSupport(true)
      } else {
      }
    })
  }

  render() {
    var props = { ...this.props };

    if (!this.state.visible) {
      return null
    }

    return (
      <View
        style={styles.container}
      >
        <RCTMeasureView
          ref={ref => this.RCTMeasureView = ref}
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
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'transparent',
  },
});

var RCTMeasureView = requireNativeComponent('RCTMeasureView', SMMeasureView)

export default SMMeasureView