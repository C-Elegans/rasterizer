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
#define WIDTH 640
#define HEIGHT 480
@implementation ViewController
int* image_data;
float* zbuffer;
vec3 camera = (vec3){1,1,-3};
vec3 center = (vec3){0,0,0};
float color = 0.2;
OBJLoader* loader;
NSBitmapImageRep* imageRep;
void render();
- (void)viewDidLoad {
	[super viewDidLoad];
	//long start_time,stop_time;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"fb" ofType:@"png"];
	
	self.image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	imageRep = [NSBitmapImageRep imageRepWithData:[self.image TIFFRepresentation]];
	NSLog(@"width: %ld, height: %ld",(long)[imageRep pixelsHigh],[imageRep pixelsWide]);
	if([imageRep bitsPerPixel]!= 32){
		NSLog(@"Cannot convert image, incorrect bits per pixel: %ld",[imageRep bitsPerPixel]);
		exit(1);
	}
	loader = [[OBJLoader alloc]init:[[NSBundle mainBundle]pathForResource:@"african_head" ofType:@"obj"]];
	image_data = (int*)[imageRep bitmapData];
	zbuffer = calloc(HEIGHT*WIDTH, sizeof(float));
	if(loader == nil)exit(-1);
	[NSTimer scheduledTimerWithTimeInterval:1/30.0
									 target:self
								   selector:@selector(render)
								   userInfo:nil
									repeats:YES];
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
vec3 barycentric(vec3* pts, vec3 p){
	vec3 u = cross3((vec3){pts[2].x-pts[0].x, pts[1].x-pts[0].x,pts[0].x-p.x}, (vec3){pts[2].y-pts[0].y, pts[1].y-pts[0].y, pts[0].y-p.y});
	if(fabsf(u.z)<1) return (vec3){-1,1,1};
	return (vec3){1.f-(u.x+u.y)/u.z, u.y/u.z, u.x/u.z};
}
void triangle(vec3* pts, int color){
	vec2i bboxmin = (vec2i){WIDTH-1,  HEIGHT-1};
	vec2i bboxmax = (vec2i){0, 0};
	vec2i clamp = (vec2i){WIDTH-1, HEIGHT-1};
	for (int i=0; i<3; i++) {
		bboxmin.x = MAX(0,        MIN(bboxmin.x, pts[i].x));
		bboxmin.y = MAX(0,        MIN(bboxmin.y, pts[i].y));
		
		
		bboxmax.x = MIN(clamp.x, MAX(bboxmax.x, pts[i].x));
		bboxmax.y = MIN(clamp.y, MAX(bboxmax.y, pts[i].y));
	}
	vec3 P;
	
	for (P.x=bboxmin.x; P.x<=bboxmax.x; P.x++) {
		for (P.y=bboxmin.y; P.y<=bboxmax.y; P.y++) {
			vec3 bc_screen  = barycentric(pts, P);
			if (bc_screen.x<0 || bc_screen.y<0 || bc_screen.z<0) continue;
			float z=0;
			z += pts[0].z*bc_screen.x;
			z += pts[1].z*bc_screen.y;
			z += pts[2].z*bc_screen.z;
			if(zbuffer[(int)(P.y*WIDTH+P.x)]<z){
				set_pixel(P.x, P.y, color);
				zbuffer[(int)(P.y*WIDTH+P.x)] = z;
			}
		}
	}
	
}
void randpos(vec2i* ptr){
	
	ptr[0] = (vec2i){rand()%640,rand()%480};
	ptr[1] = (vec2i){rand()%640,rand()%480};
	ptr[2] = (vec2i){rand()%640,rand()%480};
}
void minirender(vec3* vertices, int numvertices){
	
}
-(void) render{
	vec3 lightdir = (vec3){0,0,-1};
	float projection[4][4];
	mat_identity(projection);
	GLKMatrix4 Projection = GLKMatrix4Identity;
	Projection.m32 = -1.f/(normal3(sub3(camera, (vec3){0,0,0}))).x;
	GLKMatrix4 viewMatrix = GLKMatrix4MakePerspective(70 * (180/M_PI), WIDTH/HEIGHT, 0.1, 100);
	GLKMatrix4 cameara = GLKMatrix4MakeLookAt(camera.x, camera.y, camera.z, center.x, center.y, center.z, 0, 1, 0);
	float view_mat[4][4] = {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}};
	float res[4][4];
	float res2[4][4];
	float mview[4][4];
	viewport(WIDTH/8, HEIGHT/8, WIDTH*(3.0/4.0), HEIGHT*(3.0/4.0),&view_mat[0][0]);
	matmul(view_mat, projection, res2);
	lookat(camera, (vec3){0,0,0}, (vec3){0,1,0}, mview);
	matmul(res2,mview, res);
	for (Vec3i *face in loader.faces) {
		
		
		vec3 screen_coords[3];
		vec3 world_coords[3];
		world_coords[0] = [[loader.vertices objectAtIndex:face.x] toVec];
		world_coords[1] = [[loader.vertices objectAtIndex:face.y] toVec];
		world_coords[2] = [[loader.vertices objectAtIndex:face.z] toVec];
		for(int i=0;i<3;i++){
			vec4 proj_coords = vecmul((vec4){world_coords[i].x,world_coords[i].y,world_coords[i].z,1}, &res[0][0]);
			screen_coords[i] = wdiv(proj_coords);
			screen_coords[i].y = HEIGHT-screen_coords[i].y;
		}
		
		
		
		vec3 n = cross3(sub3(world_coords[2],world_coords[0]), sub3(world_coords[1], world_coords[0]));
		n=normal3(n);
		int intensity = (int)(dot3(n,lightdir)*255) ;
		if(intensity>0) triangle(screen_coords, 0xFF000000 |(int)(intensity*color)|(intensity<<8)|intensity<<16);
	}
	self.image = [[NSImage alloc] initWithCGImage:[imageRep CGImage] size:[imageRep size]];
	camera.z+=0.1/30;
	camera.z -= 0.1/30;
	color += 0.05/30;
}

@end
