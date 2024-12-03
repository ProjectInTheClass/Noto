package com.noto.back.domain.embid;

import jakarta.persistence.Embeddable;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Setter
public class ScheduleRequestId implements Serializable {
    private Long scheduleId;
    private Long requestId;

    // equals() and hashCode() override
}
