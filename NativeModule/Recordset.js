/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let R = NativeModules.JSRecordset;
import Geometry from './Geometry.js';
import Dataset from './Dataset';

/**
 * @class Recordset
 * @deprecated
 */
export default class Recordset {
    async getRecordCount(){
        try{
            var {recordCount} = await R.getRecordCount(this._SMRecordsetId);
            return recordCount;
        }catch (e){
            console.error(e);
        }
    }

    async dispose(){
        try{
            await R.dispose(this._SMRecordsetId);
        }catch (e){
            console.error(e);
        }
    }

    async getGeometry(){
        try{
            var {geometryId} = await R.getGeometry(this._SMRecordsetId);
            var geometry = new Geometry();
            geometry._SMGeometryId = geometryId;
            return geometry;
        }catch (e){
            console.error(e);
        }
    }

    async isEOF(){
        try{
            var isEOF = await R.isEOF(this._SMRecordsetId);
            return isEOF;
        }catch (e){
            console.error(e);
        }
    }

    async getDataset(){
        try{
            var {datasetId} = await R.getDataset(this._SMRecordsetId);
            var dataset = new Dataset();
            dataset._SMDatasetId = datasetId;
            return dataset;
        }catch (e){
            console.error(e);
        }
    }

    async addNew(geometry){
        try{
            await R.addNew(this._SMRecordsetId,geometry._SMGeometryId);
        }catch (e){
            console.error(e);
        }
    }

    async moveNext(){
        try{
            await R.moveNext(this._SMRecordsetId);
        }catch (e){
            console.error(e);
        }
    }

    async update(){
        try{
            await R.update(this._SMRecordsetId);
        }catch (e){
            console.error(e);
        }
    }
}
