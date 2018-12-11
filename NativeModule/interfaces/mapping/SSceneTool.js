import { NativeModules, Platform } from 'react-native'
let SScene = NativeModules.SScene
function select() {
    try {
      SMap.setAction(Action.SELECT)
    } catch (e) {
      console.error(e)
    }
  }
export {
  }