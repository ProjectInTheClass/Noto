package com.noto.back.dto.response;

import lombok.Builder;

@Builder
public record RequestListResponse(
        Long requestId,
        String title,
        String sender
) {
}
