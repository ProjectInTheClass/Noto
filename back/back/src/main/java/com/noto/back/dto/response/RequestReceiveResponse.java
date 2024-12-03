package com.noto.back.dto.response;

public record RequestReceiveResponse(
        String receiverName,
        String comment,
        String status
) {
}
