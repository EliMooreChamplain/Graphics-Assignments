#version 330


layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;


uniform mat4 uModelMat, uViewMat, uProjMat;
uniform float uTime;

out vec2 vTexCoord;
out vec3 vNormal;
out vec4 vPosition;
out float vTime;
out float vVertexDiffuse;
out float vVertexSpecular;

const float pi = 3.141592;

struct sPL
{
	vec4 center;
	vec4 color;
	float intensity;
};
out sPL pl;

mat3 rotationZ(float rads)
{
	mat3 rotation = mat3(
		1, 0, 0,
		0, cos(rads),-1.0 * sin(rads),
		0, sin(rads),cos(rads)
	);
	return rotation;
}

mat3 rotationY(float rads)
{
	return mat3(
		cos(rads), 0, sin(rads),
		0,1,0,
		-1.0 * sin(rads),0,cos(rads)
	);
}
void calcDiffuseIntensity()
{
	vec3 lightVector = normalize(pl.center.xyz);
	float diffuseCoefficient = max(0.0,dot(aNormal,lightVector));
	
	float slDist = distance(pl.center.xyz,aPosition.xyz);
	
	//Distance over intensity
    float dOi = (slDist/pl.intensity);
    
    float attenuatedIntensity = 1.0/(1.0 + dOi + (dOi * dOi));
    
    vVertexDiffuse = diffuseCoefficient * attenuatedIntensity;
}

void calcSpecIntensity(float specular)
{
	vec3 lightVector = normalize(pl.center.xyz);
    
    float specIntensity;   //Specular Intensity
    float specCo;          //Specular Coefficient
    vec3 viewVec;          //View Vector
    vec3 halfVec;          //Halfway Vector
    
    viewVec = vNormal;
        
    halfVec = normalize(lightVector + viewVec);
        
    specCo = max(0.0,dot(vNormal,halfVec));
    
    vVertexSpecular = pow(specCo, specular * 4.0);
}

void main() {
	mat4 rot = mat4(rotationY(uTime * 0.25)) * mat4(rotationZ(pi * 0.5));
	mat4 modelView = uViewMat * uModelMat * rot;
	vPosition = modelView * aPosition;
	gl_Position = uProjMat * vPosition;
	vTexCoord = aTexCoord;
	mat3 matNormal = inverse(transpose(mat3(modelView)));
	vNormal = matNormal * aNormal;
	
	vTime = uTime;
	
	pl.center = uViewMat * vec4(0,1,-1,1);
	pl.color = vec4(1,1,1,1);
	pl.intensity = 100.0;
}