//
//  AnimationGrow.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationGO.h"

@interface AnimationGrow : AnimationGO

//! \brief 生长起始位置,范围为[0,1]。
//! \param location [in]起始位置。
@property(nonatomic)double startLocation;

//! \brief 生长终止位置, 范围为[0,1]。
//! \param location [in]终止位置。
@property(nonatomic)double endLocation;
@end
