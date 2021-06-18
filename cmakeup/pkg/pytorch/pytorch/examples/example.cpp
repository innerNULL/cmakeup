/// file: example.cpp
/// date: 2021-06-17


#include <torch/torch.h>
#include <iostream>


int main() {
  torch::Tensor tensor = torch::eye(3);
  std::cout << tensor << std::endl;
}
