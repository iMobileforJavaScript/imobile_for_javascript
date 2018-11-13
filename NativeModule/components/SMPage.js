/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:视图控件(搜索控件子控件)。
 
 **********************************************************************************/
'use strict';

var ReactNative = require('react-native');
var React = require('react');
var {
  ScrollView,
  StyleSheet,
  View,
} = ReactNative;

var SMTitle = require('./SMTitle');

var SMPage = React.createClass({

  propTypes: {
    keyboardShouldPersistTaps: React.PropTypes.bool,
    noScroll: React.PropTypes.bool,
    noSpacer: React.PropTypes.bool,
  },

  render: function() {
    var ContentWrapper;
    var wrapperProps = {};
    if (this.props.noScroll) {
      ContentWrapper = View;
    } else {
      ContentWrapper = ScrollView;
      wrapperProps.keyboardShouldPersistTaps = true;
      wrapperProps.keyboardDismissMode = 'interactive';
    }
    var title = this.props.title ?
      <SMTitle title={this.props.title} /> :
      null;
    var spacer = this.props.noSpacer ? null : <View style={styles.spacer} />;
    return (
      <View style={styles.container}>
        {title}
        <ContentWrapper
          style={styles.wrapper}
          {...wrapperProps}>
            {this.props.children}
            {spacer}
        </ContentWrapper>
      </View>
    );
  },
});

var styles = StyleSheet.create({
  container: {
    borderRadius: 4,
    borderWidth: 0.5,
    borderColor: '#d6d7da',
    backgroundColor: '#F7F7F7',
    paddingTop: 15,
    flex: 1,
  },
  spacer: {
    height: 270,
  },
  wrapper: {
    flex: 1,
  },
});

module.exports = SMPage;
