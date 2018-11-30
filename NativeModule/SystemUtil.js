/**
 * Created by will on 2016/7/13.
 */
import { NativeModules, Platform } from 'react-native';
let SU = NativeModules.JSSystemUtil;
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
      var { homeDirectory } = await SU.getHomeDirectory();
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
      let directoryContent = await SU.getDirectoryContent(path);
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
      let { isExist } = await SU.fileIsExist(path);
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
      let { isExist } = await SU.fileIsExistInHomeDirectory(path);
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
      return await SU.createDirectory(path);
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
      let fileList = await SU.getPathList(path);
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
      let fileList = await SU.getPathListByFilter(path, filter);
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
      let result = await SU.isDirectory(path);
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  
  async zipFile(filePath, targetDir) {
    try {
      let result;
      if (Platform.OS === 'ios') {
        result = await ZA.zipFile(filePath, targetDir);
      } else {
        result = await SU.zipFile(filePath, targetDir);
      }
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  
  async unzipFile(zipFile, targetDir) {
    try {
      let result;
      if (Platform.OS === 'ios') {
        result = await ZA.unzipFile(zipFile,targetDir);
      } else {
        result = await SU.unzipFile(zipFile,targetDir);
      }
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  
  async deleteFile(zipFile) {
    try {
      let result;
      if (Platform.OS === 'ios') {
        result = await ZA.deleteFile(zipFile);
      } else {
        result = await SU.deleteFile(zipFile);
      }
      await result;
    } catch (e) {
      console.error(e);
    }
  }
    async readFile(filePath) {
        try {
            let {result} = {};
            if (Platform.OS === 'ios') {
                result = await ZA.readFile(filePath);
            } else {
                result = await SU.readFile(filePath);
            }
            return result;
        } catch (e) {
            console.error(e);
        }
    }
    async writeFile(filePath,strJson) {
        try {
            let result;
            if (Platform.OS === 'ios') {
                result = await ZA.writeToFile(filePath,strJson);
            } else {
                result = await SU.writeToFile(filePath,strJson);
            }
            return result;
        } catch (e) {
            console.error(e);
        }
    }
}

