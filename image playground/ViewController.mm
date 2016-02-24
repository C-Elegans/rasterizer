//
//  ViewController.m
//  image playground
//
//  Created by Michael Nolan on 11/4/15.
//  Copyright © 2015 Michael Nolan. All rights reserved.
//

#import "ViewController.h"
#include <xmmintrin.h>
#include <tmmintrin.h>
#include <smmintrin.h>
#import <GLKit/GLKit.h>

@implementation ViewController

void render();
-(void) refresh{
	[self.view setNeedsDisplay:YES];
	
}
- (void)viewDidLoad {
	[super viewDidLoad];
	//long start_time,stop_time;
	
	// Do any additional setup after loading the view.
	NSRunLoop *runloop = [NSRunLoop currentRunLoop];
	NSTimer *timer = [NSTimer timerWithTimeInterval:1/10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
	[runloop addTimer:timer forMode:NSRunLoopCommonModes];
	[runloop addTimer:timer forMode: NSEventTrackingRunLoopMode];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
	
	// Update the view, if already loaded.
}

@end
