///|
/// Vulkan Pipeline FFI Function Declarations
/// Direct bindings to Vulkan C API for pipeline and shader management

pub extern "C" fn vkCreateShaderModule(device : Int, pCreateInfo : Int, pAllocator : Int, pShaderModule : Int) -> Int = "vkCreateShaderModule"
pub extern "C" fn vkDestroyShaderModule(device : Int, shaderModule : Int, pAllocator : Int) -> Unit = "vkDestroyShaderModule"
pub extern "C" fn vkCreatePipelineCache(device : Int, pCreateInfo : Int, pAllocator : Int, pPipelineCache : Int) -> Int = "vkCreatePipelineCache"
pub extern "C" fn vkDestroyPipelineCache(device : Int, pipelineCache : Int, pAllocator : Int) -> Unit = "vkDestroyPipelineCache"
pub extern "C" fn vkGetPipelineCacheData(device : Int, pipelineCache : Int, pDataSize : Int, pData : Int) -> Int = "vkGetPipelineCacheData"
pub extern "C" fn vkMergePipelineCaches(device : Int, destCache : Int, srcCacheCount : Int, pSrcCaches : Int) -> Int = "vkMergePipelineCaches"
pub extern "C" fn vkCreateGraphicsPipelines(device : Int, pipelineCache : Int, createInfoCount : Int, pCreateInfos : Int, pAllocator : Int, pPipelines : Int) -> Int = "vkCreateGraphicsPipelines"
pub extern "C" fn vkCreateComputePipelines(device : Int, pipelineCache : Int, createInfoCount : Int, pCreateInfos : Int, pAllocator : Int, pPipelines : Int) -> Int = "vkCreateComputePipelines"
pub extern "C" fn vkDestroyPipeline(device : Int, pipeline : Int, pAllocator : Int) -> Unit = "vkDestroyPipeline"
