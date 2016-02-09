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
	//long start_time,stop_time;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"fb" ofType:@"png"];
	
	self.image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:[self.image TIFFRepresentation]];
	NSLog(@"width: %ld, height: %ld",(long)[imageRep pixelsHigh],[imageRep pixelsWide]);
	if([imageRep bitsPerPixel]!= 32){
		NSLog(@"Cannot convert image, incorrect bits per pixel: %ld",[imageRep bitsPerPixel]);
		exit(1);
	}
	image_data = (int*)[imageRep bitmapData];
	render();
	
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
void fill_row(int x0,int x1, int y, int color){
	int* ptr = image_data;
	ptr+= (y*WIDTH)+x0;
	for(;x0<=x1;x0++){
		*ptr=color;
		ptr++;
	}
}
void swap(vec3i* a, vec3i* b){
	vec3i temp;
	temp = *a;
	*a=*b;
	*b=temp;
}
void line(vec3i a, vec3i b, int color){
	int dx = abs(b.x-a.x), sx = a.x<b.x ? 1 : -1;
	int dy = abs(b.y-a.y), sy = a.y<b.y ? 1 : -1;
	int err = (dx>dy ? dx : -dy)/2, e2;
	
	for(;;){
		set_pixel(a.x,a.y,color);
		if (a.x==b.x && a.y==b.y) break;
		e2 = err;
		if (e2 >-dx) { err -= dy; a.x += sx; }
		if (e2 < dy) { err += dx; a.y += sy; }
	}
}
void triangle(vec3i a, vec3i b, vec3i c, int color){
	if (a.y>b.y) swap(&a, &b);
	if (a.y>c.y) swap(&a, &c);
	if (b.y>c.y) swap(&b, &c);
	float m = ((float)c.y-a.y)/((float)c.x-a.x);
	float xnew = (((float)b.y-a.y)/m) + (float)a.x;
	vec3i d = (vec3i){(int) xnew, b.y,0};
	if(b.x>d.x)swap(&b,&d);
	
	float x0=b.x;
	float x1=d.x;
	float step = (float)(c.x-b.x)/(float)(c.y-b.y);
	float step2 = (float)(d.x-c.x)/(float)(d.y-c.y);
	for(int y=b.y;y<c.y;y++){
		x0 += step;
		x1 += step2;
		fill_row(x0, x1, y, color);
	}
	x0=b.x;
	x1=d.x;
	step = (float)(a.x-b.x)/(float)(a.y-b.y);
	 step2 = (float)(d.x-a.x)/(float)(d.y-a.y);
	for(int y=b.y;y>a.y;y--){
		x0 -= step;
		x1 -= step2;
		fill_row(x0, x1, y, color);
	}
	
}
vec3i randpos(){
	return (vec3i){rand()%640,rand()%480,0};
}
void render(){
	srand(0);
	printf("color: %x\n",*image_data);
	//vec3i a,b,c;
	for(int i=0;i<1000;i++){
		triangle(randpos(), randpos(), randpos(), rand() | 0xff000000);
	}
	
	
}

@end
