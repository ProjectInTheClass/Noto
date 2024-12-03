package com.noto.back.dto.response;

import lombok.Builder;

@Builder
public record ParticipantName(
        String name
) {
}
