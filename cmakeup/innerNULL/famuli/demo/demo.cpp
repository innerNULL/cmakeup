/// file: main.cpp
/// date: 2021-04-01


#include "famuli/model/model.h"
#include "famuli/model/fasttext.h"


int32_t fasttext_demo(const std::string& model_path) {
  famuli::Fasttext fasttext(model_path);
  fasttext.init();
  std::vector< std::pair<float, std::string> > predictions; 
  fasttext.infer(&predictions, 
      "上 海 老 相 机 制 造 博 物 馆 即 将 开 门 迎 客");
  famuli::Fasttext::print_outputs(predictions);   
}



int main() {
  
  const std::string MODEL_URL = "https://dl.fbaipublicfiles.com/fasttext/supervised-models";
  const std::string MODEL_NAME = "sogou_news.ftz";

  std::string model_uri = MODEL_URL + "/" + MODEL_NAME;
  std::string model_path = "./" + MODEL_NAME;

  system(("rm -rf " + model_path + " && wget " + model_uri).c_str());

  fasttext_demo(model_path);
  return 0;
}
