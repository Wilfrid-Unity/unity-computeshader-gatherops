Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        tex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag

            //// make fog work
            //#pragma multi_compile_fog

            //#include "UnityCG.cginc"

            //struct appdata
            //{
            //    float4 vertex : POSITION;
            //    float2 uv : TEXCOORD0;
            //};

            //struct v2f
            //{
            //    float2 uv : TEXCOORD0;
            //    UNITY_FOG_COORDS(1)
            //    float4 vertex : SV_POSITION;
            //};

            //sampler2D _MainTex;
            //float4 _MainTex_ST;

            //v2f vert (appdata v)
            //{
            //    v2f o;
            //    o.vertex = UnityObjectToClipPos(v.vertex);
            //    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            //    UNITY_TRANSFER_FOG(o,o.vertex);
            //    return o;
            //}

            //fixed4 frag (v2f i) : SV_Target
            //{
            //    // sample the texture
            //    fixed4 col = tex2D(_MainTex, i.uv);
            //    // apply fog
            //    UNITY_APPLY_FOG(i.fogCoord, col);
            //    return col;
            //}

            //#include "UnityCG.cginc"
            #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)

            Texture2D tex;
            SamplerState samplertex;

            float4 tex_ST;

            Texture2D dtex;
            SamplerComparisonState samplerdtex;

            struct appdata 
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
              
            v2f vert(appdata v)
            {
                v2f o;
                //o.pos = v.vertex;
                //o.uv = v.texcoord;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, tex);
                return o;
            }

            half4 frag(v2f i) : SV_Target0
            {
                int2 offset = int2(i.uv);
                float4 r = tex.Gather(samplertex, i.uv);
                float4 roff = tex.Gather(samplertex, i.uv, int2(2,3));
                float4 g = tex.GatherGreen(samplertex, i.uv);
                float4 boff = tex.GatherBlue(samplertex, i.uv, offset);
                float4 a = tex.GatherAlpha(samplertex, i.uv);
                float4 rcmp = dtex.GatherCmp(samplerdtex, i.uv, 1.0);
                float4 rcmpoff = dtex.GatherCmpRed(samplerdtex, i.uv, i.uv.x, int2(4,5));
                float col = (r + roff + g + boff + a + rcmp + rcmpoff) / 7.0;
                return float4(col, col, col, 1.0); 
            }

            ENDCG
        }
    }
}
