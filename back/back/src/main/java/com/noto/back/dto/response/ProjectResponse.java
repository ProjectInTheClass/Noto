package com.noto.back.dto.response;

import lombok.Builder;
import org.springframework.cglib.core.Local;

import java.time.LocalDate;
import java.util.List;

@Builder
public record ProjectResponse(
        Long id,
        String name,
        LocalDate startDate,
        LocalDate endDate,
        List<String> participants,
        String description,
        String url,
        String imageurl
) {
}
