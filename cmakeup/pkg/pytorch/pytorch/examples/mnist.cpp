/// file: mnist.cpp
/// date: 2021-06-18


#include <sys/stat.h>
#include <cstddef>
#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>
#include <torch/torch.h>


// Where to find the MNIST dataset.
const char* kDataRoot = "./data";

// The batch size for training.
const int64_t kTrainBatchSize = 64;

// The batch size for testing.
const int64_t kTestBatchSize = 1000;

// The number of epochs to train.
const int64_t kNumberOfEpochs = 10;

// After how many batches to log a new update with the loss value.
const int64_t kLogInterval = 50;



bool is_path_exist(const std::string &s) {
  struct stat buffer;
  return (stat (s.c_str(), &buffer) == 0);
}


std::string get_mnist(const std::string& path, const std::string& type="train") {
  std::string train_label_url = "http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz";
  std::string train_img_url = "http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz";
  std::string test_label_url = "http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz";
  std::string test_img_url = "http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz";

  if ( is_path_exist(path) ) {
    std::cout << "Data path '" + path + "' already exists." << std::endl;
    return path;
  }

  system(("mkdir -p " + path).c_str());
  if (type == "train") {
    system(("cd " + path + " && wget " + train_label_url).c_str());
    system(("cd " + path + " && wget " + train_img_url).c_str());
  } else if (type == "test") {
    system(("cd " + path + " && wget " + test_label_url).c_str());
    system(("cd " + path + " && wget " + test_img_url).c_str());
  }
  system(("cd " + path + " && gzip -d ./*labels*.gz &&  gzip -d ./*images*.gz").c_str());
  return path;
}


torch::Device get_torch_device() {
  torch::DeviceType device_type;
  if (torch::cuda::is_available) {
    std::cout << "CUDA available! Training on GPU." << std::endl;
    device_type = torch::kCUDA;
  } else {
    std::cout << "Training on CPU." << std::endl;
    device_type = torch::kCPU;
  }
  torch::Device device(device_type);
  return device;
}


typedef struct Net : torch::nn::Module {
  Net() : 
      conv1(torch::nn::Conv2dOptions(1, 10, /*kernel_size=*/5)),
      conv2(torch::nn::Conv2dOptions(10, 20, 5)), 
      fc1(320, 50), 
      fc2(50, 10) {
    register_module("conv1", conv1);
    register_module("conv2", conv2);
    register_module("fc1", fc1);
    register_module("fc2", fc2);
  }

  torch::Tensor forward(torch::Tensor x) {
    x = conv1->forward(x);
    x = torch::relu(torch::max_pool2d(x, 2));
    x = conv2_drop->forward(conv2->forward(x));
    x = torch::relu(torch::max_pool2d(x, 2));
    x = x.view({-1, 320});
    x = torch::relu(fc1->forward(x));
    x = torch::dropout(x, /*p=*/0.5, /*training=*/is_training());
    x = fc2->forward(x);

    return torch::log_softmax(x, /*dim=*/1);
  }

  torch::nn::Conv2d conv1;
  torch::nn::Conv2d conv2;
  torch::nn::Dropout2d conv2_drop;
  torch::nn::Linear fc1;
  torch::nn::Linear fc2;
} Net;


template <typename DataLoader>
void train(Net& model, torch::Device& device, 
    DataLoader& data_loader, torch::optim::Optimizer& optimizer, 
    size_t dataset_size) {
  model.train();
  size_t batch_idx = 0;
  for (auto& batch : data_loader) {
    auto data = batch.data.to(device);
    auto target  = batch.target.to(device);
    // Clean historical calculated gradients, if not, gradients will 
    // be accumulated along each batch's training
    optimizer.zero_grad(); 
    auto output = model.forward(data);
    auto loss = torch::nll_loss(output, target);

    loss.backward();
    optimizer.step();

    if (batch_idx++ % kLogInterval == 0) {
      /// NOTE:
      /// The following `template` grammer ref to 'https://stackoverflow.com/questions/3499101/when-do-we-need-a-template-construct'.
      printf("Training Loss: %.4f\n", loss.template item<float>());
    }
  }
  return;
}


int main(int argc, char** argv) {
  torch::Device device = get_torch_device();
  Net model;
  model.to(device);

  std::string kDataRoot_train = get_mnist("./train_data", "train");
  std::string kDataRoot_test = get_mnist("./test_data", "test");
  auto train_dataset = torch::data::datasets::MNIST(kDataRoot_train)\
                       .map(torch::data::transforms::Normalize<>(0.1307, 0.3081))\
                       .map(torch::data::transforms::Stack<>());
  const size_t train_dataset_size = train_dataset.size().value();
  auto train_loader = 
      torch::data::make_data_loader<torch::data::samplers::SequentialSampler>(
        std::move(train_dataset), kTrainBatchSize);

  torch::optim::SGD optimizer(
      model.parameters(), torch::optim::SGDOptions(0.01).momentum(0.5));

  for (int32_t epoch = 0; epoch < kNumberOfEpochs; epoch++) {
    std::cout << epoch << " epoch training..." << std::endl;
    /// NOTE:
    /// Calling by `train` but not `train<...>` can ref to 
    /// 'https://en.cppreference.com/w/cpp/language/function_template', 
    /// Implicit instantiation part.
    train(model, device, *train_loader, optimizer, train_dataset_size);
  }

  return 0;
}
