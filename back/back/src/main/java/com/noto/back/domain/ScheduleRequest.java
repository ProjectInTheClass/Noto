package com.noto.back.domain;

import com.noto.back.domain.embid.ScheduleRequestId;
import jakarta.persistence.*;

@Entity
public class ScheduleRequest {
    @EmbeddedId
    private ScheduleRequestId id;

    @ManyToOne
    @MapsId("scheduleId")
    private Schedule schedule;

    @ManyToOne
    @MapsId("requestId")
    private Request request;
}



