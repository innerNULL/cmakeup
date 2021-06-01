/// file: example.cpp
/// date: 2021-04-28


#include <iostream>
#include <Eigen/Dense>


int main(int argc, char **argv) {
  Eigen::MatrixXd m = Eigen::MatrixXd::Random(3,3);
  m = (m + Eigen::MatrixXd::Constant(3,3,1.2)) * 50;
  std::cout << "m =" << std::endl << m << std::endl;
  Eigen::VectorXd v(3);
  v << 1, 2, 3;
  std::cout << "m * v =" << std::endl << m * v << std::endl;

  return 0;
}
