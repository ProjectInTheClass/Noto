package com.noto.back.dto.response;

import lombok.Builder;

@Builder
public record RequestListResponse(
        String title,
        String sender
) {
}
