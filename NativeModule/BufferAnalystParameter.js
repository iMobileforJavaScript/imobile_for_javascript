import {NativeModules} from 'react-native';
let BAP = NativeModules.JSBufferAnalystParameter;

export default class BufferAnalystParameter {
    static ENDTYPE = {
        ROUND:1,
        FLAT:2,
    }
    
    static RADIUSUNIT = {
        MiliMeter:10,
        CentiMeter:100,
        DeciMeter:1000,
        Meter:10000,
        KiloMeter:10000000,
        Yard:9144,
        Inch:254,
        Foot:3048,
        Mile:16090000,
    }

    async createObj(){
        try{
            var {bufferAnalystParameterId} = await BAP.createObj();
            var bufferAnalystParameter = new BufferAnalystParameter();
            bufferAnalystParameter.bufferAnalystParameterId = bufferAnalystParameterId;
            return bufferAnalystParameter;
        }catch (e){
            console.error(e);
        }
    }

    async setEndType(bufferEndType){
        try{
            await BAP.setEndType(this.bufferAnalystParameterId,bufferEndType);
        }catch (e){
            console.error(e);
        }
    }
    
    async getEndType(){
        try{
            var {EndType} = await BAP.getEndType(this.bufferAnalystParameterId);
            return EndType;
        }catch (e){
            console.error(e);
        }
    }

    async setLeftDistance(distance){
        try{
            if(typeof distance == 'number'){
                await BAP.setLeftDistance(this.bufferAnalystParameterId,distance);
            }else{
                await BAP.setLeftDistanceByStr(this.bufferAnalystParameterId,distance);
            }
        }catch (e){
            console.error(e);
        }
    }
    
    async getLeftDistance(){
        try{
            var {leftDistance} = await BAP.getLeftDistance(this.bufferAnalystParameterId);
            return leftDistance;
        }catch (e){
            console.error(e);
        }
    }

    async setRightDistance(distance){
        try{
            if(typeof distance == 'number'){
                await BAP.setRightDistance(this.bufferAnalystParameterId,distance);
            }else{
                await BAP.setRightDistanceByStr(this.bufferAnalystParameterId,distance);
            }
        }catch (e){
            console.error(e);
        }
    }
    
    async getRightDistance(){
        try{
            var {rightDistance} = await BAP.getRightDistance(this.bufferAnalystParameterId);
            return rightDistance;
        }catch (e){
            console.error(e);
        }
    }
    
    async setRadiusUnit(radiusUnit){
        try{
            await BAP.setRadiusUnit(this.bufferAnalystParameterId,radiusUnit);
        }catch (e){
            console.error(e);
        }
    }
    
    async getRadiusUnit(){
        try{
            var {radiusUnit} = await BAP.getRadiusUnit(this.bufferAnalystParameterId);
            return radiusUnit;
        }catch (e){
            console.error(e);
        }
    }
    
    async setSemicircleLineSegment(segment){
        try{
            await BAP.setSemicircleLineSegment(this.bufferAnalystParameterId,segment);
        }catch (e){
            console.error(e);
        }
    }
    
    async getSemicircleLineSegment(){
        try{
            var {segment} = await BAP.getSemicircleLineSegment(this.bufferAnalystParameterId);
            return segment;
        }catch (e){
            console.error(e);
        }
    }
}
