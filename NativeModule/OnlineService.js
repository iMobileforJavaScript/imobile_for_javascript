import { NativeModules } from 'react-native';
let OS = NativeModules.JSOnlineService;


//OnlinService
export default class OnlineService {

  //  Onlin 下载数据文件
  //  String path  文件保存路径
  //  String username   用户名（用于登陆online）
  //  String passworld    密码
  //  String filename     文件名称

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