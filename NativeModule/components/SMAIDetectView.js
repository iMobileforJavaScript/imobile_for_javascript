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

    this.state = {
      viewId: 0,
      visible: false,
    }
  }

  static propTypes = {
    visible: PropTypes.bool,
    onArObjectClick: PropTypes.func,
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
    // if (this.state.visible) {
    //   SAIDetectView.initAIDetect()
    //   SAIDetectView.startDetect()
    // }
  }

  componentWillUnmount() {
    GLOBAL.Type === constants.MAP_AR && this.state.visible && SAIDetectView.dispose()
  }

  _onArObjectClick = ({nativeEvent}) => {
    this.props.onArObjectClick && this.props.onArObjectClick(nativeEvent)
  }

  setVisible = (visible) => {
    if (this.state.visible === visible) return
    this.setState({
      visible: visible,
    }, () => {
      if (visible) {
        // SAIDetectView.initAIDetect()
        // SAIDetectView.startDetect()
      } else {
        SAIDetectView.dispose()
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