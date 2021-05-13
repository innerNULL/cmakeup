/// file: https_server_example.cpp
/// date: 2021-05-13


#define CPPHTTPLIB_OPENSSL_SUPPORT

#include <iostream>
#include <httplib.h>


int main(int argc, char **argv) {
  httplib::SSLClient cli("localhost", 8080);
  return 0;
}
