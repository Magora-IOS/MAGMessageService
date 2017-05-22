//
//  MAGSocketClient.h
//  MAGStompKit
//
//  Created by Zykov Mikhail on 12.05.17.
//  Copyright © 2017 Zykov Mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAGSocketClient;


extern NSString * const MAGSocketClientErrorDomian;

typedef enum MAGErrorCode : NSInteger {

    MAGErrorCodeUnknownCommand = 1001,
    MAGErrorCodeErrorCommand = 1002,
    MAGErrorCodeCantSerialize = 1003
    
} MAGErrorCode;

@protocol MAGSocketClientDelegate <NSObject>

- (void)didOpenSocketClient:(MAGSocketClient *)client;
- (void)didCloseSocketClient:(MAGSocketClient *)client;

- (void)socketClient:(MAGSocketClient *)client receivedMessage:(NSDictionary *)message;
- (void)socketClient:(MAGSocketClient *)client receivedError:(NSError *)error;

@end

@interface MAGSocketClient : NSObject

@property (weak, nonatomic) id<MAGSocketClientDelegate> delegate;

- (void)connectWithUrl:(NSURL *)url token:(NSString *)token;
- (void)disconnect;
- (void)sendMessage:(NSDictionary *)message;

@end
