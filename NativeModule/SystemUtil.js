/**
 * Created by will on 2016/7/13.
 */
import { NativeModules, Platform } from 'react-native';
let FU = NativeModules.SMFileUtil;
let ZA = NativeModules.JSZipArchive;

/**
 * @class Point - 像素点类。用于标示移动设备屏幕的像素点。
 */
export default class SystemUtil {
  /**
   * 获取沙盒路径
   * @returns {Promise.<string>}
   */
  async getHomeDirectory() {
    try {
      var { homeDirectory } = await FU.getHomeDirectory();
      return homeDirectory;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取文件夹中的目录内容
   * @param path
   * @returns {Promise}
   */
  async getDirectoryContent(path) {
    try {
      let directoryContent = await FU.getDirectoryContent(path);
      return directoryContent;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判断文件是否存在
   * @param path
   * @returns {Promise}
   */
  async fileIsExist(path) {
    try {
      let { isExist } = await FU.fileIsExist(path);
      return isExist;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判断文件是否存在在Home Directory中
   * @param path
   * @returns {Promise}
   */
  async fileIsExistInHomeDirectory(path) {
    try {
      let { isExist } = await FU.fileIsExistInHomeDirectory(path);
      return isExist;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 创建文件目录
   * @param path - 绝对路径
   * @returns {Promise}
   */
  async createDirectory(path) {
    try {
      return await FU.createDirectory(path);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取文件夹内容
   * @param path
   * @returns {Promise}
   */
  async getPathList(path) {
    try {
      let fileList = await FU.getPathList(path);
      return fileList;
      
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据过滤条件获取文件夹内容
   * @param path
   * @param filter  {name: 文件名, type: 文件类型}
   * @returns {Promise}
   */
  async getPathListByFilter(path, filter) {
    try {
      let fileList = await FU.getPathListByFilter(path, filter);
      return fileList;
      
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判断是否是文件夹
   * @param path
   * @returns {Promise.<Promise|*>}
   */
  async isDirectory(path) {
    try {
      let reFUlt = await FU.isDirectory(path);
      return reFUlt;
    } catch (e) {
      console.error(e);
    }
  }
  
  async zipFile(filePath, targetDir) {
    try {
      let reFUlt;
      if (Platform.OS === 'ios') {
        reFUlt = await ZA.zipFile(filePath, targetDir);
      } else {
        reFUlt = await FU.zipFile(filePath, targetDir);
      }
      return reFUlt;
    } catch (e) {
      console.error(e);
    }
  }
  
  async unzipFile(zipFile, targetPath) {
    try {
      let reFUlt;
      if (Platform.OS === 'ios') {
        reFUlt = await ZA.unzipFile(zipFile,targetPath);
      } else {
        reFUlt = await FU.unzipFile(zipFile,targetPath);
      }
      return reFUlt;
    } catch (e) {
      console.error(e);
    }
  }
  
  async deleteFile(zipFile) {
    try {
      let reFUlt;
      if (Platform.OS === 'ios') {
        reFUlt = await ZA.deleteFile(zipFile);
      } else {
        reFUlt = await FU.deleteFile(zipFile);
      }
      await reFUlt;
    } catch (e) {
      console.error(e);
    }
  }
    async readFile(filePath) {
        try {
            let {reFUlt} = {};
            if (Platform.OS === 'ios') {
                reFUlt = await ZA.readFile(filePath);
            } else {
                reFUlt = await FU.readFile(filePath);
            }
            return reFUlt;
        } catch (e) {
            console.error(e);
        }
    }
    async writeFile(filePath,strJson) {
        try {
            let reFUlt;
            if (Platform.OS === 'ios') {
                reFUlt = await ZA.writeToFile(filePath,strJson);
            } else {
                reFUlt = await FU.writeToFile(filePath,strJson);
            }
            return reFUlt;
        } catch (e) {
            console.error(e);
        }
    }
}

