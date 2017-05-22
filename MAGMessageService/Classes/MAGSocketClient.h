//
//  MAGSocketClient.h
//  MAGStompKit
//
//  Created by Zykov Mikhail on 12.05.17.
//  Copyright © 2017 Zykov Mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAGSocketClient;

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
