import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View, InteractionManager, Platform, DeviceEventEmitter
} from "react-native";
import PropTypes from 'prop-types'
import { scaleSize } from "../../../../src/utils";
import { getLanguage } from "../../../../src/language";
import {
  SAIClassifyView,
} from 'imobile_for_reactnative'
import constants from "../../../../src/containers/workspace/constants"

class SMAIClassifyView extends React.Component {

  constructor() {
    super()

    this.state = {
      viewId: 0,
      visible: true,
    }
  }

  static propTypes = {
    visible: PropTypes.bool,
    ...ViewPropTypes,
  };

  static defaultProps = {
    visible: true,
  }

  componentDidMount() {
    InteractionManager.runAfterInteractions(() => {
      // (async function() {
      //   GLOBAL.Type === constants.MAP_AR &&
      //   this.setState({
      //     visible: true,
      //   })
      // }.bind(this)())
    })
  }

  componentDidUpdate(prevProps) {
    // SAIClassifyView.startPreview()
  }

  componentWillUnmount() {
    SAIClassifyView.dispose()
  }

  setVisible = (visible) => {
    if (this.state.visible === visible) return
    this.setState({
      visible: visible,
    }, () => {
      if (visible) {
        SAIClassifyView.startPreview()
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
        <RCTAIClassifyView
          ref={ref => this.RCTAIClassifyView = ref}
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

var RCTAIClassifyView = requireNativeComponent('RCTAIClassifyView', SMAIClassifyView)

export default SMAIClassifyView