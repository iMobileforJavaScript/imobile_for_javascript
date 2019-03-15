//
//  EditHistory.h
//  LibUGC
//
//  Created by wnmng on 2019/1/7.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Recordset;

typedef enum{
    EHT_AddNew = 0,
    EHT_Modify = 1,
    EHT_Delete = 2,
    EHT_Custom = 3
}EditHistoryType;


@interface EditHistory : NSObject
-(BOOL)addHistoryType:(EditHistoryType)editType recordset:(Recordset*)recordset isCurrentOnly:(BOOL)bOnly;
-(void)addMapHistory;
-(void)BatchBegin;
-(void)BatchEnd;
-(void)dispose;
@end
