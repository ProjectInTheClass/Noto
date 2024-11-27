package com.noto.back.domain.embid;

import jakarta.persistence.Embeddable;

import java.io.Serializable;

@Embeddable
public class ScheduleRequestId implements Serializable {
    private Long scheduleId;
    private Long requestId;

    // equals() and hashCode() override
}
