package com.noto.back.controller;

import com.noto.back.dto.request.PostParticipateRequest;
import com.noto.back.dto.response.ApiResponse;
import com.noto.back.dto.response.UserResponse;
import com.noto.back.service.ProjectParticipateService;
import com.noto.back.service.ScheduleService;
import com.noto.back.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;
    private final ProjectParticipateService projectParticipateService;

    @GetMapping("/{userId}")
    @Operation(summary = "유저 정보 가져오기", description = "유저 정보 가져오기")
    public ApiResponse<UserResponse> getUserInfoById(@PathVariable Long userId) {
        UserResponse userResponse = userService.getUserInfoById(userId);
        return ApiResponse.<UserResponse>builder()
                .code("OK")
                .message("")
                .data(userResponse).build();
    }

    @PostMapping("/participate")
    @Operation(summary = "유저 프로젝트 참가", description = "유저가 프로젝트에 참가")
    public ApiResponse<Void> userParticipateProject(@RequestBody PostParticipateRequest postParticipateRequest) {
        projectParticipateService.addParticipate(postParticipateRequest.userId(), postParticipateRequest.projectId());
        return ApiResponse.<Void>builder()
                .code("OK")
                .message("")
                .data(null).build();
    }
}
