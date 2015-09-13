//
//  ViewController.m
//  Tech Digest
//
//  Created by Robert Varga on 12/09/2015.
//  Copyright (c) 2015 Robert Varga. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    

}


@end
