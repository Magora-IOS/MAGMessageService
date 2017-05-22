//
//  MAGMessageService.h
//  MAGStompKit
//
//  Created by Zykov Mikhail on 16.05.17.
//  Copyright © 2017 Zykov Mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAGMessageService;

typedef void(^MAGMessageServiceConnectingHandler)(NSURL *url, NSString *token);

@protocol MAGMessageServiceDelegate <NSObject>

- (void)messageService:(MAGMessageService *)service connectingHandler:(MAGMessageServiceConnectingHandler)handler;
- (void)messageService:(MAGMessageService *)service receivedMessage:(NSDictionary *)message;

@end

@interface MAGMessageService : NSObject

@property (weak, nonatomic) id<MAGMessageServiceDelegate> delegate;

- (void)start;
- (void)stop;
- (void)sendMessage:(NSDictionary *)message;
@end
