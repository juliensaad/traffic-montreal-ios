//
//  TodayViewController.m
//  Trafic MTL
//
//  Created by Julien Saad on 2014-11-08.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TMBridgeInfo.h"
#import "config.h"
@interface TodayViewController () <NCWidgetProviding>

@property NSMutableData* responseData;
@property NSMutableArray* bridges;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _helloLabel.text = @"OMG";
    [self loadTimes];
    _helloLabel.text = @"Loading";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    NSLog(@"COUCOU");
    completionHandler(NCUpdateResultNewData);
}


-(void)loadTimes{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://thirdbridge.net/traffic_dev/traffic.php"]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *postString = ISFRENCH?@"lang=1":@"lang=0";
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection* con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];
 
}

#pragma mark Connection handling
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
 
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSError *error;
    NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    
    // In case there is an error in the return value
    if([jsonDict isKindOfClass:[NSNull class]] || jsonDict==nil){
        
        return ;
    }
    _bridges = [[NSMutableArray alloc] init];
    
    NSMutableArray* bridgesMTL = [[NSMutableArray alloc] init];
    NSMutableArray* bridgesBanlieue = [[NSMutableArray alloc] init];
    
    NSMutableArray* bridgesMTLNORD = [[NSMutableArray alloc] init];
    NSMutableArray* bridgesBanlieueNORD = [[NSMutableArray alloc] init];
    
    for(NSDictionary* dic in jsonDict){
        TMBridgeInfo* info = [[TMBridgeInfo alloc] init];
        
        info.bridgeName = [dic objectForKey:@"bridgeName"];
        info.direction = [[dic objectForKey:@"direction"] intValue];
        info.realTime = [[dic objectForKey:@"realTime"] intValue];
        info.time = [[dic objectForKey:@"time"] intValue];
        
        info.percentage = [[dic objectForKey:@"percentage"] intValue];
        info.delay = [[dic objectForKey:@"delay"] intValue];
        info.bridgeId = [[dic objectForKey:@"id"] intValue];
        info.condition = [dic objectForKey:@"cond"];
        
        // Scan hex value for color
        unsigned int outVal;
        NSScanner* scanner = [NSScanner scannerWithString:[dic objectForKey:@"color"]];
        [scanner scanHexInt:&outVal];
        info.rgb = outVal;
        
        info.ratio = 1.0-(float)info.time/(float)info.realTime;
        
        info.shore = [[dic objectForKey:@"shore"] intValue];
        
        if(info.shore == 0)
            [info.direction?bridgesBanlieue:bridgesMTL addObject:info];
        else
            [info.direction?bridgesBanlieueNORD:bridgesMTLNORD addObject:info];
        
    }
    
    [_bridges addObject:bridgesMTL];
    [_bridges addObject:bridgesBanlieue];
    [_bridges addObject:bridgesMTLNORD];
    [_bridges addObject:bridgesBanlieueNORD];
   
    [[bridgesMTL objectAtIndex:0] show]
    ;
    _helloLabel.text =  @"Showing";
    // NSLog(@"%@",[NSString stringWithFormat:@"%@",[[bridgesMTL objectAtIndex:0] bridgeName]]);
    
    //_helloLabel.text = [NSString stringWithFormat:@"%@: %d",[[bridgesMTL objectAtIndex:0] bridgeName],[[bridgesMTL objectAtIndex:0] delay]];
    
}


- (IBAction)buttonClick:(id)sender {
    [self loadTimes];
    NSLog(@"Loading");
}
@end
