package com.noto.back.dto.request;

import lombok.Builder;

import java.time.LocalDate;

@Builder
public record PostProjectRequest(
        String name,
        LocalDate startDate,
        LocalDate endDate,
        String description,
        String image
) {
}
