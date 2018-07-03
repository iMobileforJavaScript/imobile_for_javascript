/**
 * Created by will on 2016/7/13.
 */
import { NativeModules } from 'react-native';
let SU = NativeModules.JSSystemUtil;

/**
 * @class Point - 像素点类。用于标示移动设备屏幕的像素点。
 */
export default class SystemUtil{
    /**
     * 获取沙盒路径
     * @returns {Promise.<string>}
     */
    async getHomeDirectory(){
        try{
            var {homeDirectory} = await SU.getHomeDirectory();
            return homeDirectory;
        }catch (e){
            console.error(e);
        }
    }
  
  /**
   * 获取文件夹中的目录内容
   * @param path
   * @returns {Promise}
   */
  async getDirectoryContent(path){
    try{
      let directoryContent = await SU.getDirectoryContent(path);
      return directoryContent;
    }catch (e){
      console.error(e);
    }
  }
  
  /**
   * 判断文件是否存在
   * @param path
   * @returns {Promise}
   */
  async fileIsExist(path){
    try{
      let { isExist } = await SU.fileIsExist(path);
      return isExist;
    }catch (e){
      console.error(e);
    }
  }
  
  /**
   * 判断文件是否存在在Home Directory中
   * @param path
   * @returns {Promise}
   */
  async fileIsExistInHomeDirectory(path){
    try{
      let { isExist } = await SU.fileIsExistInHomeDirectory(path);
      return isExist;
    }catch (e){
      console.error(e);
    }
  }
}
