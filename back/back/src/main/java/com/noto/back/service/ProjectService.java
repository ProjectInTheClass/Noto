package com.noto.back.service;

import com.noto.back.domain.Project;
import com.noto.back.dto.request.PostProjectRequest;
import com.noto.back.dto.response.*;
import com.noto.back.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cglib.core.Local;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class ProjectService {
    private final ProjectRepository projectRepository;

    public List<ProjectProgressResponse> getProjectProgressByUserId(Long userId) {
        List<Object[]> results = projectRepository.findProjectProgressByUserId(userId);
        List<ProjectProgressResponse> responseList = new ArrayList<>();

        for (Object[] result : results) {
            String name = (String) result[0];
            Integer progress = (Integer) result[1];
            Integer daysRemaining = (Integer) result[2];
            List<String> userNames = Arrays.asList(((String) result[3]).split(","));

            LocalDate startDate = (LocalDate) result[4];
            LocalDate endDate = (LocalDate) result[5];
            Long id = (Long) result[6];
            ProjectProgressResponse response = new ProjectProgressResponse(
                    id, name, progress, daysRemaining, userNames, startDate, endDate
            );
            responseList.add(response);
        }

        return responseList;
    }

    public ProjectResponse getProjectInfo(Long projectId) {
        List<Object[]> results = projectRepository.getProjectInfo(projectId);

        Object[] result = results.get(0);

        String name = (String) result[0];
        LocalDate startDate = (LocalDate) result[1];
        LocalDate endDate = (LocalDate) result[2];
        List<String> userNames = Arrays.asList(((String) result[3]).split(","));
        String description = (String) result[4];
        String url = (String) result[5];
        String image = (String) result[6];
        Long id = (Long) result[7];
        return ProjectResponse.builder()
                .id(id)
                .name(name)
                .startDate(startDate)
                .endDate(endDate)
                .participants(userNames)
                .description(description)
                .url(url)
                .imageurl(image)
                .build();
    }

    public ProjectListResponse getProjectListsByUserId(Long userId) {
        List<Object[]> projectListEntities = projectRepository.findProjectNamesByUserId(userId);

        List<ProjectListEntity> projects = projectListEntities.stream()
                .map(result -> new ProjectListEntity(
                        (String) result[0], // 이름
                        (Long) result[1]    // ID
                ))
                .collect(Collectors.toList());

        return ProjectListResponse.builder()
                .projects(projects)
                .build();
    }

    public ProjectResponse postProject(PostProjectRequest request) {
        Project project = new Project();
        project.setName(request.name());
        project.setDescription(request.description());
        project.setImage(request.image());
        project.setStartDate(request.startDate());
        project.setEndDate(request.endDate());

        // 프로젝트 저장
        Project savedProject = projectRepository.save(project);

        // 저장된 프로젝트 ID를 기반으로 URL 설정
        String projectUrl = "http://localhost:3306/api/project/" + savedProject.getId();
        savedProject.setUrl(projectUrl);

        Project completeProject = projectRepository.save(savedProject); // URL이 설정된 상태로 다시 저장

        return ProjectResponse.builder()
                .id(completeProject.getId())
                .name(completeProject.getName())
                .description(completeProject.getDescription())
                .imageurl(completeProject.getImage())
                .url(completeProject.getUrl())
                .participants(null)
                .startDate(completeProject.getStartDate())
                .endDate(completeProject.getEndDate())
                .build();
    }

    public ProjectResponse putProject(PostProjectRequest request, Long projectId) {
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new RuntimeException(""));
        project.setName(request.name());
        project.setDescription(request.description());
        project.setImage(request.image());
        project.setStartDate(request.startDate());
        project.setEndDate(request.endDate());

        // 프로젝트 저장
        Project completeProject = projectRepository.save(project);
        String participantsName = projectRepository.getParticipantsName(projectId);
        List<String> participants;
        if (participantsName == null) participants = null;
        else {
             participants = Arrays.asList(participantsName.split(","));
        }

        return ProjectResponse.builder()
                .id(completeProject.getId())
                .name(completeProject.getName())
                .description(completeProject.getDescription())
                .imageurl(completeProject.getImage())
                .url(completeProject.getUrl())
                .participants(participants)
                .startDate(completeProject.getStartDate())
                .endDate(completeProject.getEndDate())
                .build();
    }

    public Void deleteProject(Long projectId) {
        projectRepository.deleteById(projectId);
        return null;
    }
}
