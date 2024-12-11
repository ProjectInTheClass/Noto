package com.noto.back.service;

import com.noto.back.domain.*;
import com.noto.back.domain.embid.RequestReceiveId;
import com.noto.back.domain.embid.ScheduleParticipateId;
import com.noto.back.domain.embid.ScheduleRequestId;
import com.noto.back.dto.request.PostRequestRequest;
import com.noto.back.dto.request.PutRequestRequest;
import com.noto.back.dto.response.*;
import com.noto.back.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.cglib.core.Local;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PatchMapping;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@RequiredArgsConstructor
@Service
public class RequestService {
    private final RequestReceiveRepository requestReceiveRepository;
    private final RequestRepository requestRepository;
    private final UserRepository userRepository;
    private final ProjectRepository projectRepository;
    private final ScheduleRequestRepository scheduleRequestRepository;
    private final ScheduleRepository scheduleRepository;

    public RequestNumberResponse getNumberOfRequests(Long userId) {
        Long numberOfRequests = requestReceiveRepository.countByUserIdAndReadOrNotFalse(userId);

        return RequestNumberResponse.builder()
                .numberOfRequest(numberOfRequests)
                .build();
    }

    public RequestInfoResponse getRequestInfo(Long requestId, Long userId) {
        requestReceiveRepository.updateReadOrNot(requestId, userId);

        User tempUser = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User Not Found"));

        List<Object[]> results = requestRepository.getRequestInfo(requestId);

        Object[] result = results.get(0);

        String projectName = (String) result[0];
        LocalDate startDate = (LocalDate)result[1];
        LocalDate endDate = (LocalDate) result[2];
        String title = (String) result[3];
        String content = (String) result[4];
        String senderName = (String) result[5];
        String receiverNames = (String) result[6];
        String scheduleName = (String) result[7]; // 일정 이름
        List<String> receivers = new ArrayList<>();
        if (receiverNames != null) {
            receivers = Arrays.asList(receiverNames.split(","));
        }
        Long id = (Long)result[8];
        Boolean isSender = false;
        if (tempUser.getName().equals(senderName)) {
            isSender = true;
        }
        return RequestInfoResponse.builder()
                .id(id)
                .project(projectName)
                .schedule(scheduleName)
                .content(content)
                .title(title)
                .startDate(startDate)
                .endDate(endDate)
                .receivers(receivers)
                .sender(senderName)
                .isSender(isSender)
                .build();
    }

    public FinalRequestListResponse getRequestList(Long userId) {
        List<Object[]> results = requestRepository.findRequestInfoByReceiverId(userId);
        List<RequestListResponse> receiveRequest = new ArrayList<>();
        for (Object[] result: results) {
            receiveRequest.add(RequestListResponse.builder()
                    .title((String) result[0])
                    .sender((String) result[1])
                    .requestId((Long) result[2])
                    .build());
        }

        List<Object[]> sendResults = requestRepository.findBySenderId(userId);
        List<RequestListResponse> sendRequest = new ArrayList<>();
        for (Object[] result: sendResults) {
            sendRequest.add(RequestListResponse.builder()
                    .title((String) result[0])
                    .sender((String) result[1])
                    .requestId((Long) result[2])
                    .build());
        }

        return FinalRequestListResponse.builder()
                .sendRequest(sendRequest)
                .receiveRequest(receiveRequest).build();
    }

    public RequestInfoResponse postRequest(PostRequestRequest request) {
        Request request1 = new Request();

        User user = userRepository.findById(request.sender())
                .orElseThrow(() -> new RuntimeException(""));
        Project project = projectRepository.findById(request.projectId())
                .orElseThrow(() -> new RuntimeException(""));
        request1.setTitle(request.title());
        request1.setContent(request.content());
        request1.setSender(user);
        request1.setProject(project);

        Request savedRequest = requestRepository.save(request1);

        List<String> names = new ArrayList<>();
        for (String name : request.receivers()) {
            User tempUser = userRepository.findUserByProjectIdAndUserName(request.projectId(), name);

            if (tempUser == null) continue;

            RequestReceive rr = new RequestReceive();
            RequestReceiveId id = new RequestReceiveId();
            id.setRequestId(savedRequest.getId());
            id.setUserId(tempUser.getId());

            rr.setRequest(savedRequest);
            rr.setComment("");
            rr.setStatus("");
            rr.setReceiver(tempUser);
            rr.setReadOrNot(false);
            rr.setId(id);

            names.add(tempUser.getName());

            requestReceiveRepository.save(rr);
        }
        Schedule schedule = new Schedule();
        if (request.scheduleId() != null) {
            schedule = scheduleRepository.findById(request.scheduleId())
                    .orElseThrow(() -> new RuntimeException(""));
            ScheduleRequest sr = new ScheduleRequest();
            ScheduleRequestId id = new ScheduleRequestId();


            id.setRequestId(savedRequest.getId());
            id.setScheduleId(request.scheduleId());

            sr.setRequest(savedRequest);
            sr.setSchedule(schedule);
            sr.setId(id);

            scheduleRequestRepository.save(sr);
        }

        return RequestInfoResponse.builder()
                .id(savedRequest.getId())
                .title(savedRequest.getTitle())
                .sender(savedRequest.getSender().getName())
                .receivers(names)
                .startDate(savedRequest.getProject().getStartDate())
                .endDate(savedRequest.getProject().getEndDate())
                .content(savedRequest.getContent())
                .project(savedRequest.getProject().getName())
                .schedule(schedule.getName())
                .build();
    }

    public Void putRequest(PutRequestRequest request, Long requestId) {
        RequestReceive rr = requestReceiveRepository.findByIds(request.receiverId(), requestId);

        rr.setStatus(request.status());
        rr.setComment(request.comment());

        requestReceiveRepository.save(rr);
        return null;
    }

    public List<RequestReceiveResponse> getRRsByRequestId(Long requestId) {
        List<Object[]> results = requestReceiveRepository.findByRequestId(requestId);
        return results.stream()
                .map(row -> new RequestReceiveResponse(
                        (String) row[2], // status
                        (String) row[1], // comment
                        (String) row[0]  // receiverName
                ))
                .toList();

    }
}
