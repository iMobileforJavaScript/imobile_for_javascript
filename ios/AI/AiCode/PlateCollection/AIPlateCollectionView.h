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




@protocol AIPlateCollectionDelegate <NSObject>

-(void)collectedPlate:(NSString*)strPlate carType:(NSString*)carType colorDescription:(NSString*)strColor andImage:(UIImage*)carImage;

@end

@interface AIPlateCollectionView : UIView

@property (nonatomic,assign) id<AIPlateCollectionDelegate> delegate;

//-(void)loadDetectModle:(NSString *)modelPath labels:(NSString *)labelPath;

-(void) startCollection;
-(void) stopCollection;

-(void)setLanguage:(NSString*)type;

-(void)dispose;

-(void)setDetectIntervalMillisecond:(long)intervalMilisecond;
-(void)initData;
@end

NS_ASSUME_NONNULL_END
