//
//  SpeechRecognizerDelegate.h
//  MSC_ASR
//
//  Created by supermap on 2018/1/18.
//  Copyright © 2018年 luchd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IntelligentSpeechDelegate <NSObject>

@required
/*!
 *  识别结果回调
 *
 *  在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorInfo进行相应的处理，当errorInfo没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorInfo 错误描述
 */
-(void) onError:(NSString *)errorInfo;
/*!
 *  识别结果回调
 *
 *  在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。<br>
 *  @param results  -[out] 识别结果
 *  @param isLast   -[out] 是否最后一个结果
 */
-(void) onResults:(NSString *)results isLast:(BOOL)isLast;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@optional
/*!
 *  音量变化回调<br>
 *  在录音过程中，回调音频的音量。
 *
 *  @param volume -[out] 音量，范围从0-30
 */
- (void) onVolumeChanged: (int)volume;

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。<br>
 *  如果发生错误则回调onError:函数
 */
- (void) onBeginOfSpeech;

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onError:函数
 */
- (void) onEndOfSpeech;

/*!
 *  取消识别回调<br>
 *  当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个<br>
 *  短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void) onCancel;
@end
