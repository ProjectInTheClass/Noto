package com.noto.back.domain;

import com.noto.back.domain.embid.ScheduleParticipateId;
import jakarta.persistence.*;

@Entity
public class ScheduleParticipate {
    @EmbeddedId
    private ScheduleParticipateId id;

    @ManyToOne
    @MapsId("userId")
    private User user;

    @ManyToOne
    @MapsId("scheduleId")
    private Schedule schedule;
}

