import {NativeModules} from 'react-native';
let BA = NativeModules.JSBufferAnalyst;

export default class BufferAnalyst {
    
    async createBuffer(sourceDataSet,resultDataSet,bufferAnalystParam,isUnion,isAttributeRetained){
        try{
            var {isCreate} = await BA.createBuffer(sourceDataSet.datasetVectorId,resultDataSet.datasetVectorId,bufferAnalystParam.bufferAnalystParameterId,isUnion,isAttributeRetained);
            
            return isCreate;
        }catch (e){
            console.error(e);
        }
    }
    
    async createLineOneSideMultiBuffer(sourceDataSet,resultDataSet,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing){
        try{
            var {isCreate} = await BA.createLineOneSideMultiBuffer(sourceDataSet.datasetVectorId,resultDataSet.datasetVectorId,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing);
            
            return isCreate;
        }catch (e){
            console.error(e);
        }
    }
    
    async createMultiBuffer(sourceDataSet,resultDataSet,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isUnion,isAttributeRetained,isRing){
        try{
            var {isCreate} = await BA.createMultiBuffer(sourceDataSet.datasetVectorId,resultDataSet.datasetVectorId,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isUnion,isAttributeRetained,isRing);
            
            return isCreate;
        }catch (e){
            console.error(e);
        }
    }
}
