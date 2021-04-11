/// file: demo.cpp
/// date: 2021-03-12


#include <cstdlib>
#include <hiredis.h>


int main(int argc, char **argv) {
  redisContext *c;
  redisReply *reply;

  const char *hostname = (argc > 1) ? argv[1] : "127.0.0.1";
  int port = 6379; 

  struct timeval timeout = { 1, 500000 }; // 1.5 seconds

  c = redisConnectWithTimeout(hostname, port, timeout);

  if (c == NULL || c->err) {
    if (c) {
      printf("Connection error: %s\n", c->errstr);
      redisFree(c);
    } else {
      printf("Connection error: can't allocate redis context\n");
    }
    exit(1);
  }

  reply = (redisReply*)redisCommand(c,"PING");
  printf("PING: %s\n", reply->str);
  freeReplyObject(reply);

  return 0;
}
