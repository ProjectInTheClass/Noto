package com.noto.back.controller;


import com.noto.back.domain.Project;
import com.noto.back.dto.request.PostProjectRequest;
import com.noto.back.dto.response.*;
import com.noto.back.service.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/project")
public class ProjectController {
    private final ProjectService projectService;

    @GetMapping("/progress")
    @Operation(summary = "프로젝트 진행 현황 가져오기", description = "프로젝트 진행 현황과 정보 가져오기 (메인 페이지, 프로젝트 진행 현황,)")
    @Parameters({
            @Parameter(name = "userId", description = "사용자 ID", example = "1", required = true)
    })
    public ApiResponse<ProgressResponse> getProjectProgress(@RequestParam Long userId) {
        List<ProjectProgressResponse> projectProgressResponses = projectService.getProjectProgressByUserId(userId);
        ProgressResponse progressResponse = ProgressResponse.builder()
                .projectProgress(projectProgressResponses).
                build();
        return ApiResponse.<ProgressResponse>builder()
                .code("OK")
                .message("")
                .data(progressResponse)
                .build();
    }

    @GetMapping("/{projectId}")
    @Operation(summary = "프로젝트 상세 정보 가져오기", description = "프로젝트 상세 정보 가져오기 (프로젝트 수정 모달, 개별 프로젝트 화면)")
    public ApiResponse<ProjectResponse> getProjectInfo(@PathVariable Long projectId) {
        ProjectResponse projectResponse = projectService.getProjectInfo(projectId);
        return ApiResponse.<ProjectResponse>builder()
                .code("OK")
                .message("")
                .data(projectResponse)
                .build();
    }

    @GetMapping("/list")
    @Operation(summary = "프로젝트 리스트 가져오기", description = "프로젝트 이름 리스트 가져오기 (프로젝트 선택 모달, 리퀘스트 전송하기)")
    @Parameters({
            @Parameter(name = "userId", description = "사용자 ID", example = "1", required = true)
    })
    public ApiResponse<ProjectListResponse> getProjectList(@RequestParam Long userId) {
        ProjectListResponse projectResponses = projectService.getProjectListsByUserId(userId);

        return ApiResponse.<ProjectListResponse>builder()
                .code("OK")
                .message("")
                .data(projectResponses)
                .build();
    }

    @PostMapping("")
    @Operation(summary = "프로젝트 생성하기", description = "프로젝트 생성하기 (프로젝트 생성 모달)")
    public ApiResponse<ProjectResponse> postProject(@RequestBody PostProjectRequest request) {
        ProjectResponse projectResponse = projectService.postProject(request);

        return ApiResponse.<ProjectResponse>builder()
                .code("OK")
                .message("")
                .data(projectResponse)
                .build();
    }

    @PutMapping("/{projectId}")
    @Operation(summary = "프로젝트 수정하기", description = "프로젝트 수정하기 (프로젝트 수정 모달)")
    public ApiResponse<ProjectResponse> putProject(@RequestBody PostProjectRequest request, @PathVariable Long projectId) {
        ProjectResponse projectResponse = projectService.putProject(request, projectId);

        return ApiResponse.<ProjectResponse>builder()
                .code("OK")
                .message("")
                .data(projectResponse)
                .build();
    }

    @DeleteMapping("/{projectId}")
    @Operation(summary = "프로젝트 삭제하기", description = "프로젝트 삭제하기")
    public ApiResponse<Void> deleteProject(@PathVariable Long projectId) {
        projectService.deleteProject(projectId);

        return ApiResponse.<Void>builder()
                .code("OK")
                .message("")
                .data(null)
                .build();
    }
}
