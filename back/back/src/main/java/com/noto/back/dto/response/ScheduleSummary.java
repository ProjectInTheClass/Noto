package com.noto.back.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;

@Builder
public record ScheduleSummary(
        String name,
        String description,
        LocalDate endDate
) {
}
