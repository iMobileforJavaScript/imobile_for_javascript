//
//  AnimationRotate.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationGO.h"
#import "Point3D.h"

@interface AnimationRotate : AnimationGO
/**
 * 旋转方向 0);//顺时针 1);//逆时针
 */
@property(nonatomic)int rotateDirection;

@property(nonatomic)Point3D startangle;
@property(nonatomic)Point3D endAngle;
@end
