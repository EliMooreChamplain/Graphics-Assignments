#version 330


layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;


uniform mat4 uModelMat, uViewMat, uProjMat;
uniform float uTime;

out vec2 vTexCoord;
out vec3 vNormal;
out vec4 position;
out float time;
out float vVertexDiffuse;

struct sPL
{
	vec4 center;
	vec4 color;
	float intensity;
};

out sPL pl;

void calcDiffuseIntensity(sPL pl)
{
	vec3 lightVector = normalize(pl.center.xyz);
	float diffuseCoefficient = max(0.0,dot(aNormal,lightVector));
	
	float slDist = distance(pl.center.xyz,aPosition.xyz);
	
	//Distance over intensity
    float dOi = (slDist/pl.intensity);
    
    float attenuatedIntensity = 1.0/(1.0 + dOi + (dOi * dOi));
    
    vVertexDiffuse = diffuseCoefficient * attenuatedIntensity;
}

void main() {
	mat4 modelViewProjMat = uProjMat * uViewMat * uModelMat;
	gl_Position = modelViewProjMat * aPosition;
	vTexCoord = aTexCoord;
	vNormal = aNormal;
	position = aPosition;
	time = uTime;
	
	pl.center = vec4(5,5,5,1);
	pl.color = vec4(1,1,1,1);
	pl.intensity = 100.0;
	calcDiffuseIntensity(pl);
}