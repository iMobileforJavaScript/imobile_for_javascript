import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View, InteractionManager, Platform
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
    SMeasureView.isSupportedARCore() &&
    this.setState({
      visible: true,
    })
  }

  componentDidUpdate(prevProps) {
  }

  componentWillUnmount() {
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
    // backgroundColor: '#rgba(255, 255, 255, 0)',
  },
});

var RCTMeasureView = requireNativeComponent('RCTMeasureView', SMMeasureView)

export default SMMeasureView