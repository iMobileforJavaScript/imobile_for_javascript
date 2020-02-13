//
//  AIPlateCollectionView.h
//  SuperMapAI
//
//  Created by wnmng on 2019/12/20.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef enum{
    AI_CAR ,
    AI_BUS ,
    AI_TRUCK
}AICARType;


@protocol AIPlateCollectionDelegate <NSObject>

-(void)collectedPlate:(NSString*)strPlate forCarType:(AICARType)carType andImage:(UIImage*)carImage;

@end

@interface AIPlateCollectionView : UIView

@property (nonatomic,assign) id<AIPlateCollectionDelegate> delegate;

-(void) startCollection;
-(void) stopCollection;

@end

NS_ASSUME_NONNULL_END
