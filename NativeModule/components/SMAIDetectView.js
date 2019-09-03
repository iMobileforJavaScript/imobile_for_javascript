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
  SAIDetectView,
} from 'imobile_for_reactnative'
import constants from "../../../../src/containers/workspace/constants"

class SMAIDetectView extends React.Component {

  constructor() {
    super()
  }

  state = {
    viewId: 0,
  }

  static propTypes = {
    onArObjectClick: PropTypes.func,
    ...ViewPropTypes,
  };

  componentDidUpdate(prevProps) {
  //   SAIDetectView.initAIDetect()
  //   SAIDetectView.startDetect()
  }

  componentWillUnmount() {
    SAIDetectView.dispose()
  }

  _onArObjectClick = ({nativeEvent}) => {
    this.props.onArObjectClick && this.props.onArObjectClick(nativeEvent)
  }

  render() {
    var props = { ...this.props };

    return (
      <View
        style={styles.container}
      >
        <RCTAIDetectView
          ref={ref => this.RCTAIDetectView = ref}
          {...props}
          style={styles.view}
          onArObjectClick={this._onArObjectClick}
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

var RCTAIDetectView = requireNativeComponent('RCTAIDetectView', SMAIDetectView)

export default SMAIDetectView