package com.noto.back.domain;

import com.noto.back.domain.embid.ScheduleRequestId;
import jakarta.persistence.*;
import lombok.Setter;

@Entity
@Setter
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



