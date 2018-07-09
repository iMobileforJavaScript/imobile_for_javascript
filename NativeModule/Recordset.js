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

    async edit(){
        try{
            let isEdit = await R.edit(this._SMRecordsetId);
            return isEdit
        }catch (e){
            console.error(e);
        }
    }

    async update(){
        try{
          let isUpdate = await R.update(this._SMRecordsetId);
          return isUpdate
        }catch (e){
            console.error(e);
        }
    }

    async getFieldCount(){
        try{
          let { count } = await R.getFieldCount(this._SMRecordsetId);
          return count
        }catch (e){
            console.error(e);
        }
    }
    
    async getFieldInfosArray(count = 0, size = 20) {
      try{
        let arr = await R.getFieldInfosArray(this._SMRecordsetId, count, size);
        return arr
      }catch (e){
        console.error(e);
      }
    }
    
    async setFieldValueByName(info) {
      try {
        await R.setFieldValueByName(this._SMRecordsetId, info);
      } catch (e){
        console.error(e);
      }
    }
    
    async setFieldValueByIndex(info) {
      try {
        await R.setFieldValueByIndex(this._SMRecordsetId, info);
      } catch (e){
        console.error(e);
      }
    }
    
    async setFieldValuesByNames(infos = {}) {
      try {
        let { result, editResult, updateResult} = await R.setFieldValueByName(this._SMRecordsetId, infos);
        return { result, editResult, updateResult }
      } catch (e){
        console.error(e);
      }
    }
    
    async setFieldValuesByIndexes(infos = {}) {
      try {
          let { result, editResult, updateResult } = await R.setFieldValueByIndex(this._SMRecordsetId, infos);
          return { result, editResult, updateResult }
      } catch (e){
        console.error(e);
      }
    }
    
    async addFieldInfo(info = {}) {
      try {
          let { index, editResult, updateResult } = await R.addFieldInfo(this._SMRecordsetId, info);
          return { index, editResult, updateResult }
      } catch (e){
        console.error(e);
      }
    }
  
}
