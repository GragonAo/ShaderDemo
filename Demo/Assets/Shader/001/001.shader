Shader "Unlit/001"
{   
    //属性块
    Properties
    {
        _Int("Int",Int) = 10
        // _Range("Range",range) = (0,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        //标签 可选 key = value
        Tags { 
            "RenderType"="Opaque"   //着色器替换功能
            "Queue"="Transparent"   //渲染顺序
            "DisableBatching" = "True" //是否进行合批
            "ForceNoShadowCasting" = "True" //是否投射阴影
            "IgnoreProjector" = "True" //受不受Projector的影响，通常用于透明物体
            "CanUseSpriteAltas" = "False" //是否用于图片的Shader，通常用于UI
            "PreviewType" = "Plane" //作用shader面板预览的类型

        }
        //Render设置 可选
        //Cull off/back/front //选择渲染那个面
        //ZTest Always/Less Greater/LEqual/GEqual/Equal/NotEqual //深度测试
        //Zwrite off/on //深度写入
        //Blend SrcFactor DstFactor //混合
        //LOD 100 //不同情况下的使用不同的LOD，达到性能提升

        Pass
        {
            //Name "Default" //Pass通道名称
            Tags{
                "LightMode"="ForwardBase" //定义该Pass通道在Unity渲染流水中的角色，“ForwardBase”为前向渲染
                // "RequireOptions"="SoftVegetation" //满足某些条件时才渲染该Pass通道
            }//可以在每个Pass通道里面进行定义，外面Tags会被优先处理，若有相同的只会以外部定义的为准

            //CG语言所写的代码，主要是顶点片元着色器
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
