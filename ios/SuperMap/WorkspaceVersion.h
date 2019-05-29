//
//  WorkspaceVersion.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/** 该类定义了工作空间版本类型常量。
 <p> SuperMap iMobile 7C  for iOS 仅支持SuperMap 6.0 工作空间。
 */
typedef enum{

  /*
       * @brief SuperMap 5.0 工作空间。支持 SuperMap GIS 5 系列及其后续版本的工作空间
     */
    //SFC50 = 20031211,
	

    ///  SuperMap UGC 2.0 工作空间。基于统一内核 UGC（Universal GIS Core）开发的组件产品（SuperMap Objects Java 与 SuperMap Objects .NET）的默认工作空间。
    UGC20 = 20070521,
	

    /// SuperMap UGC 6.0 工作空间。
    UGC60 = 20090106,
	
	/*
             * @brief SuperMap 6.0 工作空间
             */
    //SFC60 = 20031212
}WorkspaceVersion;