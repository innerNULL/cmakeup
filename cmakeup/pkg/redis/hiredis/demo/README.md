# Introduction
Here is an simple example about how to use `hiredis_pkg.cmake`.

# Build
```
mkdir build && cd build
cmake ../
make
```

# Note
* 'redis/hiredis' is an c-lang lib, not directory for cpp, so when using cpp to call this lib, here are some lightly-tips:
    * Not `redisCommand(c,"PING")`, use `(redisReply*)redisCommand(c,"PING")`, ref to [stackoverflow](https://stackoverflow.com/questions/13144981/c-redis-hiredis-compiler-error).


