//
//  vector.h
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#ifndef vector_h
#define vector_h

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
float cross2(vec2 a, vec2 b);
vec2 add2(vec2 a, vec2 b);
vec2 sub2(vec2 a, vec2 b);
float dot2(vec2 a,vec2 b);
int icross2(vec2i a, vec2i b);
vec2i iadd2(vec2i a, vec2i b);
vec2i isub2(vec2i a, vec2i b);
int idot2(vec2i a,vec2i b);
vec3 cross3(vec3 a, vec3 b);
#endif /* vector_h */
