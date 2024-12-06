package com.noto.back.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import org.springframework.cglib.core.Local;

import java.beans.ConstructorProperties;
import java.time.LocalDate;
import java.util.List;

@Builder
@Getter
@AllArgsConstructor
public class ProjectProgressResponse {
    private Long id;
    private String name;
    private Integer progress;
    private Integer dDay;
    private List<String> participants;
    private LocalDate startDate;
    private LocalDate endDate;
}

