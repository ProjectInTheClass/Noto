package com.noto.back.controller;

import com.noto.back.dto.request.PostScheduleRequest;
import com.noto.back.dto.request.PutScheduleRequest;
import com.noto.back.dto.response.ApiResponse;
import com.noto.back.dto.response.ScheduleInProjectResponse;
import com.noto.back.dto.response.ScheduleResponse;
import com.noto.back.dto.response.TodayScheduleResponse;
import com.noto.back.repository.ScheduleRepository;
import com.noto.back.service.ScheduleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/schedule")
public class ScheduleController {
    private final ScheduleService scheduleService;
    private final ScheduleRepository scheduleRepository;

    @GetMapping("/today")
    @Operation(summary = "오늘 내 할일 가져오기", description = "오늘 내 할일(일정) 가져오기")
    @Parameters({
            @Parameter(name = "userId", description = "사용자 ID", example = "1", required = true)
    })
    public ApiResponse<TodayScheduleResponse> getTodaySchedule(@RequestParam Long userId) {
        TodayScheduleResponse todayScheduleResponse = scheduleService.getTodayScheduleResponse(userId);
        return ApiResponse.<TodayScheduleResponse>builder()
                .code("OK")
                .message("")
                .data(todayScheduleResponse)
                .build();
    }

    @GetMapping("/project/{projectId}")
    @Operation(summary = "프로젝트 내의 일정 가져오기", description = "프로젝트 내의 일정 가져오기")
    public ApiResponse<List<ScheduleInProjectResponse>> getSchedulesInProject(@PathVariable Long projectId) {
        List<ScheduleInProjectResponse> scheduleInProjectResponses = scheduleService.getScheduleOfTheProject(projectId);
        return ApiResponse.<List<ScheduleInProjectResponse>>builder()
                .code("OK")
                .message("")
                .data(scheduleInProjectResponses)
                .build();
    }

    @GetMapping("/info/{scheduleId}")
    @Operation(summary = "일정 상세 정보 가져오기", description = "일정 상세 정보 가져오기")
    public ApiResponse<ScheduleResponse> getScheduleInfo(@PathVariable Long scheduleId) {
        ScheduleResponse scheduleResponse = scheduleService.getScheduleInfo(scheduleId);
        return ApiResponse.<ScheduleResponse>builder()
                .code("OK")
                .message("")
                .data(scheduleResponse)
                .build();
    }

    @GetMapping("/monthly/{projectId}")
    @Operation(summary = "프로젝트 내의 한달 간의 일정 가져오기", description = "프로젝트 내의 한달 간의 일정 가져오기")
    @Parameters({
            @Parameter(name = "year", description = "년", example = "2024", required = true),
            @Parameter(name = "month", description = "월", example = "12", required = true)
    })
    public ApiResponse<List<ScheduleInProjectResponse>> getMonthlySchedulesInProject(@PathVariable Long projectId, @RequestParam Integer year, @RequestParam Integer month) {
        List<ScheduleInProjectResponse> scheduleInProjectResponses = scheduleService.getMonthlyScheduleOfTheProject(projectId, year, month);
        return ApiResponse.<List<ScheduleInProjectResponse>>builder()
                .code("OK")
                .message("")
                .data(scheduleInProjectResponses)
                .build();
    }

    @PostMapping("")
    @Operation(summary = "프로젝트 내 일정 생성하기", description = "프로젝트 내 일정 생성하기")
    public ApiResponse<ScheduleResponse> postSchedule(@RequestBody PostScheduleRequest request) {
        ScheduleResponse response = scheduleService.postSchedule(request);
        return ApiResponse.<ScheduleResponse>builder()
                .code("OK")
                .message("")
                .data(response)
                .build();
    }

    @PutMapping("/{scheduleId}")
    @Operation(summary = "프로젝트 내 일정 수정하기" , description = "프로젝트 내 일정 수정하기")
    public ApiResponse<ScheduleResponse> putSchedule(@RequestBody PutScheduleRequest request, @PathVariable Long scheduleId) {
        ScheduleResponse response = scheduleService.putSchedule(request, scheduleId);
        return ApiResponse.<ScheduleResponse>builder()
                .code("OK")
                .message("")
                .data(response)
                .build();
    }

    @DeleteMapping("/{scheduleId}")
    @Operation(summary = "프로젝트 내 일정 삭제하기" , description = "프로젝트 내 일정 삭제하기")
    public ApiResponse<Void> deleteSchedule(@PathVariable Long scheduleId) {
        scheduleService.deleteById(scheduleId);
        return ApiResponse.<Void>builder()
                .code("OK")
                .message("")
                .data(null)
                .build();
    }
}

