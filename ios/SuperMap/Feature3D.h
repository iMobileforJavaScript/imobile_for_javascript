//
//  Feature3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@class Geometry3D, Feature3Ds;


///三维要素类。
@interface Feature3D : NSObject
{
    Geometry3D *_geometry3D;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Camera camera;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) Geometry3D *geometry3D;
@property (nonatomic, readonly, assign) NSInteger ID;
@property (nonatomic, getter=isVisible) BOOL visible;
@property (nonatomic, strong) Feature3Ds *feature3Ds;
@property (nonatomic, assign) double visibleDistance;
@property (nonatomic, assign) BOOL isDisposable;

/**@brief 返回三维要素对象指定字段序号对应的字段值。
 @param  index 指定的字段序号。
 @return  字段值。
 */
- (NSObject *)getFieldValueWithIndex:(NSInteger)index;

/**@brief 返回三维要素对象指定字段名称对应的字段值。
 @param  name 指定的字段名称。
 @return  字段值。
*/
- (NSObject *)getFieldValueWithString:(NSString *)name;

/* KML */
- (NSString *)toKml;
- (BOOL)fromKml:(NSString *)kml;

/* KMLFile */
- (void)toKMLFile:(NSString *)kmlFile;
- (BOOL)fromKMLFile:(NSString *)kmlFile;

/* updateData */
- (void)updateData;

/* isNameInValues */
- (BOOL)isNameInValues:(NSString *)value;

@end
