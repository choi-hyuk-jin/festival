<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 수정</title>
<%	
	String board_num = request.getParameter("board_num");		
%>

<c:set var="board_num" value="<%=board_num%>"/> <!-- 게시글 번호 -->

<!-- 공통 CSS -->
<link rel="stylesheet" type="text/css" href="/css/common/common.css"/>

<!-- 공통 JavaScript -->
<script type="text/javascript" src="/js/common/jquery.js"></script>
<script type="text/javascript" src="/js/common/jquery.form.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){		
		getBoardDetail();		
	});
	
	/** 게시판 - 목록 페이지 이동 */
	function goBoardList(){				
		location.href = "/board/boardList";
	}
	
	/** 게시판 - 상세 조회  */
	function getBoardDetail(board_num){
		
		var board_num = $("#board_num").val();

		if(board_num != ""){
			
			$.ajax({	
				
			    url		: "/board/getBoardDetail",
			    data    : $("#boardForm").serialize(),
		        dataType: "JSON",
		        cache   : false,
				async   : true,
				type	: "POST",	
		        success : function(obj) {
		        	getBoardDetailCallback(obj);				
		        },	       
		        error 	: function(xhr, status, error) {}
		        
		     });
			
		} else {
			alert("오류가 발생했습니다.\n관리자에게 문의하세요.");
		}	
	}
	
	/** 게시판 - 상세 조회  콜백 함수 */
	function getBoardDetailCallback(obj){
				
		if(obj != null){								
							
			var board_num		= obj.board_num; 
			var fb_group_num 	= obj.fb_group_num; 
			var m_nickname 		= obj.m_nickname; 
			var fb_title 		= obj.fb_title; 
			var fb_content 		= obj.fb_content; 
			var fb_hits 		= obj.fb_hits;
			var fb_delete_yn 	= obj.fb_delete_yn; 
			var m_id 			= obj.m_id;
			var fb_insert_date 	= obj.fb_insert_date; 
			var fb_update_date 	= obj.fb_update_date;
			var files			= obj.files;		
			var filesLen		= files.length;
								
			$("#fb_title").val(fb_title);			
			$("#fb_content").val(fb_content);
			$("#m_nickname").text(m_nickname);
			
			var fileStr = "";
			
			if(filesLen > 0){
				
				for(var a=0; a<filesLen; a++){
					
					var board_num		= files[a].board_num;
					var bf_num 			= files[a].bf_num;
					var bf_name_key 	= files[a].bf_name_key;
					var bf_name 		= files[a].bf_name;
					var bf_path 		= files[a].bf_path;
					var bf_size 		= files[a].bf_size;
					var bf_delete_yn 	= files[a].bf_delete_yn;
					var m_id 			= files[a].m_id;
					var bf_insert_date 	= files[a].bf_insert_date;
					var bf_update_date 	= files[a].bf_update_date;
					
					fileStr += "<a href='/board/fileDownload?bf_name_key="+encodeURI(bf_name_key)+"&bf_name="+encodeURI(bf_name)+"&bf_path="+encodeURI(bf_path)+"'>" + bf_name + "</a>";
					fileStr += "<button type='button' class='btn black ml15' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile("+ board_num +", "+ bf_num +")'>X</button>";
				}			
								
			} else {
				
				fileStr = "<input type='file' id='files[0]' name='files[0]' value=''></td>";
			}
			
			$("#file_td").html(fileStr);
			
		} else {			
			alert("등록된 글이 존재하지 않습니다.");
			return;
		}		
	}
	
	/** 게시판 - 수정  */
	function updateBoard(){

		var boardSubject = $("#fb_title").val();
		var boardContent = $("#fb_content").val();
			
		if (fb_title == ""){			
			alert("제목을 입력해주세요.");
			$("#fb_title").focus();
			return;
		}
		
		if (fb_content == ""){			
			alert("내용을 입력해주세요.");
			$("#fb_content").focus();
			return;
		}
		
		var yn = confirm("게시글을 수정하시겠습니까?");		
		if(yn){
				
			var filesChk = $("input[name='files[0]']").val();
			if(filesChk == ""){
				$("input[name='files[0]']").remove();
			}
			
			$("#boardForm").ajaxForm({
		    
				url		: "/board/updateBoard",
				enctype	: "multipart/form-data",
				cache   : false,
		        async   : true,
				type	: "POST",					 	
				success : function(obj) {
					updateBoardCallback(obj);				
			    },	       
			    error 	: function(xhr, status, error) {}
			    
		    }).submit();
		}
	}
	
	/** 게시판 - 수정 콜백 함수 */
	function updateBoardCallback(obj){
	
		if(obj != null){		
			
			var result = obj.result;
			
			if(result == "SUCCESS"){				
				alert("게시글 수정을 성공하였습니다.");				
				goBoardList();				 
			} else {				
				alert("게시글 수정을 실패하였습니다.");	
				return;
			}
		}
	}
	
	/** 게시판 - 삭제할 첨부파일 정보 */
	function setDeleteFile(board_num, fileSeq){
		
		var deleteFile = board_num + "!" + fileSeq;		
		$("#delete_file").val(deleteFile);
				
		var fileStr = "<input type='file' id='files[0]' name='files[0]' value=''>";		
		$("#file_td").html(fileStr);		
	}
		
</script>
</head>
<body>
<div id="wrap">
	<div id="container">
		<div class="inner">	
			<h2>게시글 상세</h2>
			<form id="boardForm" name="boardForm" action="/board/updateBoard" enctype="multipart/form-data" method="post" onsubmit="return false;">	
				<table width="100%" class="table02">
				<caption><strong><span class="t_red">*</span> 표시는 필수입력 항목입니다.</strong></caption>
				    <colgroup>
				         <col width="20%">
				        <col width="*">
				    </colgroup>
				    <tbody id="tbody">
				       <tr>
							<th>제목<span class="t_red">*</span></th>
							<td><input id="fb_title" name="fb_title" value="" class="tbox01"/></td>
						</tr>
						 <tr>
							<th>작성자</th>
							<td id="m_nickname"></td>
						</tr>
						<tr>
							<th>내용<span class="t_red">*</span></th>
							<td colspan="3"><textarea id="fb_content" name="fb_content" cols="50" rows="5" class="textarea01"></textarea></td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td colspan="3" id="file_td"><input type="file" id="files[0]" name="files[0]" value=""></td>
						</tr>
				    </tbody>
				</table>	
				<input type="hidden" id="board_num"		name="board_num"	value="${board_num}"/> <!-- 게시글 번호 -->
				<input type="hidden" id="search_type"	name="search_type"	value="U"/> <!-- 조회 타입 - 상세(S)/수정(U) -->
				<input type="hidden" id="delete_file"	name="delete_file"	value=""/> <!-- 삭제할 첨부파일 -->
			</form>
			<div class="btn_right mt15">
				<button type="button" class="btn black mr5" onclick="javascript:goBoardList();">목록으로</button>
				<button type="button" class="btn black" onclick="javascript:updateBoard();">수정하기</button>
			</div>
		</div>
	</div>
</div>
</body>
</html>