//
//  GraphicsView.m
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import "GraphicsView.h"
#import <GLKit/GLKit.h>
#include <mmintrin.h>
#import "Model.h"
#include "shader.h"

#include <mach/mach.h>
#include <mach/mach_time.h>
#define WIDTH 640
#define HEIGHT 480
#define BYTES_PER_PIXEL 4
#define BITS_PER_COMPONENT 8
#define BITS_PER_PIXEL 32
#define SIZE WIDTH*HEIGHT*sizeof(int)
@implementation GraphicsView
int* image_data;
float* zbuffer;
NSMutableArray<Model*>* models;
vec3 camera = (vec3){1,0,3};
vec3 center = (vec3){0,0,0};
vec3 lightdir = (vec3){0,0,-1};
NSBitmapImageRep* imageRep;


-(void) common_init{
	
	image_data = (int *)calloc(SIZE, sizeof(unsigned short));
	models = [NSMutableArray new];
	Model* model = [[Model alloc] initFromFile:[[NSBundle mainBundle]pathForResource:@"african_head" ofType:@"obj"] position:(vec3) {0,0,0} rotation:(vec3){0,0,0}];
	[models addObject:model];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"african_head_diffuse" ofType:@"png"];
	
	self.image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	imageRep = [NSBitmapImageRep imageRepWithData:[self.image TIFFRepresentation]];
	
	head_diffuse.height = [self.image size].height;
	head_diffuse.width = [self.image size].width;
	head_diffuse.bytesperpixel = (int)[imageRep bitsPerPixel]/8;
	
	head_diffuse.data = (color*)[imageRep bitmapData];
	//[models addObject:[[Model alloc] initFromFile:[[NSBundle mainBundle]pathForResource:@"floor" ofType:@"obj"] position:(vec3) {0,0,0} rotation:(vec3){-M_PI/8,0,0}]];
	zbuffer = (float*)calloc(HEIGHT*WIDTH, sizeof(float));
	
}
- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self common_init];
	}
	return self;
}
-(id)initWithCoder:(NSCoder *)coder{
	self = [super initWithCoder:coder];
	if (self) {
		[self common_init];
	}
	return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	// Colorspace RGB
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	
	// Pixel Matrix allocation
	
	memset(image_data, 0, SIZE);
	memset(zbuffer,0,WIDTH*HEIGHT*sizeof(float));
	// Random pixels will give you a non-organized RAINBOW
	long start, stop;
	start = mach_absolute_time();
	[self render];
	stop = mach_absolute_time();
	NSLog(@"frametime %.02f ms",(stop-start)/1000000.0);
	// Provider
	CGDataProviderRef provider = CGDataProviderCreateWithData(nil, image_data, SIZE, nil);
	
	// CGImage
	CGImageRef image = CGImageCreate(WIDTH,
									 HEIGHT,
									 BITS_PER_COMPONENT,
									 BITS_PER_PIXEL,
									 BYTES_PER_PIXEL*WIDTH,
									 colorSpace,
									 kCGImageAlphaNoneSkipFirst,
									 // xRRRRRGGGGGBBBBB - 16-bits, first bit is ignored!
									 provider,
									 nil, //No decode
									 NO,  //No interpolation
									 kCGRenderingIntentDefault); // Default rendering
	
	// Draw
	CGContextDrawImage(context, self.bounds, image);
	
	// Once everything is written on screen we can release everything
	CGImageRelease(image);
	CGColorSpaceRelease(colorSpace);
	CGDataProviderRelease(provider);
	
    // Drawing code here.
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
float orient2d(vec3 a, vec3 b, vec3 c){
	return (b.x-a.x)*(c.y-a.y) - (b.y-a.y)*(c.x-a.x);
}

void triangle(vec3* pts, vec2* uvs, vec3* normals, vec3* pos, CGRect box){
	vec2i bboxmin = (vec2i){WIDTH-1,  HEIGHT-1};
	vec2i bboxmax = (vec2i){(int)box.origin.x, (int)box.origin.y};
	vec2i clamp = (vec2i){static_cast<int>(box.origin.x + box.size.width), static_cast<int>(box.origin.y + box.size.height)};
	for (int i=0; i<3; i++) {
		bboxmin.x = MAX(box.origin.x,        MIN(bboxmin.x, pts[i].x));
		bboxmin.y = MAX(box.origin.y,        MIN(bboxmin.y, pts[i].y));
		
		
		bboxmax.x = MIN(clamp.x, MAX(bboxmax.x, pts[i].x));
		bboxmax.y = MIN(clamp.y, MAX(bboxmax.y, pts[i].y));
	}
	
	
	// Barycentric coordinates at minX/minY corner
	vec3 P = (vec3){static_cast<float>(bboxmin.x), static_cast<float>(bboxmin.y),0};
	vec3 row = barycentric(pts, P);
	vec3 A = sub3(barycentric(pts, (vec3){P.x+1,P.y,P.z}),row);
	vec3 B = sub3(barycentric(pts, (vec3){P.x,P.y+1,P.z}),row);
	
	for (P.y=bboxmin.y; P.y<=bboxmax.y; P.y++) {
		vec3 w = row;
		for (P.x=bboxmin.x; P.x<=bboxmax.x; P.x++) {
			
			//vec3 bc_screen  = barycentric(pts, P);
			if ((w.x>0&&w.y>0&&w.z>0)){
				float z=0;
				vec3 ptsvec = (vec3){pts[0].z,pts[1].z,pts[2].z};
				z = dot3(ptsvec, w);
				if(zbuffer[(int)(P.y*WIDTH+P.x)]<z){
					vec2 uv = add2(add2(mul2(w.x,uvs[0]),mul2(w.y, uvs[1])),mul2(w.z, uvs[2]));
					vec3 normal = add3(add3(mul3(w.x,normals[0]),mul3(w.y, normals[1])),mul3(w.z, normals[2]));
					vec3 position = add3(add3(mul3(w.x,pos[0]),mul3(w.y, pos[1])),mul3(w.z, pos[2]));
					set_pixel(P.x, P.y,colorToInt(shade(uv, normal,position)));
					
					zbuffer[(int)(P.y*WIDTH+P.x)] = z;
				}
			}
			w = add3(w,A);
		}
		row = add3(row,B);
	}
	
}
void randpos(vec2i* ptr){
	
	ptr[0] = (vec2i){rand()%640,rand()%480};
	ptr[1] = (vec2i){rand()%640,rand()%480};
	ptr[2] = (vec2i){rand()%640,rand()%480};
}
vec3 to_screen(vec3 v){
	//return (vec3){v.x*(WIDTH/2) +(WIDTH/2), v.y*(HEIGHT/2) +(HEIGHT/2),v.z};
	return (vec3){v.x*(WIDTH/2) +(WIDTH/2), v.y*(HEIGHT/2) +(HEIGHT/2),v.z};
}
-(BOOL)points:(vec3*)points inBox:(CGRect)rect{
	for(int i=0;i<3;i++){
		vec3 point =  points[i];
		if(point.x>=rect.origin.x && point.x<=rect.origin.x+rect.size.width){
			if(point.y>=rect.origin.y && point.y<=rect.origin.y+rect.size.height){
				return YES;
			}
		}
	}
	return NO;
}
-(void)renderFaces:(NSArray<Face*>*) array model:(Model*)model matrix:(GLKMatrix4)mat box:(CGRect) rect{
	vec3 toCamera = sub3(center, camera);
	for (Face *face in array) {
		
		
		vec3 screen_coords[3];
		vec3 world_coords[3];
		vec2 texture_coords[3];
		vec3 normals[3];
		world_coords[0] = [[model.vertices objectAtIndex:face.v1] toVec];
		world_coords[1] = [[model.vertices objectAtIndex:face.v2] toVec];
		world_coords[2] = [[model.vertices objectAtIndex:face.v3] toVec];
		texture_coords[0] = [[model.uvs objectAtIndex:face.uv1] toVec];
		texture_coords[1] = [[model.uvs objectAtIndex:face.uv2] toVec];
		texture_coords[2] = [[model.uvs objectAtIndex:face.uv3] toVec];
		normals[0] = [[model.normals objectAtIndex:face.n1] toVec];
		normals[1] = [[model.normals objectAtIndex:face.n2] toVec];
		normals[2] = [[model.normals objectAtIndex:face.n3] toVec];
		vec3 n = cross3(sub3(world_coords[1], world_coords[0]), sub3(world_coords[2], world_coords[0]));
		if(dot3(n , toCamera)>0)continue;
		for(int i=0;i<3;i++){
			//vec4 proj_coords = vecmul((vec4){world_coords[i].x,world_coords[i].y,world_coords[i].z,1}, result.m);
			
			GLKVector4 proj = GLKMatrix4MultiplyVector4(mat, GLKVector4Make(world_coords[i].x,world_coords[i].y,world_coords[i].z,1));
			
			screen_coords[i] = wdiv((vec4){proj.x, proj.y, proj.z, proj.w});
			screen_coords[i] = to_screen(screen_coords[i]);
			screen_coords[i].y = HEIGHT-screen_coords[i].y;
		}
		
		
		
		
		triangle(screen_coords,texture_coords,normals, world_coords,rect);
	}
	
}
-(void) render{
	
	vec3 toCamera = sub3(center, camera);
	
	GLKMatrix4 Projection = GLKMatrix4Identity;
	Projection.m32 = 1.f/(normal3(sub3(camera, (vec3){0,0,0}))).z;
	
	GLKMatrix4 viewMatrix = GLKMatrix4MakePerspective(70 * (M_PI/180), WIDTH/HEIGHT, -0.1, -100);
	GLKMatrix4 camearaMatrix = GLKMatrix4MakeLookAt(camera.x, camera.y, camera.z, center.x, center.y, center.z, 0, 1, 0);
	NSMutableArray<Face*>* bin1 = [NSMutableArray new];
	NSMutableArray<Face*>* bin2 = [NSMutableArray new];
	NSMutableArray<Face*>* bin3 = [NSMutableArray new];
	NSMutableArray<Face*>* bin4 = [NSMutableArray new];
	CGRect box1 = CGRectMake(0, 0, WIDTH/2, HEIGHT/2);
	CGRect box2 = CGRectMake(WIDTH/2, 0, WIDTH/2, HEIGHT/2);
	CGRect box3 = CGRectMake(0, HEIGHT/2, WIDTH/2, HEIGHT/2);
	CGRect box4 = CGRectMake(WIDTH/2, HEIGHT/2, WIDTH/2, HEIGHT/2);
	for(Model* model in models){
		GLKMatrix4 result = GLKMatrix4Identity;
		result = GLKMatrix4Multiply(result, [model getModelMatrix]);
		result = GLKMatrix4Multiply(result, viewMatrix);
		result = GLKMatrix4Multiply(result, Projection);
		result = GLKMatrix4Multiply(result, camearaMatrix);
		
		
		vec3 screen_coords[3];
		vec3 world_coords[3];
		for(Face* face in model.faces){
			world_coords[0] = [[model.vertices objectAtIndex:face.v1] toVec];
			world_coords[1] = [[model.vertices objectAtIndex:face.v2] toVec];
			world_coords[2] = [[model.vertices objectAtIndex:face.v3] toVec];
			vec3 n = cross3(sub3(world_coords[1], world_coords[0]), sub3(world_coords[2], world_coords[0]));
			if(dot3(n , toCamera)>0)continue;
			for(int i=0;i<3;i++){
				GLKVector4 proj = GLKMatrix4MultiplyVector4(result, GLKVector4Make(world_coords[i].x,world_coords[i].y,world_coords[i].z,1));
				
				screen_coords[i] = wdiv((vec4){proj.x, proj.y, proj.z, proj.w});
				screen_coords[i] = to_screen(screen_coords[i]);
				screen_coords[i].y = HEIGHT-screen_coords[i].y;
				
			}
			if([self points:&screen_coords[0] inBox:box1])[bin1 addObject:face];
			if([self points:&screen_coords[0] inBox:box2])[bin2 addObject:face];
			if([self points:&screen_coords[0] inBox:box3])[bin3 addObject:face];
			if([self points:&screen_coords[0] inBox:box4])[bin4 addObject:face];
			
		}
		dispatch_group_t group = dispatch_group_create();
		dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self renderFaces:bin1 model:model matrix:result box:box1];
			 });
		dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self renderFaces:bin2 model:model matrix:result box:box2];
		});
		dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self renderFaces:bin3 model:model matrix:result box:box3];
		});
		dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self renderFaces:bin4 model:model matrix:result box:box4];
		});
		dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
		//model.rotation = (vec3){model.rotation.x+ 0.1/30, model.rotation.y +0.1/30, model.rotation.z};
	}
	
	//camera.z+=0.1/30;
	
}


@end
