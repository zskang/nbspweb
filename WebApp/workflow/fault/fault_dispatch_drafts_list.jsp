<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<%@ include file="/common/meta.jsp"%>
		<link href="${ctx}/css/base.css" rel="stylesheet" type="text/css" />
		<link href="${ctx }/css/style.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${ctx }/js/in-min.js"
			autoload="true"
			core="${config.cdnurl}/cabletech/ui/js/jquery-1.7.2.min.js"></script>
		<title>草稿箱</title>
		<script>
In.add('jqui',{path:'${ctx}/js/jQuery/jqueryui/css/redmond/jquery-ui.custom.css'});
In.add('jquijs',{path:'${ctx}/js/jQuery/jqueryui/jquery-ui.custom.min.js',type:'js',charset:'utf-8',rely:['jqui']});
In.add('jquicn',{path:'${ctx}/js/jQuery/jqueryui/zh/jquery.ui.datepicker-zh-CN.js',type:'js',charset:'utf-8',rely:['jquijs']});
In.add('jresize',{path:'${ctx}/js/jQuery/jresize/jquery.wresize.js',type:'js',charset:'utf-8',rely:['jquicn']});
In.add('jgcss',{path:'${ctx}/js/jQuery/jqgrid/css/ui.jqgrid.css',charset:'utf-8',rely:['jresize']});
In.add('jgjs',{path:'${ctx}/js/jQuery/jqgrid/jquery.jqGrid.min.js',type:'js',charset:'utf-8',rely:['jgcss']});
In.add('jgcn',{path:'${ctx}/js/jQuery/jqgrid/grid.locale-cn.js',type:'js',charset:'utf-8',rely:['jgjs']});
In.add('common',{path:'${ctx}/common/js/common.js',type:'js',charset:'utf-8'});
In.add('wdatejs',{path:'${ctx}/js/WdatePicker/WdatePicker.js',type:'js',charset:'utf-8'});
In.add('fault-common', {path : '${ctx}/workflow/fault/js/fault_common.js',type : 'js',charset : 'utf-8'});
In.add('fault-list', {path : '${ctx}/workflow/fault/js/fault__dispatch_drafts_list.js',type : 'js',charset : 'utf-8',rely:['fault-common']});
In.add('layout',{path:'${ctx}/js/jQuery/layout/layout-default-latest.css'});
In.add('layoutjs',{path:'${ctx}/js/jQuery/layout/jquery.layout-latest.min.js',type:'js',charset:'utf-8',rely:['layout']});
	In.ready('jgcn','layoutjs', 'common', 'wdatejs', 'fault-list', function() {
		setContextPath('${ctx}');
	accordionObj=jQuery("#accordion").accordion({
 		autoHeight:false,header: 'h3',navigation:true,
 		collapsible: true,active:1
	});
		//使用层布局
		var jqgrid = jQuery("#faultgrid").jqGrid({
							url : "${ctx}/workflow/faultDispatchDraftAction!listdata.action?",
							datatype : "json",mtype : 'GET',rownumbers : true,
							colNames : [ '故障单标题','工单号', 'EOMS单号', '故障发生时间', '故障发生地点','故障站点', '是否紧急', '发现方式','处理人','处理时限', '操作', '专业类型' ],
							colModel : [ 
								          {name:'TROUBLE_TITLE',id:'TROUBLE_TITLE',sortable:false,width:150},
								          {name:'TASK_CODE',id:'TASK_CODE',sortable:false,width:150},
								          {name:'EOMS_ID',id:'EOMS_ID',sortable:false,width:100},
								          {name:'TROUBLE_TIME_DIS',id:'TROUBLE_TIME_DIS',sortable:false,width:120},
								          {name:'ADDRESS',id:'ADDRESS',sortable:false,width:90},
								          {name:'RSNAME',id:'RSNAME',sortable:false,width:80},
								          {name:'IS_INSTANCY',id:'IS_INSTANCY',sortable:false,formatter:InstancyFmatter,width:70},
								          {name:'FIND_TYPENAME',id:'FIND_TYPENAME',sortable:false,width:70},
								          {name:'PROCESSOR_NAME',id:'PROCESSOR_NAME',sortable:false,hidden:true,width:80},
								          {name:'PROCESS_TIME_DIS',id:'PROCESS_TIME_DIS',sortable:false,width:120},
								          {name:'DISPATCH_ID',id:'DISPATCH_ID',sortable:false,formatter:dispatchFmatter,width:90},
										  {name : 'BUSINESS_TYPE',id : 'BUSINESS_TYPE',sortable : false,hidden : true} 
							],
							rowNum:15,autowidth:true,rowList:[15,30,50],pager: '#faultpager',shrinkToFit:false,viewrecords: true,hidegrid: false,fix:true,autoScroll:true,
							prmNames : {
								page : "pageNo",rows : "rows",sort : "sidx",order : "sord"
							},
							jsonReader : {
								root : "result",page : "pageNo",total : "totalPages", 
								records : "totalCount",repeatitems : false
							}
					}).navGrid('#faultpager', {
					edit : false,add : false,del : false,search : false,sortable : false
				});
		jQuery(window).wresize(function() {
			grid_resize(jqgrid);
		});
		grid_resize(jqgrid);
	});
