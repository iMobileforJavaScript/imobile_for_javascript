/**
 * Created by Yang Shanglong on 2018/11/21.
 */
import * as React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  StyleSheet,
  View,
} from 'react-native'
import PropTypes from 'prop-types'

class SMRLegendView extends React.Component {
  constructor() {
    super()
    this.tableStyle = {}
  }

  state = {
    viewId: 0,

  }


  static propTypes = {
    ...ViewPropTypes,
  }


  render() {
    return (
        <RCTLegendView
          ref={ref => this.legendview = ref}
          {...this.props}
        />
    )
  }
}


const RCTLegendView = requireNativeComponent('RCTLegendView', SMRLegendView)

export default SMRLegendView