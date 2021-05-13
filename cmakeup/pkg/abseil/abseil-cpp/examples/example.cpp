/// file: example.cpp
/// date: 2021-05-11


#include <iostream>
#include <absl/strings/match.h>


int main(int argc, char **argv) {
  std::string msg = "hello world";
  if (absl::StrContains(msg, "hello")) {
    std::cout << "msg contains hello" << std::endl;
  }
  return 0;
}
