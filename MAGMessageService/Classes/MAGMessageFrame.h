//
//  MAGMessageFrame.h
//  MAGStompKit
//
//  Created by Zykov Mikhail on 15.05.17.
//  Copyright © 2017 Zykov Mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGMessageFrame : NSObject

@property (nonatomic, readonly) NSString *command;
@property (nonatomic, readonly) NSDictionary *payload;


+ (MAGMessageFrame *)frameFromMessage:(NSString *)message;

- (instancetype)initWithCommand:(NSString *)command payload:(NSDictionary *)payload;
- (NSData *)data;
    
    
@end
