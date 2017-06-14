/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let L = NativeModules.JSLayer;
import Dataset from './Dataset.js';
import Selection from './Selection.js';
import LayerSetting from './LayerSetting.js';
import LayerSettingVector from './LayerSettingVector.js';

/**
 * @class Layer
 */
export default class Layer{
    /**
     * 设置图层是否处于可编辑状态。该方法控制是否对图层所引用的数据进行修改。
     * @memberOf Layer
     * @param {boolean}editable - 图层是否处于可编辑状态。
     * @returns {Promise.<void>}
     */
    async setEditable(editable){
        try{
            await L.setEditable(this.layerId,editable);
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 判断图层是否处于可编辑状态。
     * @memberOf Layer
     * @returns {Promise.<boolean>}
     */
    async getEditable(){
        try{
            var{isEditable} = await L.getEditable(this.layerId);
            return isEditable;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回图层的名称。图层的名称在图层所在的地图中唯一标识此图层。该标识不区分大小写。
     * @memberOf Layer
     * @param {index} index - 图层序号
     * @returns {Promise.<void>}
     */
    async getName(index){
        try{
            var {layerName} = await L.getName(this.layerId,index);
            return layerName;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回此图层对应的数据集对象。图层是对数据集的引用，因而，一个图层与一个数据集相对应。
     * @memberOf Layer
     * @returns {Promise.<Dataset>}
     */
    async getDataset(){
        try{
            var {datasetId} = await L.getDataset(this.layerId);
            var dataset = new Dataset();
            dataset.datasetId = datasetId;
            return dataset;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置图层关联的数据集。 设置的数据集必须与当前地图属于同一工作空间，且数据集类型与原有数据集类型一致，否则会抛出异常。
     * @memberOf Layer
     * @param {object} dataset - 图层关联的数据集
     * @returns {Promise.<void>}
     */
    async setDataset(dataset){
        try{
            await L.setDataset(this.layerId,dataset.datasetId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回此图层中的选择集对象。选择集是个集合，其中包含选择的图层中的一个或多个要素。在选择集中的要素才可以被编辑。注意选择集只适用于矢量数据集，栅格数据集和影像数据集没有选择集。
     * @memberOf Layer
     * @returns {Promise.<Selection>}
     */
    async getSelection(){
        try{
            var {selectionId,recordsetId} = await L.getSelection(this.layerId);
            var selection = new Selection();
            selection.selectionId = selectionId;
            selection.recordsetId = recordsetId;
            return selection;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置图层中对象是否可以选择。
     * @memberOf Layer
     * @param {boolean} b - 指定图层中对象是否可以选择。
     * @returns {Promise.<void>}
     */
    async setSelectable(b){
        try{
            await L.setSelectable(this.layerId,b);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 返回图层中对象是否可以选择
     * @memberOf Layer
     * @param {void}
     * @returns {Promise.<boolean>}
     */
    async isSelectable(){
        try{
            var{selectable} = await L.isSelectable(this.layerId);
            return selectable;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取此图层是否可见。true 表示此图层可见，false 表示图层不可见。当图层不可见时，其他所有的属性的设置将无效。
     * @memberOf Layer
     * @param {boolean} b - 指定图层是否可见。
     * @returns {Promise.<boolean>}
     */
    async getVisible(){
        try{
            var isVisible = await L.getVisible(this.layerId);
            return isVisible;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置此图层是否可见。true 表示此图层可见，false 表示图层不可见。当图层不可见时，其他所有的属性的设置将无效。
     * @memberOf Layer
     * @param {boolean} b - 指定图层是否可见。
     * @returns {Promise.<void>}
     */
    async setVisible(b){
        try{
            await L.setVisible(this.layerId,b);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回普通图层的风格设置。LayerSettingVector 类用来对矢量数据图层风格进行设置和修改。
     * @memberOf Layer
     * @returns {Promise.<LayerSetting>}
     */
    async getAdditionalSetting(){
        try{
            var layerSetting;
            var {_layerSettingId_,type} = await L.getAdditionalSetting(this.layerId);
            if(type===0){
            layerSetting = new LayerSettingVector();
            layerSetting._layerSettingVectorId_ = _layerSettingId_;
            }else if(type===1){
            //image
            }else{
            //grid
            }
            return layerSetting;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置普通图层的风格。普通图层风格的设置对矢量数据图层、栅格数据图层以及影像数据图层是不相同的。LayerSettingVector类用来对矢量数据图层的风格进行设置和修改。
     * @memberOf Layer
     * @param {LayerSetting} layerSetting - 普通图层的风格设置.{@link LayerSetting}
     * @returns {Promise.<void>}
     */
    async setAdditionalSetting(layerSetting){
        try{
            await L.setAdditionalSetting(this.layerId,layerSetting._layerSettingId_);
        }catch(e){
            console.error(e);
        }
    }
}
