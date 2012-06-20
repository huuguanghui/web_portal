package com.imeeting.mvc.model.group;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import akka.actor.UntypedActor;

import com.imeeting.beans.AttendeeBean;
import com.imeeting.beans.AttendeeBean.OnlineStatus;
import com.imeeting.framework.ContextLoader;
import com.imeeting.mvc.model.group.message.IGroupMessage;

public class GroupModel extends UntypedActor {

	private String groupId;
	private String owner;
	private String audioConfId;
	private List<AttendeeBean> attendees;

	public GroupModel(String groupId, String owner) {
		this.groupId = groupId;
		this.owner = owner;
		AttendeeBean attendee = new AttendeeBean(owner);
		attendee.setOnlineStatus(OnlineStatus.online);
		addAttendee(attendee);
	}

	public String getGroupId() {
		return this.groupId;
	}

	public String getOwner() {
		return this.owner;
	}

	public void setAudioConfId(String audioConfId) {
		this.audioConfId = audioConfId;
	}

	public String getAudioConfId() {
		return this.audioConfId;
	}

	public List<AttendeeBean> getAttendees() {
		return attendees;
	}

	public void addAttendee(AttendeeBean attendee) {
		if (attendees == null) {
			attendees = new ArrayList<AttendeeBean>();
		}
		attendees.add(attendee);
	}
	
	public void addAttendees(List<AttendeeBean> attendees) {
		if (attendees == null) {
			attendees = new ArrayList<AttendeeBean>();
		}
		this.attendees.addAll(attendees);
	}
	
	public void removeAttendee(AttendeeBean attendee) {
		if (attendees != null) {
			attendees.remove(attendee);
		}
	}
	
	public void setAttendees(List<AttendeeBean> attendees) {
		this.attendees = attendees;
	}
	
	/**
	 * find specified attendee by name
	 * @param name
	 * @return
	 */
	public AttendeeBean findAttendee(String name) {
		AttendeeBean attendee = null;
		if (attendees != null) {
			for (AttendeeBean att : attendees) {
				if (att.getName().equals(name)) {
					attendee = att;
					break;
				}
			}
		}
		return attendee;
	}

	public void tell(IGroupMessage msg) {
		getSelf().tell(msg);
	}

	public void stop() throws SQLException {
		GroupDB.close(groupId);

		GroupManager confManager = ContextLoader.getGroupManager();
		confManager.removeConference(this.groupId);

		getContext().stop(getSelf());
	}

	@Override
	public void onReceive(Object message) throws Exception {
		if (message instanceof IGroupMessage) {
			IGroupMessage confMsg = (IGroupMessage) message;
			confMsg.onReceive(this);
		} else {
			unhandled(message);
		}
	}

}