package com.noto.back.dto.request;

public record PutRequestRequest(
        Long receiverId,
        String comment,
        String status
) {
}
