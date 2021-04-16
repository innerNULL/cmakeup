/// file: demo.cpp
/// date: 2021-04-16


#include "oatpp/web/client/HttpRequestExecutor.hpp"
#include "oatpp/network/tcp/client/ConnectionProvider.hpp"

#include "oatpp/parser/json/mapping/ObjectMapper.hpp"


int main(int argc, char **argv) {
  oatpp::base::Environment::init();

  auto objectMapper = oatpp::parser::json::mapping::ObjectMapper::createShared();
  auto connectionProvider = oatpp::network::tcp::client::ConnectionProvider::createShared({"httpbin.org", 80});
  auto requestExecutor = oatpp::web::client::HttpRequestExecutor::createShared(connectionProvider);

  oatpp::base::Environment::destroy();
  return 0;
}
