package com.noto.back.dto.response;

import lombok.Builder;

import java.time.LocalDate;

@Builder
public record UserResponse(
        String name,
        String email,
        LocalDate createdDate,
        LocalDate lastLogin
) {
}
