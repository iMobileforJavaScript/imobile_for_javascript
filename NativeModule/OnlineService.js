import { NativeModules } from 'react-native';
let OS = NativeModules.JSOlineService;



//OnlinService 
export default class OlineService{

  //  Onlin 下载数据文件
  //  String path  文件保存路径
  //  String username   用户名（用于登陆online）
  //  String passworld    密码
  //  String filename     文件名称

  async Download(path, username, passworld, filename) {
    try {
      debugger
      let result=OS.Download(path,username,passworld,filename)
      return result;
    } catch (e) {
      console.error(e);
    }
  }

}