</script>
	</head>
	<body>
		<form id="searchForm" name="searchForm">
			<div>
				<div class="title_bg">
					<div id="title" class="title">
						当前位置-故障草稿箱列表
					</div>
				</div>
				<div id="accordion">
					<h3>
						<a href="#" id="accord">搜索条件</a>
					</h3>
					<div class="tabcontent">
						<table cellspacing="0" cellpadding="0" border="0" align="center">
							<tr>
								<th>
									故障单标题:
								</th>
								<td>
									<input name="parameter.isQuery" id="isQuery" value="1" type="hidden" />
									<input type="text" class="inputtext" style="width: 220px" name="parameter.troubleTitle" id='troubleTitle' />
								</td>
								<th>
									故障发生时间:
								</th>
								<td>
									<input type="text" class="inputtext" style="width: 95px" id='troubleTimeStart' name="parameter.troubleTimeStart" class="Wdate inputtext" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'troubleTimeEnd\')}'})" />
									至
									<input id='troubleTimeEnd' type="text" class="inputtext" style="width: 95px" name="parameter.troubleTimeEnd" class="Wdate inputtext" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'troubleTimeStart\')}'})" />
								</td>
							</tr>
							<tr>
								<th>
									发现方式:
								</th>
								<td>
									<baseinfo:dicselector id="parameter_findType" name="parameter.findType" columntype="FIND_TYPE" type="select" cssClass="inputtext" style="width:220px" isQuery="query"></baseinfo:dicselector>
								</td>
								<th>
									EMOS单号
								</th>
								<td>
									<input type="text" class="inputtext" style="width: 220px" id='eomsid' name="parameter.eomsId" />
								</td>
							</tr>
							<tr>
								<th>
									专业类型：
								</th>
								<td>
									<baseinfo:customselector name="parameter.businessType" data="${businessTypeMap}" isReversal="true" isQuery="query" cssClass="inputtext" id="businessType" style="width: 220px"></baseinfo:customselector>
								</td>
								<th>
									故障站点：
								</th>
								<td>
									<input type="text" name="parameter.resourceName" class="inputtext" style="width: 220px" id="resourceName" />
								</td>
							</tr>
							<tr>
								<th>
									是否紧急:
								</th>
								<td colspan="3">
									<input type="radio" name="parameter.isInstancy" value="" />
									不限
									<input type="radio" name="parameter.isInstancy" value="2" />
									否
									<input type="radio" name="parameter.isInstancy" value="1" />
									是
								</td>
							</tr>
							<tr>
								<td align="center" colspan="4">
									<input type="button" onclick="query();" class="button" value="查询" />
									<baseinfo:expexcel cls="exprotButton" businessId="faultdispatchdraftslist" name="导出excel"></baseinfo:expexcel>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div id="content" align="center">
				<table id="faultgrid"></table>
				<div id="faultpager"></div>
			</div>
		</form>
	</body>
</html>