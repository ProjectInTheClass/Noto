package com.noto.back.controller;

import com.noto.back.dto.request.PostRequestRequest;
import com.noto.back.dto.request.PutRequestRequest;
import com.noto.back.dto.response.*;
import com.noto.back.service.RequestService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import lombok.Builder;
import lombok.RequiredArgsConstructor;

import org.apache.coyote.RequestInfo;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/request")
public class RequestController {
    private final RequestService requestService;

    @GetMapping("/number")
    @Operation(summary = "리퀘스트 수량 가져오기", description = "리퀘스트 알림 수 가져오기 (메인 페이지, 개별 프로젝트 화면)")
    @Parameters({
            @Parameter(name = "userId", description = "사용자 ID", example = "1", required = true)
    })
    public ApiResponse<RequestNumberResponse> getNumberOfRequest(@RequestParam(required = true) Long userId) {
        RequestNumberResponse numberOfRequests = requestService.getNumberOfRequests(userId);
        return ApiResponse.<RequestNumberResponse>builder()
                .code("OK")
                .message("")
                .data(numberOfRequests)
                .build();
    }

    @GetMapping("/info/{requestId}")
    @Operation(summary = "리퀘스트 상세 정보 가져오기", description = "리퀘스트 상세 정보 가져오기(리퀘스트 확인 모달)")
    @Parameters({
            @Parameter(name = "userId", description = "사용자 ID", example = "1", required = true)
    })
    public ApiResponse<RequestInfoResponse> getRequestInfo(@PathVariable Long requestId, @RequestParam Long userId) {
        RequestInfoResponse requestInfoResponse = requestService.getRequestInfo(requestId, userId);
        return ApiResponse.<RequestInfoResponse>builder()
                .code("OK")
                .message("")
                .data(requestInfoResponse)
                .build();
    }

    @GetMapping("/list")
    @Operation(summary = "리퀘스트 리스트 가져오기", description = "리퀘스트 리스트와 정보 가져오기 (리퀘스트 페이지)")
    @Parameters({
            @Parameter(name = "userId", description = "사용자 ID", example = "1", required = true)
    })
    public ApiResponse<FinalRequestListResponse> getRequestList(@RequestParam Long userId) {
        FinalRequestListResponse requestResponses = requestService.getRequestList(userId);

        return ApiResponse.<FinalRequestListResponse>builder()
                .code("OK")
                .message("")
                .data(requestResponses).build();
    }

    @PostMapping("")
    @Operation(summary = "리퀘스트 생성하기", description = "리퀘스트 생성하기 (리퀘스트 전송하기)")
    public ApiResponse<RequestInfoResponse> postRequest(@RequestBody PostRequestRequest request) {
        RequestInfoResponse requestInfoResponse = requestService.postRequest(request);

        return ApiResponse.<RequestInfoResponse>builder()
                .code("OK")
                .message("")
                .data(requestInfoResponse).build();
    }

    @PatchMapping("/{requestId}")
    @Operation(summary = "리퀘스트 응답하기", description = "리퀘스트 응답하기 (리퀘스트 응답 모달)")
    public ApiResponse<Void> putRequest(@RequestBody PutRequestRequest request, @RequestParam Long requestId) {
        requestService.putRequest(request, requestId);

        return ApiResponse.<Void>builder()
                .code("OK")
                .message("")
                .data(null)
                .build();
    }
}
