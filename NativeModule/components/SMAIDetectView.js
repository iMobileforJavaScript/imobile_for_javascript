import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View,
} from 'react-native'
import PropTypes from 'prop-types'
import { scaleSize } from "../../../../src/utils";

class SMAIDetectView extends React.Component {
  constructor() {
    super()
  }

  state = {
    viewId: 0,
  }

  static propTypes = {
    ...ViewPropTypes,
  }

  render() {
    var props = { ...this.props };
    props.returnId = true;

    return (
      <View style={styles.views}>
        <RCTAIDetectView
          {...props}
          style={styles.view}
        />
      </View>
    );
  }
}

var styles = StyleSheet.create({
  views: {
    flex: 1,
    position: 'absolute',
    height: '100%',
    width: '100%',
    backgroundColor: 'transparent',
    zIndex: 1,
  },
  view: {
    height: '100%',
    width: '100%',
  },
});

var RCTAIDetectView = requireNativeComponent('RCTAIDetectView', SMAIDetectView)

export default SMAIDetectView