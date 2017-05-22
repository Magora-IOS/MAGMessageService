//
//  MAGViewController.m
//  MAGMessageService
//
//  Created by magora-ap on 05/21/2017.
//  Copyright (c) 2017 magora-ap. All rights reserved.
//

#import "MAGViewController.h"
#import <MAGMessageService/MAGMessageService.h>

@interface MAGViewController () <MAGMessageServiceDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) MAGMessageService *service;

@end

@implementation MAGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView.text = @"";
    
    self.service = [[MAGMessageService alloc] init];
    self.service.delegate = self;
}


#pragma mark - Actions


- (IBAction)onConnectButtonTap:(id)sender {
    [self.service start];
}

- (IBAction)onSendMessageTap:(id)sender {
    
    NSDictionary *message = @{
                              @"data": @{ @"body": @"text" },
                              @"topicId": @"testid"
                              };
    [self.service sendMessage:message];
}

- (IBAction)onDisconectButtonTap:(id)sender {
    [self.service stop];
}


#pragma mark - <MAGMessageServiceDelegate>


- (void)messageService:(MAGMessageService *)service connectingHandler:(MAGMessageServiceConnectingHandler)handler {
    if (handler != nil) {
        NSURL *url = [NSURL URLWithString:@"ws://127.0.0.1:8000"];
        NSString *token = [[NSUUID UUID] UUIDString];
        handler(url, token);
    }
}

- (void)messageService:(MAGMessageService *)service receivedMessage:(NSDictionary *)message {
    NSLog(@"RR << %@", message);
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.textView.text];
    
    [text appendString:@">>> MESSAGE\n"];
    [text appendString:message.description];
    [text appendString:@"\n"];
    
    self.textView.text = text;
}

- (void)messageService:(MAGMessageService *)service receivedError:(NSError *)error {
    
}


@end
