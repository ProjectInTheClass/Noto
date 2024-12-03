package com.noto.back.dto.response;

import lombok.Builder;

import java.time.LocalDate;

@Builder
public record ScheduleInProjectResponse(
        Long id,
        String name,
        String description,
        LocalDate startDate,
        LocalDate endDate
) {
}
