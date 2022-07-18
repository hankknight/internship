project(sampler-core)

add_library(sampler_shared SHARED "src/sequential.cpp")
target_include_directories(sampler_shared PUBLIC "include/")
target_link_libraries(sampler_shared PUBLIC ${TORCH_LIBRARIES})

set(Sampler_INCLUDE_DIRS "include/" CACHE INTERNAL "sampler include headers.")
set(Sampler_LIBRARIES sampler_shared CACHE INTERNAL "sampler shared libraries.")
