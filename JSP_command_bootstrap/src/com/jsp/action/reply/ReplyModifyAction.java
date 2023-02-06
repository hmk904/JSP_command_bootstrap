package com.jsp.action.reply;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.josephoconnell.html.HTMLInputFilter;
import com.jsp.action.Action;
import com.jsp.dto.ReplyVO;
import com.jsp.service.ReplyService;

public class ReplyModifyAction implements Action {
	
	private ReplyService replyService;
	public void setReplyService(ReplyService replyService) {
		this.replyService = replyService;
	}

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String url = null;
		
		// jackson형 한테 vo 넘겨줌
		ObjectMapper mapper = new ObjectMapper();
		ReplyVO reply = mapper.readValue(request.getReader(), ReplyVO.class);
		
		// filter 걸어줌 이걸 안하면 script 실행됨.
		String replytext = HTMLInputFilter.htmlSpecialChars(reply.getReplytext());
		reply.setReplytext(replytext);
		
		// 서비스 호출. 화면이 null이라 여기서 에러를 처리해야함.
		try {
			replyService.modifyReply(reply);
		}catch(SQLException e) {
			e.printStackTrace();
			response.sendError(response.SC_INTERNAL_SERVER_ERROR);		
		}
		
		return url;
	}

}
