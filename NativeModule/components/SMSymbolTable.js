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

class SMSymbolTable extends React.Component {
  constructor() {
    super()
    this.tableStyle = {}
  }

  state = {
    viewId: 0,

  }

  /**
   * tableStyle: {
      orientation: 滑动方向，默认滑动方向是垂直方向滑动, scrollDirection可取两个值，0代表横向滚动 1代表垂直滚动,
      cellSpacing 同一行的cell中互相之间的最小间隔，设置这个值之后，那么cell与cell之间至少为这个值，若达不到则为0,
      lineSpacing 行与行之间的最小行间距,
      count 一行/列多少item，若为0则自适应,
      imageSize image尺寸，若为0则自适应，若大于计算的cellsize则设为0,
      textSize text字体字号,若为0则自适应为0.25*imagesize,若小于5则为5,
      textColor 设置cell单元格的背景色,
      legendBackgroundColor 设置cell单元格的背景色,
    }
   */
  static propTypes = {
    onSymbolClick: PropTypes.func,
    ...ViewPropTypes,
  }

  _onSymbolClick = ({nativeEvent}) => {
    this.props.onSymbolClick && this.props.onSymbolClick(nativeEvent)
  }

  _onLayout = ({
                 nativeEvent: {
                   layout: { width, height },
                 },
               }) => {
    this.tableStyle = {
      width,
      height,
    }
    this._updateNativeStyles()
  }

  _updateNativeStyles = () => {
    let tableStyle = {}
    Object.assign(tableStyle, this.tableStyle, this.props.tableStyle)
    this.symbolTable && this.symbolTable.setNativeProps({
      tableStyle,
    })
  }

  render() {
    return (
      <View
        style={styles.container}
        onLayout={this._onLayout}>
        <RCTSymbolTable
          ref={ref => this.symbolTable = ref}
          {...this.props}
          onSymbolClick={this._onSymbolClick}
        />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    // backgroundColor: 'yellow',
    margin: 5,
    // backgroundColor: 'blue',
    // alignItems: 'center',
  },
})

const RCTSymbolTable = requireNativeComponent('RCTSymbolTable', SMSymbolTable)

export default SMSymbolTable