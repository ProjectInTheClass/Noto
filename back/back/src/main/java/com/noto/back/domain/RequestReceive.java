package com.noto.back.domain;

import com.noto.back.domain.embid.RequestReceiveId;
import jakarta.persistence.*;
import lombok.Setter;

@Entity
@Setter
public class RequestReceive {
    @EmbeddedId
    private RequestReceiveId id;

    @ManyToOne
    @MapsId("userId")
    private User receiver;

    @ManyToOne
    @MapsId("requestId")
    private Request request;

    private String status;
    private Boolean readOrNot;
    private String comment;
}


