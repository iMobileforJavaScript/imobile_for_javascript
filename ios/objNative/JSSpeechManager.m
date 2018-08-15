//
//  JSSpeechManager.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSpeechManager.h"
#import "JSObjManager.h"
#import "SuperMap/SpeechManager.h"
#import "SuperMap/IntelligentSpeechDelegate.h"
@interface JSSpeechManager()<IntelligentSpeechDelegate>
{
    
}
@end
@implementation JSSpeechManager
RCT_EXPORT_MODULE();

static NSString* BEGIN_OF_SPEECH = @"com.supermap.RN.JSSpeechManager.begin_of_speech";
static NSString* END_OF_SPEECH = @"com.supermap.RN.JSSpeechManager.end_of_speech";
static NSString* ERROR = @"com.supermap.RN.JSSpeechManager.error";
static NSString* RESULT = @"com.supermap.RN.JSSpeechManager.result";
static NSString* VOLUME_CHANGED = @"com.supermap.RN.JSSpeechManager.volume_changed";

//所有导出方法名
- (NSArray<NSString *> *)supportedEvents
{
    return @[BEGIN_OF_SPEECH, END_OF_SPEECH, ERROR,RESULT,VOLUME_CHANGED];
}

static SpeechManager* m_SpeechManager = nil;

-(id)init{
    if(self=[super init]){
        if(!m_SpeechManager){
            //to do
            m_SpeechManager = [SpeechManager sharedInstance];
        }
    }
    
    return self;
}
/**
 * 初始化语音SDK组件(只能在主线程中调用)，只需在应用启动时调用一次就够了
 * @param promise
 */
RCT_REMAP_METHOD(init, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
       
        if(!m_SpeechManager){
            //to do
            m_SpeechManager = [SpeechManager sharedInstance];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}

/**
 * 通过此函数取消当前的会话
 * @param promise
 */

RCT_REMAP_METHOD(cancel, cancelResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
            [m_SpeechManager cancel];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}



/**
 * 在调用本函数进行销毁前，应先保证当前不在会话中，否则，本函数将尝试取消当前会话，并返回false，此时销毁失败
 * @param promise
 */
RCT_REMAP_METHOD(destroy, destroyResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
            [m_SpeechManager destroy];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}


/**
 * 通过此函数，获取当前SDK是否正在进行会话
 * @param promise
 */

RCT_REMAP_METHOD(isListening, isListeningResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL b =NO;
        if(m_SpeechManager){
            //to do
            b = [m_SpeechManager isListening];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}



/**
 * 设置音频保存路径:(目前支持音频文件格式为wav格式) 通过此参数，可以在识别完成后在本地保存一个音频文件
 * 是否必须设置：否 默认值：null (不保存音频文件)
 * @param promise
 */
RCT_REMAP_METHOD(setAudioPath, path:(NSString*)path isListeningResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
//            [m_SpeechManager setA];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}
//@ReactMethod
//public void setAudioPath(String path, Promise promise){
//    try {
//        m_SpeechManager = getInstance();
//        m_SpeechManager.setAudioPath(path);
//        promise.resolve(true);
//    } catch (Exception e){
//        promise.reject(e);
//    }
//}

/**
 * 设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
 * 是否必须设置：否 默认值：听写5000，其他4000 值范围：[1000, 10000]
 * @param time
 * @param promise
 */
RCT_REMAP_METHOD(setVAD_BOS_Time,vadTime:(int)time Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
            
            m_SpeechManager.VAD_BOS_Time = time;
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}


/**
 * 设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入，自动停止录音
 * 是否必须设置：否 默认值：听写1800，其他700 值范围：[0, 10000]
 * @param time
 * @param promise
 */
RCT_REMAP_METHOD(setVAD_EOS_Time, time:(int)time  Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
            m_SpeechManager.VAD_EOS_Time=time;
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}
//@ReactMethod
//public void setVAD_EOS_Time(int time, Promise promise){
//    try {
//        m_SpeechManager = getInstance();
//        m_SpeechManager.setVAD_EOS_Time(time);
//        promise.resolve(true);
//    } catch (Exception e){
//        promise.reject(e);
//    }
//}

/**
 * 调用此函数，开始语音听写
 * @param promise
 */
RCT_REMAP_METHOD(startListening, startListeningResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
            m_SpeechManager.delegate = self;
            [m_SpeechManager startListenter];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}


/**
 * 调用本函数告知SDK，当前会话音频已全部录入
 * @param promise
 */
RCT_REMAP_METHOD(stopListening, stopListeningResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(m_SpeechManager){
            //to do
             [m_SpeechManager stopListenter];
        }
        NSNumber* nsRemoved = [NSNumber numberWithBool:YES];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}


#pragma mark  IntelligentSpeechDelegate
/*!
 *  识别结果回调
 *
 *  在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorInfo 错误描述
 */
-(void) onError:(NSString *)errorInfo{
    [self sendEventWithName:ERROR
                       body:errorInfo];
}
/*!
 *  识别结果回调
 *
 *  在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。<br>
 *  @param results  -[out] 识别结果
 *  @param isLast   -[out] 是否最后一个结果
 */
-(void) onResults:(NSString *)results isLast:(BOOL)isLast{
    [self sendEventWithName:RESULT
                           body:@{@"info":results
                                  ,@"isLast":[NSNumber numberWithBool:isLast]}];
}
/*!
 *  音量变化回调<br>
 *  在录音过程中，回调音频的音量。
 *
 *  @param volume -[out] 音量，范围从0-30
 */
- (void) onVolumeChanged: (int)volume{
    [self sendEventWithName:VOLUME_CHANGED body:@(volume)];
}

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。<br>
 *  如果发生错误则回调onError:函数
 */
- (void) onBeginOfSpeech{
    [self sendEventWithName:BEGIN_OF_SPEECH body:[NSNumber numberWithBool:YES]];
}

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onError:函数
 */
- (void) onEndOfSpeech{
    [self sendEventWithName:END_OF_SPEECH body:[NSNumber numberWithBool:YES]];
}

/*!
 *  取消识别回调<br>
 *  当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个<br>
 *  短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void) onCancel{
    
}
@end
