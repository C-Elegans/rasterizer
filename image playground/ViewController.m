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
#define WIDTH 640
#define HEIGHT 480;
@implementation ViewController
int* image_data;
void render();
- (void)viewDidLoad {
	[super viewDidLoad];
	long start_time,stop_time;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"fb" ofType:@"png"];
	self.image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:[self.image TIFFRepresentation]];
	NSLog(@"width: %ld, height: %ld",(long)[imageRep pixelsHigh],[imageRep pixelsWide]);
	if([imageRep bitsPerPixel]!= 32){
		NSLog(@"Cannot convert image, incorrect bits per pixel: %ld",[imageRep bitsPerPixel]);
		exit(1);
	}
	image_data = (int*)[imageRep bitmapData];
	
	size_t size = [imageRep pixelsHigh] * [imageRep pixelsWide]* ([imageRep bitsPerPixel]/8);
	
	start_time = mach_absolute_time();
	
	render();
	stop_time = mach_absolute_time();
	long elapsed = stop_time-start_time;
	mach_timebase_info_data_t info;
	mach_timebase_info(&info);
	double nanoseconds = (double)elapsed * (double)info.numer/(double)info.denom;
	NSLog(@"Time to convert %f",nanoseconds/1e6);
	self.image = [[NSImage alloc] initWithCGImage:[imageRep CGImage] size:[imageRep size]];
	// Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
	
	// Update the view, if already loaded.
}
void set_pixel(int x, int y, int color){
	int* ptr = image_data;
	ptr += y*WIDTH;
	ptr += x;
	*ptr = color;
}
void render(){
	for(int i=0;i<20;i++){
		set_pixel(100, i+100, 0xFF0000FF);
	}
}

@end
