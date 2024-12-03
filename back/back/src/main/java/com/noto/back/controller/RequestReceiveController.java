package com.noto.back.controller;

import com.noto.back.domain.RequestReceive;
import com.noto.back.dto.response.ApiResponse;
import com.noto.back.dto.response.RequestReceiveResponse;
import com.noto.back.service.RequestService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/request_receive")
public class RequestReceiveController {
    private final RequestService requestService;

    @GetMapping("/{requestId}")
    @Operation(summary = "특정 리퀘스트에 대한 응답 모두 가져오기", description = "특정 리퀘스트에 대한 응답 모두 가져오기")
    public ApiResponse<List<RequestReceiveResponse>> getRRs(@PathVariable Long requestId) {
        List<RequestReceiveResponse> requestReceiveResponses = requestService.getRRsByRequestId(requestId);

        return ApiResponse.<List<RequestReceiveResponse>>builder()
                .code("OK")
                .message("")
                .data(requestReceiveResponses)
                .build();
    }
}
