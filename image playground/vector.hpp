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
#include <math.h>
#include <string.h>
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

inline vec2 add2(vec2 a, vec2 b){
	return (vec2){a.x+b.x,a.y+b.y};
}
inline vec2 sub2(vec2 a, vec2 b){
	return (vec2){a.x-b.x,a.y-b.y};
}
inline float dot2(vec2 a,vec2 b){
	return a.x*b.x+a.y*b.y;
}
inline int icross2(vec2i a, vec2i b){
	return (int)((float)a.x*(float)b.y)-((float)a.y*(float)b.x);
}
inline vec2i iadd2(vec2i a, vec2i b){
	return (vec2i){a.x+b.x,a.y+b.y};
}
inline vec2i isub2(vec2i a, vec2i b){
	return (vec2i){a.x-b.x,a.y-b.y};
}
inline int idot2(vec2i a,vec2i b){
	return (int)((float)a.x*(float)b.x+(float)a.y*(float)b.y);
}
inline vec3 cross3(vec3 a, vec3 b){
	vec3 ret;
	ret.x = a.y*b.z-a.z*b.y;
	ret.y = -(a.x*b.z-a.z*b.x);
	ret.z = a.x*b.y-a.y*b.x;
	
	return ret;
	
}
inline vec3 sub3(vec3 a, vec3 b){
	return (vec3){a.x-b.x,a.y-b.y,a.z-b.z};
}
inline vec3 normal3(vec3 v){
	float div = sqrtf(v.x*v.x+v.y*v.y+v.z*v.z);
	return (vec3){v.x/div,v.y/div,v.z/div};
}
inline float dot3(vec3 a, vec3 b){
	return a.x*b.x+a.y*b.y+a.z*b.z;
}
inline float cross2(vec2 a, vec2 b){
	return (a.x*b.y)-(a.y*b.x);
}
void mat_identity(float* mat);
float* matmul(float* a, float* b, float* result);
vec4 vecmul(vec4, float*);
float* viewport(int x, int y, int w, int h, float* m);
void lookat(vec3 eye, vec3 center, vec3 up, float* camera);
inline vec3 wdiv(vec4 v){
	if(v.w != 0)
		return (vec3){v.x/v.w,v.y/v.w,v.z/v.w};
	return (vec3){v.x,v.y,v.z};
}
inline vec3 add3(vec3 a, vec3 b){
	return (vec3){a.x+b.x, a.y+b.y, a.z+b.z};
}
inline vec3 mul3(float a, vec3 b){
	return (vec3){a*b.x,a*b.y, a*b.z};
}
inline vec2 mul2(float a, vec2 b){
	return (vec2){a*b.x,a*b.y};
}
inline color mulColor(float a, color c){
	return (color){(uint8_t)(c.r * a),(uint8_t)(c.g * a),(uint8_t)(c.b * a),c.a,};
}
inline int colorToInt(color c){
	return c.r<<24|c.g<<16|c.b<<8|c.a;
}
inline uint8_t sadd8(uint8_t a, uint8_t b)
{ return (a > 0xFF - b) ? 0xFF : a + b; }
inline color addColor(color a, color b){
	return (color){sadd8(a.b, b.b),sadd8(a.g, b.g),sadd8(a.r, b.r),sadd8(a.a, b.a)};
}

#endif /* vector_h */
