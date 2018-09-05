import { NativeModules } from 'react-native';
let OS = NativeModules.JSOnlineService;


//OnlinService
export default class OnlineService {
  async download(path, filename) {
    try {
      let result = OS.download(path, filename)
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  async login(username, passworld) {
    try {
      let result = OS.login(username, passworld)
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  async logout() {
    try {
      let result = OS.logout()
      return result;
    } catch (e) {
      console.error(e);
    }
  }
}