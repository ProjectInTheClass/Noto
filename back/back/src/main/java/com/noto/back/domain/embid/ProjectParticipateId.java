package com.noto.back.domain.embid;


import jakarta.persistence.Embeddable;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Setter
public class ProjectParticipateId implements Serializable {
    private Long userId;
    private Long projectId;

    // equals() and hashCode() override
}