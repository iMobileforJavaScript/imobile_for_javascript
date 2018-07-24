import { NativeModules } from 'react-native';
let Open = NativeModules.JSOpenMapfile;
export default class　OpenMapfile{
  async getfilelist(path){
      
      try{
         let filelist =await Open.getpathlist(path);
         return filelist;
          
      }catch(e){
          console.error(e);
      }
  }
  async isdirectory(path){
    try{     
       let result =await Open.isdirectory(path);
       return result;       
    }catch(e){
        console.error(e);
    }

}
}
  
