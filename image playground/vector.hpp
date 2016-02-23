//
//  vector.h
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#ifndef vector_h
#define vector_h
#include <stdint.h>
#define DEPTH 255
typedef struct{
	float x;
	float y;
	float z;
}vec3;
typedef struct{
	float x;
	float y;
}vec2;
typedef struct{
	int x;
	int y;
}vec2i;
typedef struct{
	int x;
	int y;
	int z;
}vec3i;
typedef struct{
	float x;
	float y;
	float z;
	float w;
}vec4;
typedef struct{
	uint8_t b;
	uint8_t g;
	uint8_t r;
	uint8_t a;
}color;
uint8_t sadd8(uint8_t a, uint8_t b);
float cross2(vec2 a, vec2 b);
vec2 add2(vec2 a, vec2 b);
vec2 sub2(vec2 a, vec2 b);
float dot2(vec2 a,vec2 b);
int icross2(vec2i a, vec2i b);
vec2i iadd2(vec2i a, vec2i b);
vec2i isub2(vec2i a, vec2i b);
int idot2(vec2i a,vec2i b);
vec3 cross3(vec3 a, vec3 b);
vec3 sub3(vec3 a, vec3 b);
vec3 normal3(vec3);
float dot3(vec3,vec3);
void mat_identity(float* mat);
float* matmul(float* a, float* b, float* result);
vec4 vecmul(vec4, float*);
float* viewport(int x, int y, int w, int h, float* m);
void lookat(vec3 eye, vec3 center, vec3 up, float* camera);
vec3 wdiv(vec4);
vec3 add3(vec3, vec3);
vec3 mul3(float, vec3);
vec2 mul2(float, vec2);
color mulColor(float, color);
int colorToInt(color c);
color addColor(color a, color b);
#endif /* vector_h */
