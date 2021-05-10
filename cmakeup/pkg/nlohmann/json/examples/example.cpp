/// file: example.cpp
/// date: 2021-04-28


#include <iostream>
#include <nlohmann/json.hpp>


using json = nlohmann::json;


int main(int argc, char **argv) {
  std::cout << "create an empty structure (null)" << std::endl;
  nlohmann::json j;
  std::cout << j.dump(4) << std::endl;

  std::cout << "add a number that is stored as double" << std::endl;
  j["pi"] = 3.141;
  std::cout << j.dump(4) << std::endl;

  std::cout << "add a Boolean that is stored as bool" << std::endl;
  j["happy"] = true;
  std::cout << j.dump(4) << std::endl;

  std::cout << "add a string that is stored as std::string" << std::endl;
  j["name"] = "Niels";
  std::cout << j.dump(4) << std::endl;

  std::cout << "add another null object by passing nullptr" << std::endl;
  j["nothing"] = nullptr;
  std::cout << j.dump(4) << std::endl;

  std::cout << "add an object inside the object" << std::endl;
  j["answer"]["everything"] = 42;
  std::cout << j.dump(4) << std::endl;

  std::cout << "add an array that is stored as std::vector " << std::endl;
  j["list"] = { 1, 0, 2 };
  std::cout << j.dump(4) << std::endl;

  std::cout << "add another object" << std::endl;
  j["object"] = { {"currency", "USD"}, {"value", 42.99} };
  std::cout << j.dump(4) << std::endl;

  return 0;
}
