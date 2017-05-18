<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   
  </head>
  
  <script type="text/javascript">
  
  function clearForm(){
  	$('#ff').form('clear');
  }
  
  
  function formatOper(value,row,index){
      return '<a href="#" class="easyui-linkbutton" onclick="deleteUser(2)">删除</a>';  
 } 
 
 
 //条件查询 
 function query(){
    $('#dataList')[0].style.display="";
    $('#dg').datagrid({
    url:"${ctx}/listUser.do",
    queryParams:{userid:$('#classId').val(),
    			userName:$('#studentId').val(),
    			position:$('#position').combobox('getValue')} //传参
    });
 }
 
 
 //处理选课状态 flag=1表示批量确认操作，flag=2表示批量取消操作，falg=3 表示批量删除操作，flag=4表示确认操作， flag=5表示取消操作，flag=6 表示删除操作
 //operateType 标志位 U表示确认，C表示取消，D表示删除
 function deleteUser(flag){
 	var msg = "";
 	var operateType = "";
 	if(flag=="1"){
 		msg = "您确定想要批量删除吗？";
  	}else if(flag=="2"){
  		msg = "您确定想要删除吗？";
 	}
 	
	 $.messager.confirm('确认',msg,function(r){    
	    if (r){  
	        var selRow = $('#dg').datagrid("getSelections");//返回选中多行
			if(selRow.length==0){  
				$.messager.alert("警告","请至少选择一行数据!");  
				return false;  
			}
			var ids=[];
			for (var i = 0; i < selRow.length; i++) {  
				//获取自定义table 的中的checkbox值  
				var id=selRow[i].id;   	
				ids.push(id);
			}
			
			$.getJSON("${ctx}/deleteUser.do",
				{"ids[]":ids},
				function(data){
					$.messager.alert("提示信息",data);
					$('#dg').datagrid("reload");
				});			
	    }    
	}); 
 
 }
 
 
 
 function addUser(){
 
 	$('#dlg').dialog('open').dialog('setTitle','填写用户信息');
 	
 }
 
 function uploadUser(){
	 
		$('#dlg_file').dialog('open').dialog('setTitle','学生信息导入');
		 	
	 }
	 
	 function uploadFile(){
		 	
		 	
		 	var fileName = $('#file').filebox('getValue');
		 	var prefix = fileName.substring(fileName.lastIndexOf(".")+1);
		 	if(prefix=="xlsx"||prefix=="xls"){
		 	
			 	$('#fileUpload').form('submit',{
					 url: "${ctx}/uploadUserFile.do", 	
			         success: function(result){
			          $.messager.alert("提示",result);
			          $('#fileUpload').form('clear');
			        }	
			 	}); 	
		 	
		 	}else{
		 		$.messager.alert("提示信息","您上传的文件格式为："+prefix+"，请上传文件格式为xls或xlsx的文件");
		 	
		 	}
		 

		 
		 }
 
	 function saveUser(){
            $('#fm').form('submit',{
                url: "${ctx}/insertUser.do",
                success: function(result){
                	var result = eval('('+result+')');
                	if(result.code==1){
                		$.messager.alert("提示信息",result.message,'info',function(){
                			$('#dlg').dialog('close');
                		});
                		
                	}else{
                		$.messager.alert("提示信息",result.message);
                	}                   
                    
                }
            });
 	
	 } 
 
 
  </script>
  
  
 <body>
	<h1 style="font-size: 28px;color: #00a1f1;border-bottom: 1px solid #b6d9e8;line-height: 50px;word-break:break-all;">
	    人员管理
   </h1>  
 
 <form id="ff" method="post">   
 
 <table style="background:#efefef; border-collapse:collapse ;"   width="100%" height="80" cellspacing="5" cellpadding="5"> 
 	<tr>
	 	<td width="15%" align="right" ><label for="userid" >学号或工号:</label> </td>
	 	<td width="15%"><input class="easyui-textbox" type="text" id="classId" /> </td>
	 	<td width="15%" align="right"><label for="userName">用户名:</label> </td>
	 	<td width="15%"><input class="easyui-textbox" type="text" id="studentId"  /></td>
	 	<td width="15%" align="right"> <label for="position">身份:</label> </td>
    	<td width="25%">
    		<select class="easyui-combobox" type="text" id="position"  panelHeight="100" style="width:150px;" >
    			<option value="">所有</option>
    			<option value="1">管理员</option>
    			<option value="2">老师</option>   
    			<option value="3">学生</option>  
    		</select>
    	</td> 
 	</tr>
 
 
 </table>
 	    <div style="text-align:center;padding:5px">
 	    
 	        <input type="button" class="btn btn-default" style="margin-right:20px;" onclick="query()" value="查  询" />
 	        <input type="button" class="btn btn-default" style="margin-right:20px;" onclick="clearForm()" value="重  置" />   
			<input type="button" class="btn btn-default" style="margin-right:20px;" onclick="addUser()" value="添  加" /> 
	   <input type="button" class="btn btn-default" style="margin-right:20px;" onclick="uploadUser()" value="信息导入" /> 
	    </div>
 
