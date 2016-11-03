//
//  ViewController.m
//  GCD_UDPDemo
//
//  Created by vsKing on 2016/11/3.
//  Copyright © 2016年 vsKing. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"


#define SERVER_PORT 2345
#define SERVER_HOST @"192.168.1.255"

@interface ViewController ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  创建一个发送消息按钮
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:btn];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:nil];
    
    NSError * error;
    BOOL response = [self.udpSocket bindToPort:SERVER_PORT error:&error];
    if (response)
    {
        NSLog(@"绑定端口成功");
        
        //  监听广播
        BOOL res = [self.udpSocket beginReceiving:&error];
        if (res)
        {
            NSLog(@"监听成功");
        }else
        {
            NSLog(@"监听失败 error= %@",error);
        }
        
        
        
        
    }else
    {
        NSLog(@"绑定端口失败 error= %@",error);
    }
    
    
    BOOL r = [self.udpSocket enableBroadcast:YES error:&error];
    if (r) {
        NSLog(@"可以广播");
    }else
    {
        NSLog(@"不能广播 error= %@",error);
    }
    
}

-(void)sendMessage
{
    
    NSString * str = @"this is a test";
    NSData * data = [str dataUsingEncoding:NSASCIIStringEncoding];
    [self.udpSocket sendData:data toHost:SERVER_HOST port:SERVER_PORT withTimeout:-1 tag:0];
}


#pragma mark - GCDAsyncUdpSocketDelegate
-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"UDP已经关闭");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"UDP成功发送消息");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"UDP发送消息失败");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"UDP成功收到消息");
    NSString * message = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"message = %@",message);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
