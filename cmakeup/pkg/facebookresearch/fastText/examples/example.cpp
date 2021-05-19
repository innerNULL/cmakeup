/// file: example.cpp
/// date: 2021-05-14


#include <cstdlib>
#include <sstream>
#include <utility>
#include <fasttext/fasttext.h>




int32_t prediction_demo(const std::string& model_path, 
        const std::string& model_input) {
  printf("Starts prediction_demo\n");
  system("pwd");
  /// ERROR:
  //std::shared_ptr<fasttext::FastText> model_ptr;
  //model_ptr->loadModel(model_path);
  
  // ERROR:
  //std::auto_ptr<fasttext::FastText> model_ptr;
  //model_ptr->loadModel(model_path);

  fasttext::FastText model;
  model.loadModel(model_path);

  std::stringstream model_input_;
  model_input_ << model_input;
  //std::istream& model_input__ = model_input_;

  std::vector< std::pair<float, std::string> > predictions;
  model.predictLine(model_input_, predictions, 3, 0.01);

  std::cout << "Prediction results: " << std::endl;
  for (std::vector< std::pair<float, std::string> >::iterator iter = predictions.begin(); 
          iter < predictions.end(); ++iter) {
    std::cout << "category: " << iter->second << ", score: " << iter->first << std::endl;
  }

  printf("Finished prediction_demo\n");
  return 0;
}




int main() {
  const std::string MODEL_URL = "https://dl.fbaipublicfiles.com/fasttext/supervised-models";
  const std::string MODEL_NAME = "sogou_news.ftz";

  std::string model_uri = MODEL_URL + "/" + MODEL_NAME;
  std::string model_path = "./" + MODEL_NAME;

  //std::vector<std::string> model_input = {
  //    "上", "海", "老", "相", "机", "制", "造", "博", "物", "馆", "即", "将", "开", "门", "迎", "客"
  //};
  std::string model_input = "上 海 老 相 机 制 造 博 物 馆 即 将 开 门 迎 客";

  system(("rm -rf " + model_path + " && wget " + model_uri).c_str());

  prediction_demo(model_path, model_input); 
  return 0;
}
