//
//  MAGSocketClient.m
//  MAGStompKit
//
//  Created by Zykov Mikhail on 12.05.17.
//  Copyright © 2017 Zykov Mikhail. All rights reserved.
//

#import "MAGSocketClient.h"
#import "MAGMessageFrame.h"
#import <SocketRocket/SocketRocket.h>


#define	BYTE_LF @"\x0A"
#define	kCommandConnect @"CONNECT"
#define	kCommandConnected @"CONNECTED"
#define	kCommandMessage @"MESSAGE"
#define	kCommandError @"ERROR"

@interface MAGSocketClient() <SRWebSocketDelegate>

@property (nonatomic, retain) SRWebSocket *socket;
@property (nonatomic, weak) NSTimer *pinger;
@property (nonatomic, weak) NSTimer *ponger;
@property (nonatomic, copy) NSString *token;

@end

@implementation MAGSocketClient

CFAbsoluteTime serverActivity;

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)connectWithUrl:(NSURL *)url token:(NSString *)token {
    self.token = token;
    [self disconnect];
    
    self.socket = [[SRWebSocket alloc] initWithURL:url];
    self.socket.delegate = self;
    [self.socket open];
}

- (void)disconnect {
    [self.pinger invalidate];
    [self.ponger invalidate];
    self.socket.delegate = nil;
    [self.socket close];
    NSLog(@"Web socket did close");
}

- (void)sendMessage:(NSDictionary *)payload {
    NSLog(@"<<< MESSAGE");
    
    if (self.socket.readyState != SR_OPEN) {
        NSLog(@"Can`t send message, socken be not open.");
        return;
    }
    
    MAGMessageFrame *frame = [[MAGMessageFrame alloc] initWithCommand:kCommandMessage payload:payload];
    NSLog(@"%@", frame);
    
    NSData *data = [frame data];
    if (data != nil) {
        [self.socket send:data];
    } else {
        //TODO: Create error: Cant serialize message
        [self.delegate socketClient:self receivedError:nil];
    }
}

#pragma mark - Private

- (void)sendConnection {
    NSDictionary *payload = @{ @"token": self.token };
    MAGMessageFrame *frame = [[MAGMessageFrame alloc] initWithCommand:kCommandConnect payload:payload];
    NSLog(@"%@", frame);
    [self.socket send:[frame data]];
}

- (void)sendPing {
    if (self.socket.readyState != SR_OPEN) {
        return;
    }
    [self.socket send:BYTE_LF];
    NSLog(@"<<< PING");
}

- (void)setupHeartBeat:(NSString *)serverValues {
    NSInteger sx, sy;
    
    NSScanner * scanner = [NSScanner scannerWithString:serverValues];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@", "];
    [scanner scanInteger:&sx];
    [scanner scanInteger:&sy];

    NSInteger pingTTL = ceil(sx / 1000);
    NSInteger pongTTL = ceil(sy / 1000);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pingTTL > 0) {
            self.pinger = [NSTimer scheduledTimerWithTimeInterval: pingTTL
                                                           target: self
                                                         selector: @selector(sendPing)
                                                         userInfo: nil
                                                          repeats: YES];
        }
        if (pongTTL > 0) {
            self.ponger = [NSTimer scheduledTimerWithTimeInterval: pongTTL
                                                           target: self
                                                         selector: @selector(checkPong:)
                                                         userInfo: @{@"ttl": [NSNumber numberWithInteger:pongTTL]}
                                                          repeats: YES];
        }
    });
}

- (void)checkPong:(NSTimer *)timer  {
    NSDictionary *dict = timer.userInfo;
    NSInteger ttl = [dict[@"ttl"] intValue];
    
    CFAbsoluteTime delta = CFAbsoluteTimeGetCurrent() - serverActivity;
    if (delta > (ttl * 2)) {
        NSLog(@"Did not receive server activity for the last %f seconds", delta);
        [self disconnect];
        [self.delegate didCloseSocketClient:self];
    }
}

- (void)receivedFrame:(MAGMessageFrame *)frame {
    if ([frame.command isEqualToString:kCommandConnected]) {
        NSLog(@">>> CONNECTED");
        NSString *heartBeat = frame.payload[@"heartBeat"];
        [self setupHeartBeat:heartBeat];
        [self.delegate didOpenSocketClient:self];
    } else if ([frame.command isEqualToString:kCommandMessage]) {
        NSLog(@">>> MESSAGE");
        [self.delegate socketClient:self receivedMessage:frame.payload];
    } else if ([frame.command isEqualToString:kCommandError]){
        NSLog(@">>> ERROR");
        //TODO: Create error
        [self.delegate socketClient:self receivedError:nil];
    } else {
        NSLog(@">>> UNKNOWN_COMMAND");
        //TODO: Create error
        [self.delegate socketClient:self receivedError:nil];
    }
}
    
#pragma mark - <SRWebSocketDelegate>


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message {
    serverActivity = CFAbsoluteTimeGetCurrent();
    if ([message isEqualToString:BYTE_LF]) {
        NSLog(@">>> PING");
    } else {
        NSLog(@">>> MESSAGE \n%@", message);
        serverActivity = CFAbsoluteTimeGetCurrent();
        MAGMessageFrame *frame = [MAGMessageFrame frameFromMessage:message];
        [self receivedFrame:frame];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Web socket did open");
    [self sendConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Web socket did fail with error: %@", error.localizedDescription);
    [self disconnect];
    [self.delegate didCloseSocketClient:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Web socket did close with code, %ld, %@", (long)code, reason);
    [self disconnect];
    [self.delegate didCloseSocketClient:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@">>> SERVER PONG");
    serverActivity = CFAbsoluteTimeGetCurrent();
}


@end
