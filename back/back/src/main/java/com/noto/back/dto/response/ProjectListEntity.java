package com.noto.back.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
public record ProjectListEntity(
        String name,
        Long projectId,
        String description
) {
}
