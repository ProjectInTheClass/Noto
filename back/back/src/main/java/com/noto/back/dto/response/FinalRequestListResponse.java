package com.noto.back.dto.response;

import lombok.Builder;

import java.util.List;

@Builder
public record FinalRequestListResponse(
        List<RequestListResponse> sendRequest,
        List<RequestListResponse> receiveRequest
) {
}
