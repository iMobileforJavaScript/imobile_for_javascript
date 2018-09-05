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

exports.Point2Map = async function (map,x, y) {
    let pointFac = new Point();
    let point = await pointFac.createObj(x,y);
    let mapPoint = await map.pixelToMap(point);

    return mapPoint;
}

exports.appendingHomeDirectory = async function (path = '') {
    let homeDirectory = await util.getHomeDirectory();
    let newPath = homeDirectory + path;
    return newPath;
}

exports.getDirectoryContent = async function (path) {
  let directories = await util.getDirectoryContent(path);
  return directories;
}

exports.fileIsExist = async function (path) {
  let isExist = await util.fileIsExist(path);
  return isExist;
}

exports.fileIsExistInHomeDirectory = async function (path) {
  let isExist = await util.fileIsExistInHomeDirectory(path);
  return isExist;
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
exports.unZipFolder = async function (zipfile,targetdir) {
  return await util.UnZipFolder(zipfile, targetdir);
}