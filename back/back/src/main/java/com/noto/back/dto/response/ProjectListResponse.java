package com.noto.back.dto.response;

import lombok.Builder;

import java.util.List;

@Builder
public record ProjectListResponse(
        List<String> projectNames
) {
}
