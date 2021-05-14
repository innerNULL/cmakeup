/// file: example.cpp
/// date: 2021-05-14


#include <iostream>
#include <cpr/cpr.h>

auto example_v1() -> cpr::Response { 
  cpr::Response r = cpr::Get(
      cpr::Url{"https://api.github.com/repos/whoshuu/cpr/contributors"}, 
      cpr::Authentication{"user", "pass"},
      cpr::Parameters{{"anon", "true"}, {"key", "value"}}, 
      cpr::VerifySsl{false});
  return r;
}


auto example_v0() -> cpr::Response {
  cpr::Session session;
  auto url = cpr::Url{"https://www.httpbin.org/get"};
  session.SetUrl(url);
  session.SetVerifySsl(false);

  auto r = session.Get();
  return r;
}


auto print_response(cpr::Response& r) -> void {
  std::cout << "url: " << r.url << std::endl;
  std::cout << "status_code: " << r.status_code << std::endl;  
  std::cout << "header, content-type: " << r.header["content-type"] << std::endl;
  std::cout << "text: " << r.text << std::endl; 
  std::cout << "error message: " << r.error.message << std::endl;
}



int main(int argc, char** argv) {
  cpr::Response r;

  r = example_v0();
  print_response(r);

  r = example_v1();  
  print_response(r);
}
