## Example
```
enable_testing()

add_executable(tests test.cpp)
target_link_libraries(tests PRIVATE ${googletest})

add_test(CILL_TEST test)
```
