#version 330


layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;


uniform mat4 uModelMat, uViewMat, uProjMat;
uniform float uTime;

out vec2 vTexCoord;
out vec3 normal;
out vec4 position;
out float time;

void main() {
	mat4 modelViewProjMat = uProjMat * uViewMat * uModelMat;
	gl_Position = modelViewProjMat * aPosition;
	vTexCoord = aTexCoord;
	normal = aNormal;
	position = aPosition;
	time = uTime;
}