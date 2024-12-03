package com.noto.back.dto.request;

import java.time.LocalDate;
import java.util.List;

public record PutScheduleRequest(
        String name,
        LocalDate startDate,
        LocalDate endDate,
        List<String> participants,
        String description,
        String tag,
        String url
) {
}
