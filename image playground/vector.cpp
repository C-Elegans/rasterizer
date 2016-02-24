//
//  vector.c
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#include "vector.hpp"
#include <math.h>
#include <string.h>

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
	mat_identity(&Minv[0][0]);
	mat_identity(&Tr[0][0]);

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
	matmul(&Minv[0][0], &Tr[0][0], camera);
}
