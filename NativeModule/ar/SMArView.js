/**
 * Created by JKon 2019/7/31.
 */
import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View,
} from 'react-native'
import PropTypes from 'prop-types'

class SMArView extends React.Component {
  constructor() {
    super()
    this.ARView = {}
  }

  state = {
    viewId: 0,

  }


  static propTypes = {
    ...ViewPropTypes,
  }


  render() {
    return (
      <View style={styles.views}>
      <RCTARView
        ref={ref => this.arview = ref}
        {...this.props}
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
    zIndex: 10,
  },
  view: {
    height: '100%',
    width: '100%',
  },
});


const RCTARView = requireNativeComponent('RCTARView', SMArView)

export default SMArView