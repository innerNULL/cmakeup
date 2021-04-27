/// file: ws_client_demo.cpp
/// date: 2021-04-23
///
/// This demo is ref to https://www.boost.org/doc/libs/1_70_0/libs/beast/doc/html/beast/quick_start/websocket_client.html

#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/asio.hpp>
#include <boost/asio/ssl.hpp>
#include <cstdlib>
#include <iostream>
#include <string>


namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace websocket = beast::websocket; // from <boost/beast/websocket.hpp>
namespace net = boost::asio;            // from <boost/asio.hpp>
namespace ssl = boost::asio::ssl;       // from <boost/asio/ssl.hpp>
using tcp = boost::asio::ip::tcp;       // from <boost/asio/ip/tcp.hpp>


int main(int argc, char** argv) {
  try {
    char* host;
    char* port;
    char* text;

    if (argc != 4) {
      host = "echo.websocket.org";
      port = "80";
      text = "hello world";
    } else {
      host = argv[1];
      port = argv[2];
      text = argv[3];
    }

    // The io_context is required for all I/O
    net::io_context ioc;

    // The SSL context is required, and holds certificates
    ssl::context ctx{ssl::context::tlsv12_client};

    // This holds the root certificate used for verification
    //load_root_certificates(ctx);

  } catch(std::exception const& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return EXIT_FAILURE;
  }
  
  return EXIT_SUCCESS;
}
