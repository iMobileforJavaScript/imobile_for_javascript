//
//  SMSymbolTable.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/13.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SuperMap/SymbolLibLegend.h"
#import "SuperMap/Color.h"
#import "Constants.h"
#import "SMap.h"
#import "SMSymbol.h"

@interface SMSymbolTable : RCTViewManager<SymbolLibLegendDelegate>
//@property (nonatomic, copy) RCTBubblingEventBlock onCellClickEvent;
@end
