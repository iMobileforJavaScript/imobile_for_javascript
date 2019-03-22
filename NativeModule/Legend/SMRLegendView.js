/**
 * Created by Yang Shanglong on 2018/11/21.
 */
import * as React from 'react'
import {
  requireNativeComponent,
  View,
} from 'react-native'

class SMRLegendView extends React.Component {
  constructor() {
    super()
    this.tableStyle = {}
  }


  render() {
    return (
      <View style={{flex: 1}}>
        <SMLegendView
          {...this.props}
        />
      </View>
    )
  }
}


const SMLegendView = requireNativeComponent('RCTLegend', SMRLegendView)

export default SMRLegendView