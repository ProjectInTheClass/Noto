package com.noto.back.service;

import com.noto.back.domain.*;
import com.noto.back.domain.embid.ScheduleParticipateId;
import com.noto.back.dto.request.PostScheduleRequest;
import com.noto.back.dto.request.PutScheduleRequest;
import com.noto.back.dto.response.ScheduleInProjectResponse;
import com.noto.back.dto.response.ScheduleResponse;
import com.noto.back.dto.response.ScheduleSummary;
import com.noto.back.dto.response.TodayScheduleResponse;
import com.noto.back.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class ScheduleService {
    private final ScheduleRepository scheduleRepository;
    private final ProjectRepository projectRepository;
    private final ScheduleParticipateRepository scheduleParticipateRepository;
    private final UserRepository userRepository;

    public TodayScheduleResponse getTodayScheduleResponse(Long userId) {
        // 오늘 날짜의 일정을 조회
        List<Schedule> todaySchedules = scheduleRepository.findSchedulesByUserIdAndDate(userId, LocalDate.now());

        // Schedule -> ScheduleSummary 변환
        List<ScheduleSummary> summaries = todaySchedules.stream()
                .map(schedule -> ScheduleSummary.builder()
                        .name(schedule.getName())
                        .description(schedule.getDescription())
                        .endDate(schedule.getEndDate())
                        .build())
                .collect(Collectors.toList());

        // TodayScheduleResponse 생성 및 반환
        return TodayScheduleResponse.builder()
                .todaySchedule(summaries)
                .build();
    }

    public List<ScheduleInProjectResponse> getScheduleOfTheProject(Long projectId) {
        List<Schedule> schedules = scheduleRepository.findSchedulesOfTheProject(projectId);

        return schedules.stream()
                .map(schedule -> ScheduleInProjectResponse.builder()
                        .id(schedule.getId())
                        .name(schedule.getName())
                        .description(schedule.getDescription())
                        .startDate(schedule.getStartDate())
                        .endDate(schedule.getEndDate())
                        .build())
                .collect(Collectors.toList());
    }

    public List<ScheduleInProjectResponse> getMonthlyScheduleOfTheProject(Long projectId, Integer year, Integer month) {
        // 프로젝트의 일정을 가져옴
        List<Schedule> schedules = scheduleRepository.findSchedulesOfTheProject(projectId);

        // 해당 월의 첫날과 마지막 날을 계산
        LocalDate currentMonthStart = LocalDate.of(year, month, 1);
        LocalDate currentMonthEnd = currentMonthStart.withDayOfMonth(currentMonthStart.lengthOfMonth());

        return schedules.stream()
                .map(schedule -> {
                    LocalDate startDate = schedule.getStartDate();
                    LocalDate endDate = schedule.getEndDate();

                    // 날짜 범위가 이번 달과 교집합이 없으면 필터링하여 제외
                    if (endDate.isBefore(currentMonthStart) || startDate.isAfter(currentMonthEnd)) {
                        // 교집합이 없으면 해당 일정을 리스트에 추가하지 않음
                        return null;
                    }

                    // 날짜 수정 로직 적용 (교집합 범위로 수정)
                    LocalDate modifiedStartDate = startDate.isBefore(currentMonthStart) ? currentMonthStart : startDate;
                    LocalDate modifiedEndDate = endDate.isAfter(currentMonthEnd) ? currentMonthEnd : endDate;

                    // 교집합이 있을 경우, 수정된 범위로 응답 생성
                    return ScheduleInProjectResponse.builder()
                            .name(schedule.getName())
                            .description(schedule.getDescription())
                            .startDate(modifiedStartDate)
                            .endDate(modifiedEndDate)
                            .id(schedule.getId())
                            .build();
                })
                .filter(Objects::nonNull)  // null 값은 제외하고 필터링
                .collect(Collectors.toList());
    }


    public ScheduleResponse getScheduleInfo(Long scheduleId) {
        List<Object[]> results = scheduleRepository.getScheduleInfo(scheduleId);

        Object[] result = results.get(0);
        // 결과 매핑
        String name = (String) result[0];
        LocalDate startDate = (LocalDate) result[1];
        LocalDate endDate = (LocalDate) result[2];
        String description = (String) result[3];
        String tag = (String) result[4];
        String url = (String) result[5];
        String participantNames = (String) result[6];
        Long id = (Long) result[7];

        // 참가자 이름을 쉼표로 나누어 리스트로 변환
        List<String> participants = Arrays.asList(participantNames.split(","));

        // ScheduleResponse 생성
        return ScheduleResponse.builder()
                .id(id)
                .name(name)
                .startDate(startDate)
                .endDate(endDate)
                .description(description)
                .tag(tag)
                .url(url)
                .Participants(participants)
                .build();
    }

    public ScheduleResponse postSchedule(PostScheduleRequest request) {
        Project project = projectRepository.findById(request.projectId())
                .orElseThrow(() -> new RuntimeException(""));

        Schedule schedule = new Schedule();

        schedule.setName(request.name());
        schedule.setStartDate(request.startDate());
        schedule.setEndDate(request.endDate());
        schedule.setDescription(request.description());
        schedule.setTag(request.tag());
        schedule.setUrl(request.url());
        schedule.setProject(project);

        Schedule savedSchedule = scheduleRepository.save(schedule);

        List<String> names = new ArrayList<>();
        for (String name : request.participants()) {
            User user = userRepository.findUserByProjectIdAndUserName(request.projectId(), name);

            if (user == null) continue;

            ScheduleParticipate ss = new ScheduleParticipate();
            ScheduleParticipateId id = new ScheduleParticipateId();
            id.setScheduleId(savedSchedule.getId());
            id.setUserId(user.getId());
            ss.setId(id);

            // @ManyToOne 필드 설정
            ss.setSchedule(savedSchedule);
            ss.setUser(user);

            names.add(user.getName());
            // ScheduleParticipateId는 JPA가 @MapsId로 자동 생성
            scheduleParticipateRepository.save(ss);
        }

        return ScheduleResponse.builder()
                .id(savedSchedule.getId())
                .name(savedSchedule.getName())
                .startDate(savedSchedule.getStartDate())
                .endDate(savedSchedule.getEndDate())
                .description(savedSchedule.getDescription())
                .tag(savedSchedule.getTag())
                .url(savedSchedule.getUrl())
                .Participants(names)
                .build();
    }

    public ScheduleResponse putSchedule(PutScheduleRequest request, Long scheduleId) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException(""));

        schedule.setName(request.name());
        schedule.setDescription(request.description());
        schedule.setStartDate(request.startDate());
        schedule.setEndDate(request.endDate());
        schedule.setTag(request.tag());
        schedule.setUrl(request.url());

        Schedule savedSchedule = scheduleRepository.save(schedule);
        List<String> names = new ArrayList<>();

        scheduleParticipateRepository.deleteByScheduleId(scheduleId);
        for (String name : request.participants()) {
            User user = userRepository.findUserByProjectIdAndUserName(savedSchedule.getProject().getId(), name);

            if (user == null) continue;

            ScheduleParticipate ss = new ScheduleParticipate();
            ScheduleParticipateId id = new ScheduleParticipateId();
            id.setScheduleId(savedSchedule.getId());
            id.setUserId(user.getId());
            ss.setId(id);

            // @ManyToOne 필드 설정
            ss.setSchedule(savedSchedule);
            ss.setUser(user);
            names.add(user.getName());
            // ScheduleParticipateId는 JPA가 @MapsId로 자동 생성
            scheduleParticipateRepository.save(ss);
        }

        return ScheduleResponse.builder()
                .id(savedSchedule.getId())
                .name(savedSchedule.getName())
                .startDate(savedSchedule.getStartDate())
                .endDate(savedSchedule.getEndDate())
                .description(savedSchedule.getDescription())
                .tag(savedSchedule.getTag())
                .url(savedSchedule.getUrl())
                .Participants(names)
                .build();
    }

    public Void deleteById(Long scheduleId) {
        scheduleRepository.deleteById(scheduleId);
        return null;

    }
}
