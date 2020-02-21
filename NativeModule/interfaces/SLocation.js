import { NativeModules, NativeEventEmitter } from 'react-native'
import { EventConst } from '../constains'

let nativeLocation = NativeModules.SLocation
const eventEmitter = new NativeEventEmitter(nativeLocation);
let deviceListener = undefined

async function openGPS() {
    try {
      return nativeLocation.openGPS()
    } catch (e) {
      console.error(e)
    }
  }
  
  async function closeGPS() {
    try {
      return nativeLocation.closeGPS()
    } catch (e) {
      console.error(e)
    }
  }
  
  async function changeDevice(device) {
    try {
      await nativeLocation.closeGPS()
      await nativeLocation.setDeviceName(device)
      await nativeLocation.openGPS()
    } catch (e) {
      console.error(e)
    }
  }
  
  
  async function setDeviceName(name) {
    try {
      return nativeLocation.setDeviceName(name)
    } catch (e) {
      console.error(e)
    }
  }
  
  async function searchDevice(isSearch) {
    try {
      return nativeLocation.searchDevice(isSearch)
    } catch (e) {
      console.error(e)
    }
  }
  
  function addDeviceListener(callback) {
    try{
        removeDeviceListener()
        if(callback && typeof callback === 'function') {
            deviceListener = eventEmitter.addListener(EventConst.LOCATION_SEARCH_DEVICE, function (e) {
            callback(e)
            })
        }
    } catch(e) {
      console.warn(e)
    }
  }
  
  function removeDeviceListener() {
    deviceListener && deviceListener.remove()
    deviceListener = undefined
  }

  export default {
    openGPS,
    closeGPS,
    changeDevice,
    setDeviceName,
    searchDevice,
    addDeviceListener,
    removeDeviceListener,
  }