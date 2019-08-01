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
    visible: true,
  }

  static propTypes = {
    visible: PropTypes.bool,
    onArObjectClick: PropTypes.func,
    ...ViewPropTypes,
  };

  static defaultProps = {
    visible: true,
  }

  _onArObjectClick = ({nativeEvent}) => {
    this.props.onArObjectClick && this.props.onArObjectClick(nativeEvent)
  }

  setVisible = (visible) => {
    if (this.state.visible === visible) return
    this.setState({
      visible: visible,
    })
  }

  render() {
    var props = { ...this.props };

    if (!this.state.visible) {
      return null
    }

    return (
      <View
        style={styles.views}
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
  views: {
    flex: 1,
    alignSelf: 'stretch',
    backgroundColor: 'transparent',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    flexDirection: 'column',
  },
  view: {
    flex: 1,
    alignSelf: 'stretch',
  },

});

var RCTAIDetectView = requireNativeComponent('RCTAIDetectView', SMAIDetectView)

export default SMAIDetectView