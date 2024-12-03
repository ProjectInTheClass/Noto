package com.noto.back.dto.response;

import lombok.Builder;

import java.time.LocalDate;
import java.util.List;

@Builder
public record ScheduleResponse(
        Long id,
        String name,
        LocalDate startDate,
        LocalDate endDate,
        List<String> Participants,
        String description,
        String tag,
        String url
) {
}
