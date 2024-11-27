package com.noto.back.domain.embid;

import jakarta.persistence.Embeddable;

import java.io.Serializable;

@Embeddable
public class RequestReceiveId implements Serializable {
    private Long userId;
    private Long requestId;

    // equals() and hashCode() override
}