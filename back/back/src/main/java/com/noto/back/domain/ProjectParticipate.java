package com.noto.back.domain;

import com.noto.back.domain.embid.ProjectParticipateId;
import jakarta.persistence.*;
import lombok.Setter;

@Entity
@Setter
public class ProjectParticipate {
    @EmbeddedId
    private ProjectParticipateId id;

    @ManyToOne
    @MapsId("userId")
    private User user;

    @ManyToOne
    @MapsId("projectId")
    private Project project;
}