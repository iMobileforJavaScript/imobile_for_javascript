import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View, InteractionManager, Platform
} from "react-native";
import PropTypes from 'prop-types'
import {
  SIllegallyParkView,
} from 'imobile_for_reactnative'
import constants from "../../../../src/containers/workspace/constants"

/**
 * 违章采集
 */
class SMIllegallyParkView extends React.Component {

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

  componentDidUpdate(prevProps) {
    // SIllegallyParkView.init(this.props.language)
  }

  componentWillUnmount() {
    SIllegallyParkView.onDestroy()
  }

  render() {
    var props = { ...this.props };

    return (
      <View
        style={styles.container}
      >
        <RCTIllegallyParkView
          ref={ref => this.RCTIllegallyParkView = ref}
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

var RCTIllegallyParkView = requireNativeComponent('RCTIllegallyParkView', SMIllegallyParkView)

export default SMIllegallyParkView