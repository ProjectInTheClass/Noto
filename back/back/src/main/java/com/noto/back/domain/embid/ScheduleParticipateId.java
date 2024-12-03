package com.noto.back.domain.embid;

import jakarta.persistence.Embeddable;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Setter
public class ScheduleParticipateId implements Serializable {
    private Long userId;
    private Long scheduleId;

    // equals() and hashCode() override
}

