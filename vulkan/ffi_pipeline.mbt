///|
/// Vulkan Pipeline FFI Function Declarations
/// Direct bindings to Vulkan C API for pipeline and shader management

pub extern "C" fn vkCreateShaderModule(device : Int64, pCreateInfo : Int, pAllocator : Int, pShaderModule : Int) -> Int = "vkCreateShaderModule"
pub extern "C" fn vkDestroyShaderModule(device : Int64, shaderModule : Int64, pAllocator : Int) -> Unit = "vkDestroyShaderModule"
pub extern "C" fn vkCreatePipelineCache(device : Int64, pCreateInfo : Int, pAllocator : Int, pPipelineCache : Int) -> Int = "vkCreatePipelineCache"
pub extern "C" fn vkDestroyPipelineCache(device : Int64, pipelineCache : Int64, pAllocator : Int) -> Unit = "vkDestroyPipelineCache"
pub extern "C" fn vkGetPipelineCacheData(device : Int64, pipelineCache : Int64, pDataSize : Int, pData : Int) -> Int = "vkGetPipelineCacheData"
pub extern "C" fn vkMergePipelineCaches(device : Int64, destCache : Int64, srcCacheCount : Int, pSrcCaches : Int) -> Int = "vkMergePipelineCaches"
pub extern "C" fn vkCreateGraphicsPipelines(device : Int64, pipelineCache : Int64, createInfoCount : Int, pCreateInfos : Int, pAllocator : Int, pPipelines : Int) -> Int = "vkCreateGraphicsPipelines"
pub extern "C" fn vkCreateComputePipelines(device : Int64, pipelineCache : Int64, createInfoCount : Int, pCreateInfos : Int, pAllocator : Int, pPipelines : Int) -> Int = "vkCreateComputePipelines"
pub extern "C" fn vkDestroyPipeline(device : Int64, pipeline : Int64, pAllocator : Int) -> Unit = "vkDestroyPipeline"
