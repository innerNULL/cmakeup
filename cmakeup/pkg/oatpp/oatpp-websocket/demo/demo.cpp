/// file: demo.cpp
/// date: 2021-04-16



#include "oatpp-websocket/WebSocket.hpp"
#include "oatpp-websocket/Connector.hpp"

#include "oatpp/network/tcp/client/ConnectionProvider.hpp"

#include <thread>

int main(int argc, char **argv) {
  //auto connectionProvider = oatpp::network::tcp::client::ConnectionProvider::createShared({"echo.websocket.org", 80});
  //const std::shared_ptr<oatpp::websocket::WebSocket> websocket;
  oatpp::base::Environment::init();
  return 0;
}
