package com.noto.back.domain;

import com.noto.back.domain.embid.RequestReceiveId;
import jakarta.persistence.*;

@Entity
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
    private boolean readOrNot;
    private String comment;
}


