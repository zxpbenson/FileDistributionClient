function TreeClass(args){
  //SuperFunction.call(this);

  args = args ? args : {};
  args = {
    targetDivId : args.targetDivId ? args.targetDivId : "",
    iconImagePath : args.iconImagePath ? args.iconImagePath : "",
    jsonData : args.jsonData ? args.jsonData : {
      id:"0",
      text:"root"
    },
    onNodeSelect : args.onNodeSelect ? args.onNodeSelect : function(selNodeId){}
  };

  this.jsonData = args.jsonData;
  this.tree = new dhtmlXTreeObject(args.targetDivId,"100%","100%",0);
  this.tree.setImagePath(args.iconImagePath);

  this.loadTree = function(treeNodeStrArr){
    this.deleteSubNode(this.jsonData);
    if(this.jsonData.item)this.jsonData.item.length = 0;
    for(var index = 0; index < treeNodeStrArr.length; index++){
      this.addJSONNode(treeNodeStrArr[index]);
    }
    this.tree.loadJSONObject(this.jsonData);
    this.tree.setOnClickHandler(this.onNodeSelect); 
    this.tree.openAllItems(0);
  }

  this.onNodeSelect = args.onNodeSelect;

  this.addJSONNode = function(nodeStr){
    var arr = nodeStr.split(".");
    var curNode = this.jsonData;
    var targetNode = this.getNode(curNode,arr[0]);
    if(targetNode){
      curNode = targetNode;
    }else{
      curNode = this.addNode(curNode,arr[0],arr[0]);
    }
    if(arr.length >= 2){
      targetNode = this.getNode(curNode,arr[0]+"."+arr[1]);
      if(targetNode){
        curNode = targetNode;
      }else{
        curNode = this.addNode(curNode,arr[0]+"."+arr[1],arr[1]);
      }
    }
    if(arr.length >= 3){
      targetNode = this.getNode(curNode,arr[0]+"."+arr[1]+"."+arr[2]);
      if(targetNode){
        curNode = targetNode;
      }else{
        curNode = this.addNode(curNode,arr[0]+"."+arr[1]+"."+arr[2],arr[2]);
      }
    }
  }
  
  this.getNode = function(curNode,nodeId){
    if(curNode){
      if(curNode.id == nodeId)return curNode;
      if(curNode.item){
        for(var index = 0; index < curNode.item.length; index++){
          var ret = this.getNode(curNode.item[index],nodeId);
          if(ret)return ret;
        }
        return null;
      }else{
        return null;  
      }
    }else{
      return null;
    }
  }
  
  this.addNode = function(node,subNodeId,subNodeText){
    var subNode = {id:subNodeId,text:subNodeText};
    if(node.item){
      node.item.push(subNode);
    }else{
      node.item = new Array();
      node.item.push(subNode);
    }
    return subNode;
  }
  
  this.deleteSubNode = function(node){
    if(node.item){
      for(var index = 0; index < node.item.length; index++){
        this.tree.deleteItem(node.item[index].id,true);
      }      
    }
  }

}