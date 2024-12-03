package com.noto.back.dto.request;

public record PostParticipateRequest(
        Long userId,
        Long projectId
) {
}
