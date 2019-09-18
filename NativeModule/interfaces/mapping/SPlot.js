import { NativeModules, Platform } from 'react-native'
const SPlot = NativeModules.SPlot

  /**
   * 初始化标绘符号库
   */
  function initPlotSymbolLibrary(plotSymbolPaths,isFirst,newName,isDefaultNew) {
    try {
      return SPlot.initPlotSymbolLibrary(plotSymbolPaths,isFirst,newName,isDefaultNew)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置标绘符号
   */
  function setPlotSymbol(libId,symbolCode) {
    try {
      return SPlot.setPlotSymbol(libId,symbolCode)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 新建cad图层
   */
  function addCadLayer(layerName){
    try {
      return SPlot.addCadLayer(layerName)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导入标绘库数据
   * @param fromPath  标绘库数据路径
   */
  function importPlotLibData(fromPath){
    try{
      return SPlot.importPlotLibData(fromPath)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 移除标绘库
   * @param plotSymbolIds  标绘库数据id
   */
  function removePlotSymbolLibraryArr(plotSymbolIds){
    try{
      return SPlot.removePlotSymbolLibraryArr(plotSymbolIds)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 根据标绘库获取标绘库名称
   * @param {标绘库id} libId 
   */
  function getPlotSymbolLibNameById(libId){
    try{
      return SPlot.getPlotSymbolLibNameById(libId)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 初始化态势推演
   */
  function initAnimation(){
    try{
      return SPlot.initAnimation()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 读取态势推演xml文件
   */
  function readAnimationXmlFile(filePath){
    try{
      return SPlot.readAnimationXmlFile(filePath)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 播放态势推演动画
   */
  function animationPlay(){
    try{
      return SPlot.animationPlay()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 暂停态势推演动画
   */
  function animationPause(){
    try{
      return SPlot.animationPause()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 重置态势推演动画
   */
  function animationReset(){
    try{
      return SPlot.animationReset()
    } catch (e){
      console.error(e)
    }
  }

   /**
   * 停止态势推演动画
   */
  function animationStop(){
    try{
      return SPlot.animationStop()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 关闭态势推演动画
   */
  function animationClose(){
    try{
      return SPlot.animationClose()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 创建态势推演动画
   */
  function createAnimationGo(createInfo,newPlotMapName){
    try{
      return SPlot.createAnimationGo(createInfo,newPlotMapName)
    } catch (e){
      console.error(e)
    }
  }
  
  /**
   * 保存态势推演动画
   */
  function animationSave(savePath,fileName){
    try{
      return SPlot.animationSave(savePath,fileName)
    } catch (e){
      console.error(e)
    }
  }
  
  /**
   * 保存态势推演动画
   */
  function getGeometryTypeById(layerName,geoId){
    try{
      return SPlot.getGeometryTypeById(layerName,geoId)
    } catch (e){
      console.error(e)
    }
  }
  
  /**
   * 添加路径动画点
   * @param {点信息} point 
   */
  function addAnimationWayPoint(point,isAdd){
    try{
      return SPlot.addAnimationWayPoint(point,isAdd)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 刷新路径动画点
   */
  function refreshAnimationWayPoint(){
    try{
      return SPlot.refreshAnimationWayPoint()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 取消路径动画点
   */
  function cancelAnimationWayPoint(){
    try{
      return SPlot.cancelAnimationWayPoint()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 添加路径动画点
   * @param {点信息} point 
   */
  function endAnimationWayPoint(isSave){
    try{
      return SPlot.endAnimationWayPoint(isSave)
    } catch (e){
      console.error(e)
    }
  }
  /**
   * 根据geoId获取已经创建的动画类型和数量
   * @param {} geoId 
   */
  function getGeoAnimationTypes(geoId){
    try{
      return SPlot.getGeoAnimationTypes(geoId)
    } catch (e){
      console.error(e)
    }
  }
  
  /**
   * 获取所有动画节点的数据
   */
  function getAnimationNodeList(){
    try{
      return SPlot.getAnimationNodeList()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 删除动画节点
   */
  function deleteAnimationNode(nodeName){
    try{
      return SPlot.deleteAnimationNode(nodeName)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 修改动画节点名称
   */
  function modifyAnimationNodeName(index,newNodeName){
    try{
      return SPlot.modifyAnimationNodeName(index,newNodeName)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 移动动画节点位置
   */
  function moveAnimationNode(index,isUp){
    try{
      return SPlot.moveAnimationNode(index,isUp)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 获取动画节点信息
   */
  function getAnimationGoInfo(index){
    try{
      return SPlot.getAnimationGoInfo(index)
    } catch (e){
      console.error(e)
    }
  }
  /**
   * 获取动画节点信息
   */
  function modifyAnimationNode(index,nodeInfo){
    try{
      return SPlot.modifyAnimationNode(index,nodeInfo)
    } catch (e){
      console.error(e)
    }
  }


export {
    initPlotSymbolLibrary,
    setPlotSymbol,
    addCadLayer,
    importPlotLibData,
    removePlotSymbolLibraryArr,
    getPlotSymbolLibNameById,
    initAnimation,
    readAnimationXmlFile,
    animationPlay,
    animationPause,
    animationReset,
    animationStop,
    animationClose,
    createAnimationGo,
    animationSave,
    getGeometryTypeById,
    addAnimationWayPoint,
    refreshAnimationWayPoint,
    cancelAnimationWayPoint,
    endAnimationWayPoint,
    getGeoAnimationTypes,
    getAnimationNodeList,
    deleteAnimationNode,
    modifyAnimationNodeName,
    moveAnimationNode,
    getAnimationGoInfo,
    modifyAnimationNode,
}