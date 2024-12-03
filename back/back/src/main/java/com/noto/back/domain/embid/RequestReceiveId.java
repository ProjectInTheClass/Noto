package com.noto.back.domain.embid;

import jakarta.persistence.Embeddable;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Setter
public class RequestReceiveId implements Serializable {
    private Long userId;
    private Long requestId;

    // equals() and hashCode() override
}