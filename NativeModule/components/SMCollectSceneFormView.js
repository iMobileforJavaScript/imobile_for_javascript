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
import constants from "../../../../src/containers/workspace/constants"

class SMCollectSceneFormView extends React.Component {

  constructor() {
    super()

    this.state = {
      viewId: 0,
      visible: true,
    }
  }

  static propTypes = {
    visible: PropTypes.bool,
    onArObjectClick: PropTypes.func,
    ...ViewPropTypes,
  };

  static defaultProps = {
    visible: true,
  }

  componentDidMount() {
  }

  componentDidUpdate(prevProps) {
  }

  componentWillUnmount() {
  }

  render() {
    var props = { ...this.props };

    return (
      <View
        style={styles.container}
      >
        <RCTCollectSceneFormView
          ref={ref => this.RCTCollectSceneFormView = ref}
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
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'white',
  },
});

var RCTCollectSceneFormView = requireNativeComponent('RCTCollectSceneFormView', SMCollectSceneFormView)

export default SMCollectSceneFormView