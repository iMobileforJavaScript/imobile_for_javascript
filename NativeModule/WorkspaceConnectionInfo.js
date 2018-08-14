/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
var { NativeModules } = require('react-native');
let WCI = NativeModules.JSWorkspaceConnectionInfo;

/**
 * @class WorkspaceConnectionInfo
 * @description 工作空间连接信息类。
 */
export default class WorkspaceConnectionInfo {
  /**
   * 创建一个WorkspaceConnectionInfo对象
   * @memberOf WorkspaceConnectionInfo
   * @returns {Promise.<WorkspaceConnectionInfo>}
   */
  async createJSObj() {
    try {
      var { ID } = await WCI.createJSObj();
      var workspaceConnectionInfo = new WorkspaceConnectionInfo();
      workspaceConnectionInfo._SMWorkspaceConnectionInfoId = ID;
      return workspaceConnectionInfo;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置工作空间类型
   * @memberOf WorkspaceConnectionInfo
   * @param {number} type - {@link Workspace}
   * @returns {Promise.<void>}
   */
  async setType(type) {
    try {
      await WCI.setType(this._SMWorkspaceConnectionInfoId, type);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置工作空间路径
   * @memberOf WorkspaceConnectionInfo
   * @param path
   * @returns {Promise.<void>}
   */
  async setServer(path) {
    try {
      await WCI.setServer(this._SMWorkspaceConnectionInfoId, path);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置工作空间密码
   * @memberOf WorkspaceConnectionInfo
   * @param path
   * @returns {Promise.<void>}
   */
  async setPassWord(passWord) {
    try {
      await WCI.setPassWord(this._SMWorkspaceConnectionInfoId, passWord);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置工作空间名称
   * @param name
   * @returns {Promise.<void>}
   */
  async setName(name) {
    try {
      await WCI.setName(this._SMWorkspaceConnectionInfoId, name);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置登录数据库的用户名
   * @param name
   * @returns {Promise.<void>}
   */
  async setUser(name) {
    try {
      await WCI.setUser(this._SMWorkspaceConnectionInfoId, name);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取工作空间名称
   * @returns {Promise.<*>}
   */
  async getName() {
    try {
      let { Name } = await WCI.getName(this._SMWorkspaceConnectionInfoId);
      return Name;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取工作空间密码
   * @returns {Promise.<*>}
   */
  async getPassword() {
    try {
      let { Password } = await WCI.getPassword(this._SMWorkspaceConnectionInfoId);
      return Password;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取工作空间文件名
   * @returns {Promise.<*>}
   */
  async getServer() {
    try {
      let { Server } = await WCI.getServer(this._SMWorkspaceConnectionInfoId);
      return Server;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取工作空间用户名
   * @returns {Promise.<*>}
   */
  async getUser() {
    try {
      let { User } = await WCI.getUser(this._SMWorkspaceConnectionInfoId);
      return User;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取工作空间类型
   * @returns {Promise.<*>}
   */
  async getType() {
    try {
      let { Type } = await WCI.getType(this._SMWorkspaceConnectionInfoId);
      return Type;
    } catch (e) {
      console.error(e);
    }
  }
  
}
