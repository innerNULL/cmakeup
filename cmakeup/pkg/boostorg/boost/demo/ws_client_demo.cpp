/// file: ws_client_demo.cpp
/// date: 2021-04-23
///
/// This demo is ref to https://www.boost.org/doc/libs/1_70_0/libs/beast/doc/html/beast/quick_start/websocket_client.html

#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
//#include <boost/asio.hpp>
//#include <boost/asio/ssl.hpp>
#include <cstdlib>
#include <iostream>
#include <string>


namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace websocket = beast::websocket; // from <boost/beast/websocket.hpp>
namespace net = boost::asio;            // from <boost/asio.hpp>

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

    // These objects perform our I/O
    tcp::resolver resolver{ioc};
    websocket::stream<tcp::socket> ws{ioc};

    // Look up the domain name
    auto const results = resolver.resolve(host, port);

    // Make the connection on the IP address we get from a lookup
    net::connect(ws.next_layer(), results.begin(), results.end());

    // Set a decorator to change the User-Agent of the handshake
    ws.set_option(websocket::stream_base::decorator(
    [](websocket::request_type& req) {
      req.set(http::field::user_agent,
          std::string(BOOST_BEAST_VERSION_STRING) + " websocket-client-coro");
      }
    ));

    // Perform the websocket handshake
    ws.handshake(host, "/");

    // This buffer will hold the incoming message
    beast::flat_buffer buffer;

    for (int32_t i = 0; i < 8; ++i) {
      // Send the message
      ws.write(net::buffer(std::string(text) + ", numer " +std::to_string(i)));

      // Read a message into our buffer, after is has been cleared
      buffer.clear();
      ws.read(buffer);

      std::cout << "call ws api from 'ws://" << host << ":" << port << "', the response is: "<< std::endl;
      std::cout << "\t" << beast::make_printable(buffer.data()) << std::endl;
    }
    // Close the WebSocket connection
    ws.close(websocket::close_code::normal);
  } catch(std::exception const& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return EXIT_FAILURE;
  }
  
  return EXIT_SUCCESS;
}
