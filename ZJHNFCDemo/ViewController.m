//
//  ViewController.m
//  ZJHNFCDemo
//
//  Created by ZhangJingHao48 on 2019/9/4.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>

@interface ViewController () <NFCNDEFReaderSessionDelegate>

@end

@implementation ViewController

// 开始扫描
- (IBAction)startScan {
    /*
     条件：iphone7/7plus运行iOS11及以上
     invalidateAfterFirstRead 属性表示是否需要识别多个NFC标签，
     如果是YES，则会话会在第一次识别成功后终止。否则会话会持续。
     不过有一种例外情况，就是如果响应了-readerSession:didInvalidateWithError:方法，
     则是否为YES，会话都会被终止
     */
    NFCNDEFReaderSession *session =
    [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                             queue:nil
                          invalidateAfterFirstRead:YES];
    // 开始扫描
    [session beginSession];
}

// 扫描到的回调
-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
    
    /*
     数组messages中是NFCNDEFMessage对象
     NFCNDEFMessage对象中有一个records数组，这个数组中是NFCNDEFPayload对象
     参考NFCNDEFMessage、NFCNDEFPayload类
     */
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *record in message.records) {
            NSString *dataStr = [[NSString alloc] initWithData:record.payload
                                                      encoding:NSUTF8StringEncoding];
            NSLog(@"扫描结果 ：%@", dataStr);
        }
    }
    
    // 主动终止会话，调用如下方法即可。
    [session invalidateSession];
}

// 错误回调
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
    // 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
    NSLog(@"错误回调 : %@", error);
}

@end
