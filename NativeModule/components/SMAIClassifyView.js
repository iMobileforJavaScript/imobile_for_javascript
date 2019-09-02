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

  static propTypes = {
    ...ViewPropTypes,
  };

  static defaultProps = {
  }

  componentWillUnmount() {
    SAIClassifyView.dispose()
  }

  render() {
    var props = { ...this.props };

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
  },
});

var RCTAIClassifyView = requireNativeComponent('RCTAIClassifyView', SMAIClassifyView)

export default SMAIClassifyView