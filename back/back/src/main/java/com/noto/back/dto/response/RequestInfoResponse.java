package com.noto.back.dto.response;

import lombok.Builder;
import org.springframework.cglib.core.Local;

import java.time.LocalDate;
import java.util.List;

@Builder
public record RequestInfoResponse(
        Long id,
        String project,
        String schedule,
        LocalDate startDate,
        LocalDate endDate,
        List<String> receivers,
        String sender,
        String title,
        String content,
        Boolean isSender
) {
}