</form> 
  
  <div id="dataList" style="display: none;" > 
    <table id="dg"  class="easyui-datagrid"  width="100%" 
            toolbar="#toolbar" pagination="true"
            rownumbers="true" fitColumns="true" singleSelect="false" 
            data-options="fit:false,border:false,pageSize:10,pageList:[10,15,20]" >
        <thead>
            <tr >
            	<c:if test="${session.user.position=='1' }">
            		<th data-options="checkbox:true" field=""  ></th>
            	</c:if>
                <th data-options="field:'id'" width="15%">编号</th>
                <th data-options="field:'userId'" width="15%">学号或工号</th>                
                <th data-options="field:'userName'"  width="20%" >用户名</th>
                <th data-options="field:'password'" width="20%">密码</th>
                <th data-options="field:'position'"  width="15%">身份 </th>
                <c:if test="${session.user.position=='1' }">
                	<th data-options="field:'_operate' ,formatter:formatOper" width="5%">操作</th>
                </c:if>
            </tr>
        </thead>
    </table>  
        <div id="toolbar">
        <c:if test="${session.user.position!='3' }">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" plain="true" onclick="deleteUser(1)">批量删除</a>
    	</c:if>
    	</div>
  <div>
  
  
 
     <div id="dlg" class="easyui-dialog"  style="padding:10px 30px"
            closed="true" buttons="#dlg-buttons">
			<s:form name="fm" id="fm" action="" method="post">
				<h2>
					添加信息
				</h2>
				<table border="0">
					<tr>
						<td>学号或工号：</td>
						<td> <input  name="user.userId" class="easyui-textbox" required="true"  style="height: 30px; width: 200px; "/></td>
					</tr>
					<tr>
						<td>用户名：</td>
						<td><input  name="user.userName" class="easyui-textbox" required="true" style="height: 30px; width: 200px; "/></td>
					</tr>
					<tr>
						<td>密码：</td>
						<td><input  name="user.password" class="easyui-textbox" required="true" style="height: 30px; width: 200px;  "/></td>
					</tr>
					<tr>
						<td>身份</td>
						<td>
		    		<select class="easyui-combobox" type="text" id="user.position" name="user.position" panelHeight="80" style="width:150px;" >
		    			<option value="1">管理员</option>
		    			<option value="2">老师</option>   
		    			<option value="3">学生</option>  
		    		</select>						
						</td>
					</tr>					
											
				</table>
				<!--  <input type="submit" class="btn btn-default" style="margin-right:20px;" value="添加" />-->
			</s:form>
    </div>
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveUser()" style="width:90px">确认</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')" style="width:90px">取消</a>
    </div>	 
   <div id="dlg_file" class="easyui-dialog"  style="padding:10px 20px;width: 700px" closed="true" buttons="#file-buttons" >   
 		<form id="fileUpload" method="post" enctype="multipart/form-data">
	  		<table style="border-collapse:collapse ;"  width="600px" height="50px" cellspacing="5" cellpadding="5"> 
	 			<tr>
		 			<td  width="150px" align="right"  ><label for="fileName" >文件选择:</label> </td>
		 			<td   width="200px" align="left" ><input class="easyui-filebox"  id="file" name="file" buttonText="选择文件"  accept=".xlsx,.xls" style="width:300px; height: 26px"> </td>
		 			<td width="100px"   align="left" ><a href="javascript:void(0)" class="easyui-linkbutton" onclick="uploadFile()" style="width: 100px">上  传</a> </td>
	 			</tr>
	  		</table>
 		</form>  
	</div>
	<div id="file-buttons" align="center">
      <a href="javascript:void(0)"   class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlg_file').dialog('close')" style="width:90px">关 闭</a>
	</div>  
    
  
  </body>
</html>
