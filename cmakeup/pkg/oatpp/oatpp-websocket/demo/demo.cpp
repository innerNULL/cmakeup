/// file: demo.cpp
/// date: 2021-04-16



#include "oatpp-websocket/WebSocket.hpp"
#include "oatpp-websocket/Connector.hpp"

#include "oatpp/network/tcp/client/ConnectionProvider.hpp"

#include <thread>


void run() {
  auto connectionProvider = oatpp::network::tcp::client::ConnectionProvider::createShared({"echo.websocket.org", 80});
  auto connector = oatpp::websocket::Connector::createShared(connectionProvider);
  auto connection = connector->connect("/");
  auto socket = oatpp::websocket::WebSocket::createShared(connection, true /* maskOutgoingMessages must be true for clients */);
}


int main(int argc, char **argv) {
  oatpp::base::Environment::init();
  run();
  oatpp::base::Environment::destroy();
  return 0;
}
