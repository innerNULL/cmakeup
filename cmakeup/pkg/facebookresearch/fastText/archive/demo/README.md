# Introduction
Here is an simple example about how to use `fastText_pkg.cmake`.

# Build
```
mkdir build && cd build
cmake ../
make -j4
```

# Note
* Have to open `pthread` compiling flag, such as `set(CMAKE_CXX_FLAGS " -pthread -std=c++17 -funroll-loops -O3 -march=native")`.
