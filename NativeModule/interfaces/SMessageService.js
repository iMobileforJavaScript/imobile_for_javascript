/**
 * Created by imobile-xzy on 2019/3/13.
 */

import {
  EventConst
} from '../constains/index'
import {NativeModules, Platform, NativeEventEmitter,DeviceEventEmitter} from 'react-native';
let MessageServiceeNative = NativeModules.SMessageService;
const callBackIOS = new NativeEventEmitter(MessageServiceeNative);
let listener = undefined

function register(handlers) {
  try {

    if (handlers && typeof handlers.callback === "function") {
      if (Platform.OS === 'ios' && handlers){
        listener = callBackIOS.addListener(EventConst.MESSAGE_SERVICE_RECEIVE, function (e) {
          handlers.callback(e)
        })
      } else if (Platform.OS === 'android' ) {

        listener = DeviceEventEmitter.addListener(EventConst.MESSAGE_SERVICE_RECEIVE, function (e) {
          handlers.callback(e);
        });
      }
    }
  } catch (error) {
    console.log(error)
  }
}

function unRegister() {
  try {
    listener.remove()
  } catch (error) {
    console.log(error)
  }
}
// 连接服务
function connectService(ip, port,hostName,userName,passwd,userID) {
  return MessageServiceeNative.connectService(ip, port,hostName,userName,passwd,userID);
}
//断开服务链接
function disconnectionService() {
  unRegister()
  return MessageServiceeNative.disconnectionService();
}
//消息发送
function sendMessage(message, targetID) {
  return MessageServiceeNative.sendMessage(message,targetID);
}
//文件发送
function sendFile(connectInfo, message, filePath, talkId, msgId) {
  return MessageServiceeNative.sendFile(connectInfo, message, filePath, talkId, msgId);
}
//声明多人会话
function declareSession(memmbers,uuid) {
  return MessageServiceeNative.declareSession(memmbers,uuid);
}

//退出多人会话
function exitSession(memmber,uuid) {
  return MessageServiceeNative.exitSession(memmber,uuid);
}

//开启消息接收
function receiveMessage(uuid) {
  return MessageServiceeNative.receiveMessage(uuid);
}

//开启文件接收
function receiveFile(fileName, queueName, receivePath, talkId, msgId) {
  return MessageServiceeNative.receiveFile(fileName, queueName, receivePath, talkId, msgId);
}

//开启消息接收
function startReceiveMessage(uuid,handle) {
  register(handle);
  return MessageServiceeNative.startReceiveMessage(uuid);
}

//挂起操作，用于APP状态切换后台
function suspend() {
  return MessageServiceeNative.suspend();
}

//开启消息接收
function resume() {
  return MessageServiceeNative.resume();
}

//恢复操作，用户APP唤醒
function stopReceiveMessage() {
  return MessageServiceeNative.stopReceiveMessage();
}

export default {
  receiveMessage,
  stopReceiveMessage,
  startReceiveMessage,
  exitSession,
  declareSession,
  sendFile,
  sendMessage,
  receiveFile,
  disconnectionService,
  connectService,
  resume,
  suspend,
}