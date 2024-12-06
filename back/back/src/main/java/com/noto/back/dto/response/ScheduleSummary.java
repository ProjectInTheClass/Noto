package com.noto.back.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;

@Builder
public record ScheduleSummary(
        Long id,
        String name,
        String description,
        LocalDate endDate
) {
}
