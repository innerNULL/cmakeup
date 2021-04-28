/// file: example.cpp
/// date: 2021-04-28


#include <cstdlib>
#include <simdjson.h>


int main(int argc, char **argv) {
  system("rm -rf ./*.json && wget https://raw.githubusercontent.com/simdjson/simdjson/master/jsonexamples/twitter.json");

  simdjson::dom::parser parser;
  simdjson::dom::element tweets;
  auto error = parser.load("twitter.json").get(tweets);
  if(error) { std::cerr << error << std::endl; return EXIT_FAILURE; }

  uint64_t identifier;
  error = tweets["statuses"].at(0)["id"].get(identifier);
  if(error) { std::cerr << error << std::endl; return EXIT_FAILURE; }
  std::cout << identifier << std::endl;
  return EXIT_SUCCESS;
}
