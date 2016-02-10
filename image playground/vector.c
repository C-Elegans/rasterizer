//
//  vector.c
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#include "vector.h"
#include <math.h>
#include <string.h>
float cross2(vec2 a, vec2 b){
	return (a.x*b.y)-(a.y*b.x);
}
vec2 add2(vec2 a, vec2 b){
	return (vec2){a.x+b.x,a.y+b.y};
}
vec2 sub2(vec2 a, vec2 b){
	return (vec2){a.x-b.x,a.y-b.y};
}
float dot2(vec2 a,vec2 b){
	return a.x*b.x+a.y*b.y;
}
int icross2(vec2i a, vec2i b){
	return (int)((float)a.x*(float)b.y)-((float)a.y*(float)b.x);
}
vec2i iadd2(vec2i a, vec2i b){
	return (vec2i){a.x+b.x,a.y+b.y};
}
vec2i isub2(vec2i a, vec2i b){
	return (vec2i){a.x-b.x,a.y-b.y};
}
int idot2(vec2i a,vec2i b){
	return (int)((float)a.x*(float)b.x+(float)a.y*(float)b.y);
}
vec3 cross3(vec3 a, vec3 b){
	vec3 ret;
	ret.x = a.y*b.z-a.z*b.y;
	ret.y = -(a.x*b.z-a.z*b.x);
	ret.z = a.x*b.y-a.y*b.x;
	
	return ret;
	
}
vec3 sub3(vec3 a, vec3 b){
	return (vec3){a.x-b.x,a.y-b.y,a.z-b.z};
}
vec3 normal3(vec3 v){
	float div = sqrtf(v.x*v.x+v.y*v.y+v.z*v.z);
	return (vec3){v.x/div,v.y/div,v.z/div};
}
float dot3(vec3 a, vec3 b){
	return a.x*b.x+a.y*b.y+a.z*b.z;
}
float* matmul(float* a, float* b, float* result){
	memset(result,0,4*4*sizeof(float));
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			for(int k=0;k<4;k++){
				result[i*4+j] += a[i*4+k] * b[k*4+j] ;
			}
		}
	}
	
	return result;
}
vec4 vecmul(vec4 a, float* b){
	float* ptr = (float* )&a;
	float res[4];
	for(int i=0;i<4;i++){
		float sum = 0;
		for(int j=0;j<4;j++){
			sum += ptr[i] * b[i*4+j];
		}
		res[i] = sum;
		
	}
	return (vec4){res[0],res[1],res[2],res[3]};
}
float* viewport(int x, int y, int w, int h, float* m) {
	for(int i=0;i<4;i++){
		m[i*4+i]=1;
	}
	m[0*4+3] = x+w/2.f;
	m[1*4+3] = y+h/2.f;
	m[2*4+3] = DEPTH/2.f;
	
	m[0*4+0] = w/2.f;
	m[1*4+1] = h/2.f;
	m[2*4+2] = DEPTH/2.f;
	return m;
}
void mat_identity(float* mat){
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			mat[j*4+i] = j==i? 1 : 0;
		}
	}
}
void lookat(vec3 eye, vec3 center, vec3 up, float* camera) {
	vec3 z = normal3(sub3(eye, center));
	vec3 x = normal3(cross3(up,z));
	vec3 y = normal3(cross3(z,x));
	float Minv[4][4];
	float Tr[4][4];
	mat_identity(Minv);
	mat_identity(Tr);

	Minv[0][0] = x.x;
	Minv[1][0] = y.x;
	Minv[2][0] = z.x;
	Tr[0][3] = -center.x;
	Minv[0][1] = x.y;
	Minv[1][1] = y.y;
	Minv[2][1] = z.y;
	Tr[1][3] = -center.y;
	Minv[0][2] = x.z;
	Minv[1][2] = y.z;
	Minv[2][2] = z.z;
	Tr[2][3] = -center.z;
	matmul(Minv, Tr, camera);
}
vec3 wdiv(vec4 v){
	if(v.w != 0)
	return (vec3){v.x/v.w,v.y/v.w,v.z/v.w};
	return (vec3){v.x,v.y,v.z};
}
vec3 add3(vec3 a, vec3 b){
	return (vec3){a.x+b.x, a.y+b.y, a.z+b.z};
}
