package com.noto.back.domain.embid;


import jakarta.persistence.Embeddable;

import java.io.Serializable;

@Embeddable
public class ProjectParticipateId implements Serializable {
    private Long userId;
    private Long projectId;

    // equals() and hashCode() override
}