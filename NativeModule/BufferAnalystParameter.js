import {NativeModules} from 'react-native';
let BAP = NativeModules.JSBufferAnalystParameter;

export default class BufferAnalystParameter {
    static ENDTYPE = {
        ROUND:1,
        FLAT:2,
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
            await BAP.setLeftDistance(this.bufferAnalystParameterId,distance);
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
            await BAP.setRightDistance(this.bufferAnalystParameterId,distance);
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
    
    async setRadiusUnit(distance){
        try{
            await BAP.setRadiusUnit(this.bufferAnalystParameterId,distance);
        }catch (e){
            console.error(e);
        }
    }
    
    async getRadiusUnit(distance){
        try{
            await BAP.getRadiusUnit(this.bufferAnalystParameterId,distance);
        }catch (e){
            console.error(e);
        }
    }
    
    async setSemicircleLineSegment(distance){
        try{
            await BAP.setSemicircleLineSegment(this.bufferAnalystParameterId,distance);
        }catch (e){
            console.error(e);
        }
    }
    
    async getSemicircleLineSegment(distance){
        try{
            await BAP.getSemicircleLineSegment(this.bufferAnalystParameterId,distance);
        }catch (e){
            console.error(e);
        }
    }
}
