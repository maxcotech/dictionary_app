
enum ParameterType{primaryKey,word}

class WordParameter{
  final dynamic parameter;
  final ParameterType parameterType;
  WordParameter({this.parameter,this.parameterType});
}