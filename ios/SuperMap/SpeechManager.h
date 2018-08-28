//
//  SpeechRecongnizer.h
//  MSC_ASR
//
//  Created by supermap on 2018/1/18.
//  Copyright © 2018年 luchd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntelligentSpeechDelegate.h"


@interface SpeechManager : NSObject{
   
}
@property (nonatomic)id<IntelligentSpeechDelegate> delegate;


+(id)sharedInstance;
/**
 * 调用本函数告知SDK，当前会话音频已全部录入。
 * 在调用本函数后，已录入的音频还在继续上传到服务器，结果不会马上就返回，当前会 话还在继续，直到结果返回完毕，或出现错误。
 * 要取消会话，请参考cancel()函数。
 * 当应用调用本函数结束停止录音时，SDK不会再回调 onEndOfSpeech()。相反的，当SDK回调 onEndOfSpeech()时，应用层可不必再调用本函数通知SDK停止录音。
 */
-(void) stopListenter;
/**
 * 调用此函数，开始语音听写。
 *
 * 目前SDK不支持多线程，所以在调用本函数开始一次会话后，直到结束前(结果返回 完毕，或出现错误)，不能再调用本函数开始新的会话。一次会话，即从会话开始，到结 束为止。
 * 如需设置相应的参数，则应该在调用本函数前设置。
 *
 * 可通过cancel()取消当前的会话。
 */
-(void) startListenter;
/**
 * 通过此函数取消当前的会话。
 * 在会话被取消后，当前会话结束，未返回的结果将不再返回。
 */
-(void) cancel;
/**
 * 在调用本函数进行销毁前，应先保证当前不在会话中，否则，本函数将尝试取消当前会话，并返回false，此时销毁失败。关于当前是否在会话中，请参考函数 isListening()。若销毁失败，请在取消当前会话后，再次调用本函数重试。
 * 当本函数返回true时，销毁成功。此时，之前创建的单例对象已不能再使用，否则，将会报错。此时需要再使用，应先通过getInstance(Context context)创建一个新的单例对象。
 * @return 销毁成功：true；销毁失败：false。
 */
-(BOOL)destroy;
/**
 * 通过此函数，获取当前SDK是否正在进行会话。应用层可通过此函数，查询能否 开始一路新的会话等。
 * 调用了stopListening()停止录音后，如果会话未出现错误或返回最后的结果， 当前状态依然处于会话中，即本函数会返回true。如果调用cancel()取消了会话， 则当前状态处于不在会话中。
 * @return 会话状态，true：正在会话中；false：不在会话中
 */
-(BOOL)isListening;

/**
 * 设置识别音频文件的名字(格式为xxx.wav)
 * 通过此参数，可以在识别完成后在本地保存一个音频文件（默认保存目录在Library/Caches）
 * 是否必须设置：否
 */
@property (nonatomic,strong) NSString* audioName;
/**
 *设置是否返回标点符号,设置为true返回结果有标点,设置为false返回结果无标点。
 *
 */
@property (nonatomic,assign) BOOL isPunctuation;
/**
 * 设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
 *
 * 是否必须设置：否
 * 默认值：听写5000，其他4000
 * 值范围：[1000, 10000]
 *
 */
@property (nonatomic,assign)NSInteger VAD_BOS_Time;
/**
 *  设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入， 自动停止录音
 *
 *  是否必须设置：否
 *  默认值：听写1800，其他700
 *  值范围：[0, 10000]
 */
@property (nonatomic,assign)NSInteger VAD_EOS_Time;
@end
