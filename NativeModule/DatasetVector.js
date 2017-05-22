import {NativeModules} from 'react-native';
let DV = NativeModules.JSDatasetVector;
import Dataset from './Dataset.js';
import Recordset from  './Recordset.js';
import QueryParameter from './QueryParameter.js';


/**
 * @class DatasetVector
 */
export default class DatasetVector {
   /* constructor(){
        super();
        Object.defineProperty(this,"datasetVectorId",{
                              get:function(){
                              return this.datasetId
                              },
                              set:function(datasetVectorId){
                              this.datasetId = datasetVectorId;
                              }
                              })
    }*/
    /**
     * 查询落在已知空间范围内的记录。
     * @memberOf DatasetVector
     * @deprecated - 弃用，所有recordset都使用json格式表达
     * @param isEmptyRecordset
     * @param cursorType
     * @returns {Promise.<Recordset>}
     */
    async queryInBuffer(rectangle2D, cursorType) {
        try {
            var {recordsetId} = await DV.queryInBuffer(this.datasetVectorId, rectangle2D.rectangle2DId, cursorType);
            var recordset = new Recordset();
            recordset.recordsetId = recordsetId;
            return recordset;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 根据给定的参数来返回空的记录集或者返回包括所有记录的记录集对象。
     * @memberOf DatasetVector
     * @deprecated - 弃用，所有recordset都使用json格式表达
     * @param isEmptyRecordset
     * @param cursorType
     * @returns {Promise.<Recordset>}
     */
    async getRecordset(isEmptyRecordset, cursorType) {
        try {
            var {recordsetId} =await DV.getRecordset(this.datasetVectorId, isEmptyRecordset, cursorType);
            var recordset = new Recordset();
            recordset.recordsetId = recordsetId;
            return recordset;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 通过设置查询条件对矢量数据集进行查询，该方法默认查询空间信息与属性信息。
     * @memberOf DatasetVector
     * @param {object}queryParameter - 定义的查询条件。
     * @returns {Promise} - 返回查询结果对象:result:{geoJson:geoJson结果集数组，每次10条,queryParameterId:查询条件对象的引用，可用于重复查询，counts:总记录数，batch：返回的批次数量，size：每批次记录数（最大为10），recordsetId：记录集对象引用}
     */
    async query(queryParameter) {
        try {
            var QueryParameterFac = new QueryParameter();
            var qp = await QueryParameterFac.createObj();

            if (!queryParameter
            // && (queryParameter.attributeFilter || queryParameter.groupBy ||
            //         queryParameter.hasGeometry || queryParameter.resultFields || queryParameter.orderBy ||
            //         queryParameter.spatialQueryMode)
            ) {
                qp.queryParameterId = "0";
            } else {
                queryParameter.attributeFilter && await qp.setAttributeFilter(queryParameter.attributeFilter);

                queryParameter.groupBy && await qp.setGroupBy(queryParameter.groupBy);

                queryParameter.hasGeometry && await qp.setHasGeometry(queryParameter.hasGeometry);

                queryParameter.resultFields && await qp.setResultFields(queryParameter.resultFields);

                queryParameter.orderBy && await qp.setOrderBy(queryParameter.orderBy);

                queryParameter.spatialQueryObject && await qp.setSpatialQueryObject(queryParameter.spatialQueryObject);

                queryParameter.spatialQueryMode && await qp.setSpatialQueryMode(queryParameter.spatialQueryMode);

                if (queryParameter.size) qp.size = queryParameter.size;
                if (queryParameter.batch) qp.batch = queryParameter.batch;
            }


            var result = await DV.query(this.datasetVectorId, qp.queryParameterId,
                qp.size, qp.batch);
            return result;
        } catch (e) {
            console.log(e);
        }
    }

    /**
     *根据给定的空间索引类型来为矢量数据集创建空间索引。
     * @memberOf DatasetVector
     * @param {DatasetVector.SpatialIndeType} spatialIndexType - 指定的需要创建空间索引的类型
     * @returns {Promise.<Promise.boolean>}
     */
    async buildSpatialIndex(spatialIndexType) {
        try {
            var {built} =await DV.buildSpatialIndex(this.datasetVectorId, spatialIndexType);
            return built;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 删除空间索引
     * @memberOf DatasetVector
     * @returns {Promise.<Promise.dropped>}
     */
    async dropSpatialIndex() {
        try {
            var {dropped} =await DV.dropSpatialIndex(this.datasetVectorId);
            return dropped;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 返回当前的空间索引类型
     * @memberOf DatasetVector
     * @returns {Promise.<Promise.DatasetVector.SpatialIndeType>}
     */
    async getSpatialIndexType() {
        try {
            var {type} =await DV.getSpatialIndexType(this.datasetVectorId);
            return type;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 计算数据集的空间范围
     * @memberOf DatasetVector
     * @returns {Promise.<Promise.object>}
     */
    async computeBounds() {
        try {
            var {bounds} =await DV.computeBounds(this.datasetVectorId);
            return bounds;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     *从GeoJSON字符串中获取几何对象，并将其存入数据集中
     *仅支持点、线、面和CAD数据集，获取点、线、面对象
     * @memberOf DatasetVector
     * @param {boolean} hasAttributte - 是否包含属性值
     * @param {number} startID - 起始SmID
     * @param {number} endID - 结束SmID
     * @returns {Promise.<string>}
     */
    async toGeoJSON(hasAttributte, startID, endID) {
        try {
            var {geoJSON} =await DV.toGeoJSON(this.datasetVectorId);
            var json = JSON.parse(geoJSON);
            return geoJSON;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 将数据集中指定起止SmID的对象，转换成GeoJSON格式的字符串
     *仅支持点、线、面和CAD数据集，转换点、线、面对象.hasAtrributte为true时，结果中包含属性值;hasAtrribute为false时，只有几何对象。
     * @memberOf DatasetVector
     * @param {string} geoJson - json字符串
     * @returns {Promise.<Promise.boolean>}
     */
    async fromGeoJSON(geoJson) {
        try {
            var {done} =await DV.fromGeoJSON(this.datasetVectorId,geoJson);
            return done;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 异步空间查询，查询指定空间范围内符合字段条件的记录；
     * @memberOf DatasetVector
     * @param {string} attributeFilter - 查询过滤字段
     * @param {object} geoRegion - 查询的区域
     * @param count - 返回的查询结果个数
     * @param {function} callback - 返回结果的处理函数,回调参数callback(e){},e为Recordset的geoJson格式对象的数组
     * @returns {Promise.<null>}
     */
    async queryByFilter(attributeFilter,geoRegion,count,callback) {
        try {
            var success = await DV.queryByFilter(this.datasetVectorId,attributeFilter,geoRegion.geometryId,count);
            if(!success) return null;

            DeviceEventEmitter.addListener('com.supermap.RN.JSDatasetVector.query_by_filter', function(e) {
                var features = [];
                var records = [];
                for(var i in e){
                    features[i] = JSON.parse(e[i]);
                    records = records.concat(features[i]);
                }
                if(typeof callback == 'function'){
                    callback(records);
                }else{
                    console.error("Please set a callback function as the fourth argument.");
                }
            });

        } catch (e) {
            console.error(e);
        }
    }
    
    /**
     * 通过查询语句获取所需几何对象ID集合
     * @memberOf Dataset
     * @returns {Promise.<Promise.Array>}
     */
    async getSMID(SQL){
        try{
            var {result} = await DV.getSMID(this.datasetVectorId,SQL);
            return result;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 通过查询语句获取字段内容
     * @memberOf Dataset
     * @returns {Promise.<Promise.Array>}
     */
    async getFieldValue(SQL,fieldName){
        try{
            var {result} = await DV.getFieldValue(this.datasetVectorId,SQL,fieldName);
            return result;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 通过查询语句获取所需几何对象内点集合
     * @memberOf Dataset
     * @returns {Promise.<Promise.Array>}
     */
    async getGeoInnerPoint(SQL){
        try{
            var {result} = await DV.getGeoInnerPoint(this.datasetVectorId,SQL);
            return result;
        }catch(e){
            console.error(e);
        }
    }
    
}
