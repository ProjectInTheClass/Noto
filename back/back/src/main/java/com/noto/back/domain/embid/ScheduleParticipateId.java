package com.noto.back.domain.embid;

import jakarta.persistence.Embeddable;

import java.io.Serializable;

@Embeddable
public class ScheduleParticipateId implements Serializable {
    private Long userId;
    private Long scheduleId;

    // equals() and hashCode() override
}

