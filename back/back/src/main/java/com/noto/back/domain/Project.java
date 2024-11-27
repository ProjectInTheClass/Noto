package com.noto.back.domain;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String image;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    private String url;

    // Relationships
    @OneToMany(mappedBy = "project")
    private List<Schedule> schedules = new ArrayList<>();

    @OneToMany(mappedBy = "project")
    private List<ProjectParticipate> participants = new ArrayList<>();
}
