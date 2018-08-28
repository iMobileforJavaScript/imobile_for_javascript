//
//  SpatialIndexInfo.h
//  
//
//  Created by imobile-xzy on 16/6/16.
//
//

#import <Foundation/Foundation.h>
//! \brief 空间索引类型枚举
typedef enum SpatialIndexType
{       //! \brief 没有索引
    SpatialIdxNone		= 1,
    //! \brief Rtree索引
    SpatialIdxRTree	= 2,
    //! \brief 四叉树索引
    SpatialIdxQTree	= 3,
    //! \brief 图幅索引 UGC里不支持编辑
    SpatialIdxTile		= 4,
    //! \brief multi-level Grid
    SpatialIdxDynamic  = 5,
}SpatialIndexType;

@class Point2D;
@interface SpatialIndexInfo : NSObject

@property(nonatomic)SpatialIndexType type;
@property(nonatomic)int leafObjectCount;
@property(nonatomic)int tileWidth;
@property(nonatomic)int tileHeight;
@property(nonatomic,strong)NSString* tileField;
@property(nonatomic,strong)Point2D* gridCenter;
@property(nonatomic)double gridSize0,gridSize1,gridSize2;


//! \brief 索引类型构造
-(id)initWithType:(SpatialIndexType)nIndexType;

//! \brief 四叉树索引
-(id)initWithLeaf:(int)leafObjectCount;

//! \brief 图幅索引
-(id)initWithTileField:(NSString*)tileField;

//! \brief 图幅索引
-(id)initWithWidth:(double)width height:(double)tileHeight;

-(id)initWithInfo:(SpatialIndexInfo*)info;

//! \brief 多级网格索引构造函数
-(id)initWithGridCenter:(Point2D*)gridCenter gridSize0:(double)gridSize0 gridSize1:(double)gridSize1 gridSize2:(double)gridSize2;

-(SpatialIndexInfo*)clone;

-(void)dispose;
@end
