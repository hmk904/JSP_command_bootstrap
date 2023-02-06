<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>
<script type="text/x-handlebars-template"  id="reply-list-template" >
{{#each .}}
<div class="replyLi" >
	<div class="user-block">
		<img src="<%=request.getContextPath()%>/member/getPicture.do?id={{replyer}}" class="img-circle img-bordered-sm"/>
    </div>	
	<div class="timeline-item" >
  		<span class="time">
    		<i class="fa fa-clock"></i>{{prettifyDate regdate}}
	 		<a class="btn btn-primary btn-xs {{rno}}-a" id="modifyReplyBtn" data-rno={{rno}}
				onclick="replyModifyModal_go('{{rno}}');"
				style="display:{{visibleByLoginCheck replyer}};"
	    		data-replyer={{replyer}} data-toggle="modal" data-target="#modifyModal">Modify</a>
  		</span>
	
  		<h3 class="timeline-header"><strong style="display:none;">{{rno}}</strong>{{replyer}}</h3>
  		<div class="timeline-body" id="{{rno}}-replytext">{{replytext}} </div>
	</div>
</div>

{{/each}}	
</script>




<script>
var replyPage=1;
window.onload=function(){
	getPage("<%=request.getContextPath()%>/reply/list.do?bno=${board.bno}&page="+replyPage);
}

function getPage(pageInfo,page){
	if(page) replyPage = page;
	$.getJSON(pageInfo,function(data){	
		printData(data.replyList,$('#repliesDiv'),$('#reply-list-template'));		
	});
}

function printData(replyArr,target,templateObject){
	var template=Handlebars.compile(templateObject.html());
	var html = template(replyArr);	
	$('.replyLi').remove();
	target.after(html);
}

Handlebars.registerHelper({
	"prettifyDate":function(timeValue){ //Handlbars에 날짜출력함수 등록
						var dateObj=new Date(timeValue);
						var year=dateObj.getFullYear();
						var month=dateObj.getMonth()+1;
						var date=dateObj.getDate();
						return year+"/"+month+"/"+date;
					},
	"visibleByLoginCheck":function(replyer){
		var result="none";		
		if(replyer == "${loginUser.id}") result="visible";		
		return result;						  
	}
});
</script>

<script>
function replyRegist_go(){
	//alert("add reply click");
	var replytext=$('#newReplyText').val();	
	
	var data={
			"bno":"${board.bno}",
			"replyer":"${loginUser.id}",
			"replytext":replytext	
	}
	
	$.ajax({
		url:"<%=request.getContextPath()%>/reply/regist.do",
		type:"post",
		data:JSON.stringify(data),		
		contentType:'application/json',
		success:function(data){
			alert('댓글이 등록되었습니다.\n마지막페이지로 이동합니다.');
			replyPage=data; //페이지이동
			getPage("<%=request.getContextPath()%>/reply/list.do?bno="+${board.bno}+"&page="+data); //리스트 출력
			$('#newReplyText').val("");	
		},
		error:function(error){
			AjaxErrorSecurityRedirectHandler(error.status);	
		}
	});
}

// 댓글수정 modal 알럿문 나오고 modal나옴.
function replyModifyModal_go(rno){
	//alert(rno);
 	//alert($('div#'+rno+'-replytext').text());
 	
 	//detail.jsp에 있음
 	$('div#modifyModal div.modal-body input#replytext').val($('div#'+rno+'-replytext').text());
 	$('div#modifyModal div.modal-header h4.modal-title').text(rno);
}

//댓글 수정. 
function replyModify_go(){
	//alert("modify btn");
	
	var rno=$('div#modifyModal h4.modal-title').text();
	var replytext=$('div#modifyModal #replytext').val();
	
	// JSON data 만듬.
	var sendData={
			"rno":rno,
			"replytext":replytext
	}
	//console.log(sendData);
	
	//JSON으로 내보냄.
	$.ajax({
		url:"<%=request.getContextPath()%>/reply/modfiy.do",
		type:"post",
		data:JSON.stringify(sendData),
		contentType:"application/json",
		success:function(result){
			
		},
		error:function(error){
			AjaxErrorSecurityRedirectHandler(error.status);
		},
		complete:function(){
			$('#modifyModal').modal('hide');
		}
	});
}

</script>










