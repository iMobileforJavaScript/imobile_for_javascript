/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/
import { NativeModules, NativeEventEmitter } from 'react-native'
let SM = NativeModules.JSSpeechManager
const nativeEvt = new NativeEventEmitter(SM)

const BEGIN_OF_SPEECH = "com.supermap.RN.JSSpeechManager.begin_of_speech"
const END_OF_SPEECH = "com.supermap.RN.JSSpeechManager.end_of_speech"
const ERROR = "com.supermap.RN.JSSpeechManager.error"
const RESULT = "com.supermap.RN.JSSpeechManager.result"
const VOLUME_CHANGED = "com.supermap.RN.JSSpeechManager.volume_changed"

/**
 * 语音识别类 不支持多线程
 */
export default class SpeechManager {
  /**
   * 初始化语音SDK组件(只能在主线程中调用)，只需在应用启动时调用一次就够了
   * @returns {Promise.<void>}
   */
  async init() {
    try {
      await SM.init()
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 通过此函数取消当前的会话
   * @returns {Promise.<void>}
   */
  async cancel() {
    try {
      await SM.cancel()
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 在调用本函数进行销毁前，应先保证当前不在会话中，否则，本函数将尝试取消当前会话，并返回false，此时销毁失败
   * @returns {Promise.<void>}
   */
  async destroy() {
    try {
      await SM.destroy()
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 通过此函数，获取当前SDK是否正在进行会话
   * @returns {Promise.<Recordset>}
   */
  async isListening() {
    try {
      return await SM.isListening()
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 设置音频保存路径:(目前支持音频文件格式为wav格式) 通过此参数，可以在识别完成后在本地保存一个音频文件
   * 是否必须设置：否 默认值：null (不保存音频文件)
   * 值范围：有效的文件相对或绝对路径（含文件名
   * 例如：Environment.getExternalStorageDirectory() + "/msc/speech.wav"
   * @param path
   * @returns {Promise.<void>}
   */
  async setAudioPath(path) {
    try {
      await SM.setAudioPath(path)
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
   * 是否必须设置：否 默认值：听写5000，其他4000 值范围：[1000, 10000]
   * @param time
   * @returns {Promise.<Promise.count>}
   */
  async setVAD_BOS_Time(time) {
    try {
      await SM.setVAD_BOS_Time(time)
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入，自动停止录音
   * 是否必须设置：否 默认值：听写1800，其他700 值范围：[0, 10000]
   * @param time
   * @returns {Promise.<void>}
   */
  async setVAD_EOS_Time(time) {
    try {
      await SM.setVAD_EOS_Time(time)
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 调用本函数告知SDK，当前会话音频已全部录入
   * @returns {Promise.<void>}
   */
  async stopListening() {
    try {
      await SM.stopListening()
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 调用此函数，开始语音听写
   * @param handlers
   * @returns {Promise.<void>}
   */
  async startListening(handlers) {
    try {
      await SM.startListening()
      if (typeof handlers.onBeginOfSpeech === "function") {
        nativeEvt.addListener(BEGIN_OF_SPEECH, function () {
          handlers.onBeginOfSpeech()
        })
      }
      if (typeof handlers.onEndOfSpeech === "function") {
        nativeEvt.addListener(END_OF_SPEECH, function () {
          handlers.onEndOfSpeech()
        })
      }
      if (typeof handlers.onVolumeChanged === "function") {
        nativeEvt.addListener(VOLUME_CHANGED, function (e) {
          handlers.onVolumeChanged(e)
        })
      }
      if (typeof handlers.onError === "function") {
        nativeEvt.addListener(ERROR, function (e) {
          handlers.onError(e)
        })
      }
      if (typeof handlers.onResult === "function") {
        nativeEvt.addListener(RESULT, function (e) {
          handlers.onResult(e)
        })
      }
    } catch (e) {
      console.log(e)
    }
  }
}
