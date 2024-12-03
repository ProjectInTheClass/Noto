package com.noto.back.dto.response;

import lombok.Builder;

@Builder
public record ApiResponse<T>(
        String code,
        String message,
        T data
) {}