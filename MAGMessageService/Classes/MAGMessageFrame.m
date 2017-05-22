//
//  MAGMessageFrame.m
//  MAGStompKit
//
//  Created by Zykov Mikhail on 15.05.17.
//  Copyright © 2017 Zykov Mikhail. All rights reserved.
//

#import "MAGMessageFrame.h"

const NSString *kCommandKey = @"command";
const NSString *kPayloadKey = @"payload";

@interface MAGMessageFrame()
    
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSDictionary *payload;


@end

@implementation MAGMessageFrame

+ (MAGMessageFrame *)frameFromMessage:(NSString *)message {
    MAGMessageFrame *frame = [[MAGMessageFrame alloc] init];
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    frame.command = json[kCommandKey];
    frame.payload = json[kPayloadKey];
    
    return frame;
}
 
- (instancetype)initWithCommand:(NSString *)command payload:(NSDictionary *)payload {
    self = [super init];
    if (self) {
        _command = command;
        _payload = payload;
    }
    return self;
}


- (NSData *)data {
    NSError *localError = nil;
    NSDictionary *message =
    @{
      kCommandKey : self.command,
      kPayloadKey : self.payload
      };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:&localError];
    if (localError != nil) {
        NSLog(@"Serialization error");
        return nil;
    }
    return data;
}

- (NSString *)description {
    NSDictionary *message = @{
        kCommandKey : self.command,
        kPayloadKey : self.payload
    };
    return message.description;
}

    
@end
