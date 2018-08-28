import { NativeModules } from 'react-native';
let E = NativeModules.JSEnvironment;
export default class Environment {

  async setLicensePath(path) {
    try {
      var { isSet } = await E.setLicensePath(path);
      return isSet
    } catch (e) {
      console.error(e);
    }
  }

  async initialization() {
    try {
      var { isInit } = await E.initialization();
      return isInit
    } catch (e) {
      console.error(e);
    }
  }
}