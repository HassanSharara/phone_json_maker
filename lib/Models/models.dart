
class Node {
  String _key;
  dynamic value;
  bool deleted = false;
  Node(final String key,this.value):_key = key;

  factory Node.copy(final Node node){
    Node n = Node(node._key,node.value);
    return n;
  }

  bool get isHide => _key.startsWith("hide_");
  String get key {
    final pat = "hide_";
    if(_key.startsWith(pat)) return _key.substring(pat.length,_key.length);
    return _key;
  }
   set key(final v) {
      _key = v;
   }
  String get actualKey => _key;
  Map get toMap => {
    if(value is List<Node>)
    key:(value as List<Node>).toMap
    else
    key:value
  };


  String  totalNodeToString([int counter =0 ]) {
    if(isHide)return"";
    String res = "";
    res += "$key : \n";
    final v = value;
    if( v is List<Node> ){

      for(final Node n in v){
        counter +=1;
        res+= "${List.generate(counter, (_)=>" ").join()} ${n.totalNodeToString(counter)} \n";
      }
    } else {
      res += "${List.generate(counter, (_)=>" ").join()}  ${v.toString()}";
    }
    return res;
  }

}

extension B on Map {

  List<Node> get toListOfNode {
   final List<Node> nodes = [];
   forEach((key,value){
      final v  = value is Map ? value.toListOfNode : value.toString();
      nodes.add(Node(key,v));
   });
   return nodes;
  }
}

extension A on List<Node> {
  Map get toMap =>{
    for ( final node in this)
      node.key:node.value is List ? Map.fromEntries(
          (node.value as List<Node>)
              .map((Node e){
            return MapEntry(e.key,
              e.value is List<Node>?
                (e.value as List<Node>).toMap
            :e.value.toString()
             );
          }).toList()
      ): node.value
  };
}