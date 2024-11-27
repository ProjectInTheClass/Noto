package com.noto.back.domain;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String password;
    private String name;
    private String email;
    private String image;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    // Relationships
    @OneToMany(mappedBy = "user")
    private List<ProjectParticipate> projectParticipates = new ArrayList<>();

    @OneToMany(mappedBy = "user")
    private List<ScheduleParticipate> scheduleParticipates = new ArrayList<>();

    @OneToMany(mappedBy = "sender")
    private List<Request> sentRequests = new ArrayList<>();

    @OneToMany(mappedBy = "receiver")
    private List<RequestReceive> receivedRequests = new ArrayList<>();
}
