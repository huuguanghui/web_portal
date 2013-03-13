<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="org.json.JSONArray" %>    
<%@page import="java.util.Collection" %>
<%@page import="com.imeeting.mvc.model.conference.*" %>
<%@page import="com.imeeting.mvc.model.conference.attendee.*" %>
<%@page import="com.imeeting.web.user.UserBean" %>
<% 
	UserBean user = (UserBean) session.getAttribute(UserBean.SESSION_BEAN);
	ConferenceModel conference = (ConferenceModel)request.getAttribute("conference"); 
	Collection<AttendeeModel> attendeeCollection = conference.getAvaliableAttendees();
%>
<!DOCTYPE html>
<html lang="zh">
  <head>
    <title>智会-会议<%=conference.getConferenceId() %></title>
	<jsp:include page="../common/_head.jsp"></jsp:include>
  </head>

  <body>
    <jsp:include page="../common/afterlogin_navibar.jsp"></jsp:include>

    <div class="container">
    	<div id="divConfTitle" class="clearfix">
    	   <div class="pull-left">
			   <h4>会议号：<%=conference.getConferenceId() %></h4>
			   <p>提示：电话拨打 0551-62379997 可以加入会议。</p>
    	   </div>
    	</div>
		<div id="divAttendeeList" class="clearfix">
			<%
				for(AttendeeModel attendee : attendeeCollection) {
						String telephoneClass = "im-icon-phone-" + attendee.getPhoneCallStatus().name();
						
	                    String phoneCallStatusText = "";
	                    if (AttendeeModel.PhoneCallStatus.Terminated.equals(attendee.getPhoneCallStatus()) ){
	                        phoneCallStatusText = "未接通";
	                    } else 
	                    if (AttendeeModel.PhoneCallStatus.Failed.equals(attendee.getPhoneCallStatus()) ){
	                        phoneCallStatusText = "呼叫失败";
	                    } else 
	                    if(AttendeeModel.PhoneCallStatus.CallWait.equals(attendee.getPhoneCallStatus()) ) {
	                        phoneCallStatusText = "正在呼叫";
	                    } else 
	                    if (AttendeeModel.PhoneCallStatus.Established.equals(attendee.getPhoneCallStatus()) ){
	                        phoneCallStatusText = "已接通";
	                    }
			%>
			<div id="div<%=attendee.getUsername()%>" class="im-attendee im-attendee-conf im-attendee-name pull-left">
				<p>
				    <span>&nbsp;<%=attendee.getDisplayName()%></span>
				</p>
				<p>
				    <i class="<%=telephoneClass%> im-icon im-phone-icon"></i>
				    <span>&nbsp;<%=attendee.getUsername()%></span><br>
				    <i class="im-icon"></i>
				    <span class="im-phone-text">&nbsp;<%=phoneCallStatusText%></span>
				</p>
			</div>
			<%
				}
			%>
		</div>
    </div> <!-- /container -->
    <div>
        <input id="iptConfId" type="hidden" value="<%=conference.getConferenceId()%>">
        <input id="iptUserId" type="hidden" value="<%=user.getUserName()%>">
    </div>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/imeeting/js/lib/jquery-1.8.0.min.js"></script>
    <script src="/imeeting/js/lib/bootstrap.min.js"></script>
    <script src="http://msg.wetalking.net/socket.io/socket.io.js"></script>
    <script src="/imeeting/js/conference.js"></script>
  </body>
</html>
