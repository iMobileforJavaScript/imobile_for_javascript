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

exports.getPathListByFilter = async function (path, {name = '', extension = '', type = 'Directory'}) {
  return await util.getPathListByFilter(path, {name, extension, type});
}

exports.zipFile = async function (filePath, targetPath) {
  return await util.zipFile(filePath, targetPath);
}

exports.zipFiles = async function (filePaths, targetPath) {
  return await util.zipFiles(filePaths, targetPath);
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

const EARTH_RADIUS = 6371.0 //km 地球半径 平均值，千米
exports.convertDistanceByPoints = async function (point1, point2) {
  let ConvertDegreesToRadians = function (v) {
    let r = Math.sin(v);
    return r * r;
  }
  let lat1 = ConvertDegreesToRadians(point1.x);
  let lon1 = ConvertDegreesToRadians(point1.y);
  let lat2 = ConvertDegreesToRadians(point2.x);
  let lon2 = ConvertDegreesToRadians(point2.y);
  
  let HaverSin = function (theta) {
    let v = Math.sin(theta / 2);
    return v * v;
  }
  
  let vLon = Math.abs(lon1 - lon2);
  let vLat = Math.abs(lat1 - lat2);
  let h = HaverSin(vLat) + Math.cos(lat1) * Math.cos(lat2) * HaverSin(vLon);
  
  let distance = 2 * EARTH_RADIUS * Math.asin(Math.sqrt(h));
  return distance;
}

exports.ConvertDegreesToRadians = function (degrees) {
  return degrees * Math.PI / 180;
}