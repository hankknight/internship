project(example)

add_executable(workflow workflow.cpp)
target_link_libraries(workflow PRIVATE ${Sampler_LIBRARIES} ${TORCH_LIBRARIES})
set_property(TARGET workflow PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
