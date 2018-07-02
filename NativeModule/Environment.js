import {NativeModules} from 'react-native';
let E = NativeModules.JSEnvironment;
export default class Environment{

    async setLicensePath(path){
        try{
            var{isSet} = await E.setLicensePath(path);
        }catch(e){
            console.error(e);
        }
    }

    async initialization(){
        try{
            var{isInit} = await E.initialization();
        }catch(e){
            console.error(e);
        }
    }
}