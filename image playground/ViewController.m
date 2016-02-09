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
#define HEIGHT 480
@implementation ViewController
int* image_data;

void render(vec3* vertices, int numvertices, face* faces, int numfaces);
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
	OBJLoader* loader = [[OBJLoader alloc]init:[[NSBundle mainBundle]pathForResource:@"african_head" ofType:@"obj"]];
	image_data = (int*)[imageRep bitmapData];
	if(loader == nil)exit(-1);
	render(loader.vertices,loader.numVertices, loader.faces, loader.numFaces);
	
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
vec3 barycentric(vec2i* pts, vec2i p){
	vec3 u = cross3((vec3){pts[2].x-pts[0].x, pts[1].x-pts[0].x,pts[0].x-p.x}, (vec3){pts[2].y-pts[0].y, pts[1].y-pts[0].y, pts[0].y-p.y});
	if(fabsf(u.z)<1) return (vec3){-1,1,1};
	return (vec3){1.f-(u.x+u.y)/u.z, u.y/u.z, u.x/u.z};
}
void triangle(vec2i* pts, int color){
	vec2i bboxmin = (vec2i){WIDTH-1,  HEIGHT-1};
	vec2i bboxmax = (vec2i){0, 0};
	vec2i clamp = (vec2i){WIDTH-1, HEIGHT-1};
	for (int i=0; i<3; i++) {
		bboxmin.x = MAX(0,        MIN(bboxmin.x, pts[i].x));
		bboxmin.y = MAX(0,        MIN(bboxmin.y, pts[i].y));
		
		
		bboxmax.x = MIN(clamp.x, MAX(bboxmax.x, pts[i].x));
		bboxmax.y = MIN(clamp.y, MAX(bboxmax.y, pts[i].y));
	}
	vec2i P;
	for (P.x=bboxmin.x; P.x<=bboxmax.x; P.x++) {
		for (P.y=bboxmin.y; P.y<=bboxmax.y; P.y++) {
			vec3 bc_screen  = barycentric(pts, P);
			if (bc_screen.x<0 || bc_screen.y<0 || bc_screen.z<0) continue;
			set_pixel(P.x, P.y, color);
		}
	}
	
}
void randpos(vec2i* ptr){
	
	ptr[0] = (vec2i){rand()%640,rand()%480};
	ptr[1] = (vec2i){rand()%640,rand()%480};
	ptr[2] = (vec2i){rand()%640,rand()%480};
}
void render(vec3* vertices, int numvertices, face* faces, int numfaces){
	for(int i=0; i<numfaces;i++){
		face f = faces[i];
	
		
		
		vec2i screen_coords[3];
		NSLog(@"vert.x: %f",vertices[f.x].x);
		vec3 world_coords = vertices[0];
		screen_coords[0] = (vec2i){(world_coords.x+1.)*WIDTH/2., (world_coords.y+1.)*HEIGHT/2.};
		world_coords = vertices[1];
		screen_coords[1] = (vec2i){(world_coords.x+1.)*WIDTH/2., (world_coords.y+1.)*HEIGHT/2.};
		world_coords = vertices[2];
		screen_coords[2] = (vec2i){(world_coords.x+1.)*WIDTH/2., (world_coords.y+1.)*HEIGHT/2.};
		
		triangle(screen_coords, rand() | 0xFF000000);
	
	}
}


@end
