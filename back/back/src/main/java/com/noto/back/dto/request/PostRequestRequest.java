package com.noto.back.dto.request;

import java.util.List;

public record PostRequestRequest(
        Long projectId,
        Long scheduleId,
        List<String> receivers,
        Long sender,
        String title,
        String content
) {
}
