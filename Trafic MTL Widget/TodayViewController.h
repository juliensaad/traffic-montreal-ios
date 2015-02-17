//
//  TodayViewController.h
//  Trafic MTL
//
//  Created by Julien Saad on 2014-11-08.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UIButton *widgetBtn;
- (IBAction)buttonClick:(id)sender;

@end
