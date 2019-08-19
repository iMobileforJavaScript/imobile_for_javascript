//
//  SupplyCenter.h
//  SourcesCode_Objects
//
//  Created by supermap on 2018/8/13.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    /**
     * 非中心点，在资源分配和选址分区时都不予考虑。
     */
    SCT_NULL = 0,
    /**
     * 可选中心点，用于选址分区。
     */
    SCT_OPTIONALCENTER = 1,
    /**
     * 固定中心点，用于资源分配和选址分区。
     */
    SCT_FIXEDCENTER = 2
    
}SupplyCenterType;
@interface SupplyCenter : NSObject
/**
 * 根据给定的资源供给中心点对象构造一个与其完全相同的新对象。
 *
 * @param supplyCenter
 *            给定的资源供给中心点对象。
 */
-(id)initWithSupplyCenter:(SupplyCenter *)supplyCenter;
/**
 * 资源供给中心的最大耗费（阻值）。中心点最大阻值设置越小，表示中心点所提供的资源可影响范围越大。
 * <p>
 * 最大阻力值是用来限制需求点到中心点的花费。如果需求点（弧段或结点）到此中心的花费大于最大阻力值，则该需求点被过滤掉。最大阻力值可编辑。
 */
@property(nonatomic)double maxWeight;
/**
 资源供给中心的资源量。
 */
@property(nonatomic)double resourceValue;
/**
 资源供给中心点的 ID。
 */
@property(nonatomic)int ID;
/**
 * 络分析中资源供给中心点的类型。有关资源供给中心点的类型，请参见 SupplyCenterType 枚举类。
 * <p>
 * 资源供给中心点的类型包括非中心，固定中心和可选中心。固定中心用于资源分配分析；固定中心和可选中心用于选址分析；非中心在两种网络分析时都不予考虑。
 *
 */
@property(nonatomic)SupplyCenterType supplyCenterType;
@end
