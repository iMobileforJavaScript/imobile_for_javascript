import {NativeModules, NativeEventEmitter} from 'react-native';
import { EventConst } from '../../constains'
let SpeechRecognizerNative = NativeModules.SSpeechRecognizer;
const nativeEvt = new NativeEventEmitter(SpeechRecognizerNative);
let beginListener, endlistener, errorListener, resultListener, voluemChangeListener, eventListener

function init (AppID) {
    return SpeechRecognizerNative.init(AppID)
}

function addListenser(handlers) {
    try {
        beginListener && beginListener.remove()
        endlistener && endlistener.remove()
        errorListener && errorListener.remove()
        resultListener &&  resultListener.remove()
        voluemChangeListener && voluemChangeListener.remove()
        eventListener && eventListener.remove()
        if (typeof handlers.onBeginOfSpeech === "function") {
            beginListener = nativeEvt.addListener(EventConst.RECOGNIZE_BEGIN, function () {
              handlers.onBeginOfSpeech()
            })
          }
          if (typeof handlers.onEndOfSpeech === "function") {
            endlistener = nativeEvt.addListener(EventConst.RECOGNIZE_END, function () {
              handlers.onEndOfSpeech()
            })
          }
          if (typeof handlers.onError === "function") {
            errorListener = nativeEvt.addListener(EventConst.RECOGNIZE_ERROR, function (e) {
              handlers.onError(e)
            })
          }
          if (typeof handlers.onResult === "function") {
            resultListener = nativeEvt.addListener(EventConst.RECOGNIZE_RESULT, function (e) {
              handlers.onResult(e)
            })
          }
          if (typeof handlers.onVolumeChanged === "function") {
            voluemChangeListener = nativeEvt.addListener(EventConst.RECOGNIZE_VOLUME_CHANGED, function (e) {
              handlers.onVolumeChanged(e)
            })
          }
          if (typeof handlers.onEvent === "function") {
             resultListener = nativeEvt.addListener(EventConst.RECOGNIZE_EVENT, function (e) {
               handlers.onEvent(e)
            })
          }
    } catch(e) {
        console.warn(e)
    }
    
}

function removeListener() {
    try {
        beginListener && beginListener.remove()
        endlistener && endlistener.remove()
        errorListener && errorListener.remove()
        resultListener &&  resultListener.remove()
        voluemChangeListener && voluemChangeListener.remove()
        eventListener && eventListener.remove()
    } catch(e) {
        console.warn(e)
    }
}

function start() {
    return SpeechRecognizerNative.start()
}

function cancel() {
    return SpeechRecognizerNative.cancel()
}

function isListening() {
    return SpeechRecognizerNative.isListening()
}

function stop() {
    return SpeechRecognizerNative.stop()
}

function setParameter(parameter, value) {
    return SpeechRecognizerNative.setParameter(parameter, value)
}

function getParameter(parameter) {
    return SpeechRecognizerNative.getParameter(parameter)
}

export default {
    init,
    addListenser,
    removeListener,
    start,
    cancel,
    isListening,
    stop,
    setParameter,
    getParameter,
}