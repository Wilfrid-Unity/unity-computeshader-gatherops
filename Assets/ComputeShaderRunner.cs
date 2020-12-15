using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;

public class ComputeShaderRunner : MonoBehaviour
{
    public ComputeShader computeShader;

    public Texture2D textureIn;
    public Texture2D dTextureIn;

    RenderTexture rwTextureOut;

    public RenderTexture textureOut;
    public GameObject cubeTexturedOut;

    // Start is called before the first frame update
    void Start()
    {
        var kernel = computeShader.FindKernel("CSMain");

        computeShader.SetTexture(kernel, "tex_in", textureIn);
        computeShader.SetTexture(kernel, "dtex_in", dTextureIn);

        rwTextureOut = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGB32);
        rwTextureOut.enableRandomWrite = true;
        rwTextureOut.Create();

        computeShader.SetTexture(kernel, "tex_out", rwTextureOut);

        computeShader.Dispatch(kernel, 64,  64, 1);

        // todo 
        // copy rwTextureOut to textureOut
        Graphics.CopyTexture(rwTextureOut, textureOut);

        //cubeTexturedOut.GetComponent<Renderer>().material.mainTexture = textureOut;

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
