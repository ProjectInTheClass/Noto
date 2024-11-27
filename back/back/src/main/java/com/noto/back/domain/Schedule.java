package com.noto.back.domain;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String tag;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    private String url;

    // Relationships
    @ManyToOne
    @JoinColumn(name = "project_id")
    private Project project;

    @OneToMany(mappedBy = "schedule")
    private List<ScheduleParticipate> participants = new ArrayList<>();

    @OneToMany(mappedBy = "schedule")
    private List<ScheduleRequest> scheduleRequests = new ArrayList<>();
}
