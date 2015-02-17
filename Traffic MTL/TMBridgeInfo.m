//
//  TMBridgeInfo.m
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-23.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMBridgeInfo.h"

@implementation TMBridgeInfo

-(void)show{
    NSLog(@"Name: %@", self.bridgeName);
    NSLog(@"Ratio: %f", self.ratio);
    NSLog(@"Name: %d", self.delay);
    NSLog(@"Shore: %d", self.shore);
    
}

@end
