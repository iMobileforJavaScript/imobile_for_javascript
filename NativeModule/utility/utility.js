/**
 * Created by will on 2017/3/3.
 */
/**
 * 原生Point类点的x，y坐标，转地图坐标Point2D
 * @param x
 * @param y
 * @returns {Promise.<Point2D>}
 * @constructor
 */

import Point from '../Point';
import SystemUtil from '../SystemUtil';
const util = new SystemUtil();

exports.Point2Map = async function (map, x, y) {
  let pointFac = new Point();
  let point = await pointFac.createObj(x, y);
  return await map.pixelToMap(point);
}

exports.appendingHomeDirectory = async function (path = '') {
  let homeDirectory = await util.getHomeDirectory();
  return homeDirectory + path;
}

exports.getDirectoryContent = async function (path) {
  return await util.getDirectoryContent(path);
}

exports.fileIsExist = async function (path) {
  return await util.fileIsExist(path);
}

exports.fileIsExistInHomeDirectory = async function (path) {
  return await util.fileIsExistInHomeDirectory(path);
}

exports.createDirectory = async function (path) {
  return await util.createDirectory(path);
}

exports.getPathList = async function (path) {
  return await util.getPathList(path);
}

exports.isDirectory = async function (path) {
  return await util.isDirectory(path);
}

exports.getPathListByFilter = async function (path, {name = '', type = ''}) {
  return await util.getPathListByFilter(path, {name, type});
}

exports.zipFile = async function (filePath, targetPath) {
  return await util.zipFile(filePath, targetPath);
}

exports.unZipFile = async function (zipFile, targetDir) {
  return await util.unZipFile(zipFile, targetDir);
}

exports.deleteFile = async function (file) {
  return await util.deleteFile(file);
}
exports.writeFile = async function (filePath,strJson) {
    return await util.writeFile(filePath,strJson);
}
exports.readFile = async function (filePath) {
    return await util.readFile(filePath);
}
exports.doZipFiles = async function (filesList,toPath) {
  return await util.doZipFiles(filesList,toPath);
}