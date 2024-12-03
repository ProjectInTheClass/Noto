package com.noto.back.dto.response;

import lombok.Builder;

import java.util.List;

@Builder
public record ProgressResponse(
        List<ProjectProgressResponse> projectProgress
) {
}
