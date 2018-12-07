//
//  Utils3D.m
//  Supermap
//
//  Created by imobile-xzy on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utils3D.h"


#import "SuperMap/Feature3DSearchOption.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/QueryParameter.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/DatasetVector.h"

@implementation Utils3D
+(void)KMLData:(Layer3D*)layer ID:(int)id info:(NSMutableDictionary*)attributeMap{
    Feature3Ds* fer = layer.feature3Ds;
    if (fer != nil && [fer count] > 0) {
        Feature3D* fer3d = [fer feature3DWithID:id option:Feature3DSearchOptionAllFeatures];//fer.findFeature(id, Feature3DSearchOption.ALLFEATURES);
        if (fer3d != nil) {
            NSString* value = fer3d.description;//fer3d.getDescription();
            NSString* value1 = fer3d.name; //fer3d.getName();
            [attributeMap setObject:value1 forKey:@"name"];
            [attributeMap setObject:value forKey:@"description"];
            //attributeMap = @{@"name:":value1,@"description:":value};

        }
        
    }
}
+(void)vect:(Selection3D*)selection layer:(Layer3D*)layer fieldInfos:(FieldInfos*)fieldInfos attribute:(NSMutableDictionary*)attributeMap{
    Feature3D* feature = nil;
    Layer3DOSGBFile* layer3d = nil;
    if (layer.type == OSGBFILE) {
        
        layer3d = [Layer3DOSGBFile layer3DOSGBFileWithLayer3D:layer];//(Layer3DOSGBFile*) layer;
        //Selection3D selection3d = layer3d.getSelection();
    } else if (layer.type == VECTORFILE) {
        feature = [selection toFeature3D];
    }
    int count=0;
    NSArray* str;
    if(feature==nil){
        str = [layer3d allFieldValuesOfLastSelectedObject];
        count=str.count;
    }else{
        count = fieldInfos.count;
    }
    
    //NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:1];
    for (int j = 0; j < count; j++) {
        NSString* name = [fieldInfos get:j].name;//.get(j).getName();
        NSString* strValue;
        NSObject* value;
        if(feature==nil){
            value=str[j];
        }else{
            value = [feature getFieldValueWithString:name];//.getFieldValue(name);
        }
        if ([value isEqual:@"NULL"]) {
            strValue = @"";
        } else {
            strValue = value;
        }
        [attributeMap setObject:strValue forKey:name];
       // attributeMap.put(name + ":",strValue);
    }
  //  attributeMap = dict;
}

+(void)urlNUll:(Scene*)tempScene ID:(int)_nID  wk:(Workspace*)mWorkspace  attribute:(NSMutableDictionary*)attributeMap{
    int _nDSCount = mWorkspace.datasources.count;// getDatasources().getCount();
    if (_nDSCount > 0) {
        NSString* sceneName = tempScene.name;
        Datasource* datasetsource = [mWorkspace.datasources getAlias:sceneName];//.get(sceneName);
        if (datasetsource != nil) {
            DatasetVector* datasetVector = (DatasetVector*) ([datasetsource.datasets getWithName:sceneName] );
            if (datasetVector != nil) {
                NSString* strFilter = [NSString stringWithFormat:@"SmID = '%d'",_nID];
                // QueryParameter
                QueryParameter* parameter = [[QueryParameter alloc]init];
                parameter.attriButeFilter = strFilter;
               // parameter.setAttributeFilter(strFilter);
                // CursorType
                parameter.cursorType = STATIC;// setCursorType(CursorType.STATIC);
                
                
                Recordset* recordset =  [datasetVector query:parameter];//datasetVector.query(parameter);
                
                if ([recordset recordCount] >= 1) {
                    // FieldInfos
                    
                    FieldInfos* fieldInfos = datasetVector.fieldInfos;
                    
                    [recordset moveFirst];
                    
                    NSMutableArray* nameList = [[NSMutableArray alloc]init];
                    // NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:1];
                    for (int n = 0; n < fieldInfos.count; n++) {
                        NSString* name = [fieldInfos get:n].name;// get(n).getName();
                        
                        if ([name.lowercaseString hasPrefix:@"sm"]) {
                            continue;
                        }
                       // [nameList addObject:[name stringByAppendingString:@":"]];
                       
                        NSString* strValue;
                        NSObject* value = [recordset getFieldValueWithString:name];// .getFieldValue(name);
                        if (value == nil) {
                            strValue = @"";
                        } else {
                            strValue = value;
                            
                        }
                        
                        if (![nameList containsObject:name]) {
                            [attributeMap setObject:strValue forKey:name];
                        }
                        
                    }
                    
                    // fieldInfos.dispose();
                    [recordset dispose];
                   // nameList.clear();
                   // attributeMap = dict;
                }
            }
        }
    }
}

+(void)urlNoNULL:(SceneControl*)mSceneControl url:(NSString*)sceneUrl ID:(int)id attribute:(NSMutableDictionary*)attributeMap{
    NSString* Sceneurl = mSceneControl.scene.url;// getScene().getUrl();
    
    NSString* sceneName = mSceneControl.scene.name; //getScene().getName();
    
    NSString* jsonURL = [NSString stringWithFormat:@"http://www.supermapol.com/realspace/services/data-%@/rest/data/datasources/%@/datasets/%@/features/%d.rjson",sceneName,sceneName,sceneName,id];//"http://www.supermapol.com/realspace/services/data-" + sceneName + "/rest/data/datasources/"+ sceneName + "/datasets/" + sceneName + "/features/" + id + ".rjson";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:jsonURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = nil;
    
    __block NSMutableDictionary* dict = attributeMap;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    task = [session dataTaskWithRequest:request
                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                          if (error) {
                             // failure(task, error);
                          } else {
                              NSError *err = nil;
                              NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&err];
                             // NSMutableDictionary *models = [[NSMutableDictionary alloc] init];
                              if (err) {
                                 // failure(task, err);
                              } else {//success
                                  NSArray *keys = [responseJSON objectForKey:@"fieldNames"];
                                  NSArray *values = [responseJSON objectForKey:@"fieldValues"];
                                //  NSMutableArray *models = [[NSMutableArray alloc] init];
                                  
                                  
                                  for (int m = 0; m < keys.count; m++){
                                      if (!([keys[m] hasPrefix:@"SM"] || [keys[m] hasPrefix:@"Sm"])) {
                                         
                                          [dict setValue:values[m] forKey:keys[m]];
                                          //[models addObject:model];
                                      }
                                  }
                                  
                                 // (__block)attributeMap = models;
                              }
                          }
                          
                          
                      }];
    [task resume];
}
@end
