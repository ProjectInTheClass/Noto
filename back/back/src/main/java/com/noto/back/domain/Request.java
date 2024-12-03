package com.noto.back.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Setter
@Getter
public class Request {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String content;

    // Relationships
    @ManyToOne
    @JoinColumn(name = "project_id")
    private Project project;

    @ManyToOne
    @JoinColumn(name = "sender_id")
    private User sender;

    @OneToMany(mappedBy = "request" , cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RequestReceive> requestReceives = new ArrayList<>();

    @OneToMany(mappedBy = "request", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ScheduleRequest> scheduleRequests = new ArrayList<>();
}

