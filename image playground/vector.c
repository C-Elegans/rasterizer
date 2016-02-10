//
//  vector.c
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#include "vector.h"
#include <math.h>
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
