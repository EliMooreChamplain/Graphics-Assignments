#version 330

struct sPL
{
	vec4 center;
	vec4 color;
	float intensity;
};

in vec2 vTexCoord;
in vec3 vNormal;
in vec4 vPosition;
in float vTime;
in float vVertexDiffuse;
in float vVertexSpecular;
in sPL pl;



uniform sampler2D uTex;
uniform sampler2D uSpecularMask;
uniform sampler2D uLightMask;

layout (location = 0) out vec4 rtFragColor;

const float pi = 3.141592;

float fragDiffuseIntensity(in vec3 normal)
{
	vec3 lightVector = normalize(pl.center.xyz - vPosition.xyz);
	float diffuseCoefficient = max(0.0,dot(normal,lightVector));
	
	float slDist = distance(pl.center.xyz,vPosition.xyz);
	
	//Distance over intensity
    float dOi = (slDist/pl.intensity);
    
    float attenuatedIntensity = 1.0/(1.0 + dOi + (dOi * dOi));
    
    return diffuseCoefficient * attenuatedIntensity;
}

float fragSpecIntensity(in float specular, in vec3 normal)
{
	vec3 lightVector = normalize(pl.center.xyz - vPosition.xyz);
	
    
    float specIntensity;   //Specular Intensity
    float specCo;          //Specular Coefficient
    vec3 viewVec;          //View Vector
    vec3 halfVec;          //Halfway Vector
    
    viewVec = normalize(-vPosition.xyz);
        
    halfVec = normalize(lightVector + viewVec);
        
    specCo = max(0.0,dot(normal,halfVec));
    
    return pow(specCo, specular * 4.0);
}

void main() {
	float twoPi = 2.0 * pi;
	vec3 normal = normalize(vNormal);
	vec2 offset = vec2(0.0,0.0);//vec2(time * 0.125,0);
	
	float specular = 16.0;
	float specularMask = 1.0 - texture(uSpecularMask, vTexCoord + offset).x;
	
	float nightLightIntensity = 0.75;
	vec4 nightLightColor = vec4(0.949, 0.756, 0.109, 1.0);
	vec4 lightMask = texture(uLightMask, vTexCoord + offset).x * nightLightColor * nightLightIntensity;
	
	//sPL pl;
	//pl.center = vec4(normalize(vec3(5,5,5)) * 2.0,1);
	//pl.color = vec4(1,1,1,1);
	//pl.intensity = 100.0;
	
	float diffuseIntensity = fragDiffuseIntensity(normal.xyz);//vVertexIntensity;
	
	float specIntensity = fragSpecIntensity(specular, normal.xyz);
	
	vec4 color = texture(uTex, vTexCoord + offset);//vec4(normal,1);
	
	vec4 globalAmbientColor = color;
	float globalAmbientIntensity = 0.05;
	
	vec4 finalColor = 
        globalAmbientColor * globalAmbientIntensity +
        (
            (diffuseIntensity * color) + 
            (specIntensity * specularMask) 
        ) * pl.color + 
        max(0.0,0.5 - diffuseIntensity * 2.0) * lightMask * 2.0;
    
    
	rtFragColor = finalColor;//vec4(normal,1);//vec4(1,1,1,1) * vTexCoord.y;//texture(uTex, vTexCoord);
}