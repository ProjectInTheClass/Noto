package com.noto.back.dto.response;

import lombok.Builder;

import java.util.List;

@Builder
public record TodayScheduleResponse(
        List<ScheduleSummary> todaySchedule
) {
}
