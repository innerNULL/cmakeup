/// file: demo.cpp
/// date: 2021-04-16


#include "oatpp-websocket/WebSocket.hpp"
#include "oatpp-websocket/Connector.hpp"
#include "oatpp-websocket/ConnectionHandler.hpp"
#include "oatpp-websocket/WebSocket.hpp"

#include "oatpp/network/tcp/client/ConnectionProvider.hpp"

#include <thread>


bool finished = false;
const char* TAG = "websocket-client";


/**
 * WebSocket listener listens on incoming WebSocket events.
 */
class WSListener : public oatpp::websocket::WebSocket::Listener {
 private:
  static constexpr const char* TAG = "Client_WSListener";
  
  std::mutex& m_writeMutex;
  /**
   * Buffer for messages. Needed for multi-frame messages.
   */
  oatpp::data::stream::ChunkedBuffer m_messageBuffer;
 
 public:
  WSListener(std::mutex& writeMutex) : m_writeMutex(writeMutex) { printf("init"); }

  /**
   * Called on "ping" frame.
   */
  void onPing(const WebSocket& socket, const oatpp::String& message) override {
    std::lock_guard<std::mutex> lock(m_writeMutex);
    socket.sendPong(message);
  }

  /**
   * Called on "pong" frame
   */
  void onPong(const WebSocket& socket, const oatpp::String& message) override {
    printf("onPong");
  };

  /**
   * Called on "close" frame
   */
  void onClose(const WebSocket& socket, 
      v_uint16 code, const oatpp::String& message) override {
    printf("onClose code=%d", code);
  }

  /**
   * @brief 
   * Called on each message frame. After the last message will be called 
   * once-again with size == 0 to designate end of the message.
   */
  void readMessage(const WebSocket& socket, 
      v_uint8 opcode, p_char8 data, oatpp::v_io_size size) override {
    if(size == 0) { // message transfer finished
      auto wholeMessage = m_messageBuffer.toString();
      m_messageBuffer.clear();
      OATPP_LOGD(TAG, "on message received '%s'", wholeMessage->c_str());
    } else { // message frame received
      m_messageBuffer.writeSimple(data, size);
    }
  }

};


void socketTask(const std::shared_ptr<oatpp::websocket::WebSocket>& websocket) {
  websocket->listen();
  OATPP_LOGD(TAG, "SOCKET CLOSED!!!");
  finished = true;
}


void run(std::string ws_url) {
  auto connectionProvider = oatpp::network::tcp::client::ConnectionProvider::createShared({"echo.websocket.org", 80});
  auto connector = oatpp::websocket::Connector::createShared(connectionProvider);
  auto connection = connector->connect("/");
  auto socket = oatpp::websocket::WebSocket::createShared(connection, true /* maskOutgoingMessages must be true for clients */);
  
  std::mutex socketWriteMutex;
  socket->setListener(std::make_shared<WSListener>(socketWriteMutex));
  //socket->listen();
  std::thread thread(socketTask, socket);

  while(!finished) {
    {
      OATPP_LOGD(TAG, "sending message...");
      std::lock_guard<std::mutex> lock(socketWriteMutex);
      socket->sendOneFrameText("hello");
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
  }

  thread.join();
}


int main(int argc, char **argv) {
  std::string ws_url = "wss://stream.data.alpaca.markets/v2/iex";

  oatpp::base::Environment::init();
  run(ws_url);
  oatpp::base::Environment::destroy();
  return 0;
}
