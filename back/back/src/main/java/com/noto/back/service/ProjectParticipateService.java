package com.noto.back.service;

import com.noto.back.domain.Project;
import com.noto.back.domain.ProjectParticipate;
import com.noto.back.domain.User;
import com.noto.back.domain.embid.ProjectParticipateId;
import com.noto.back.dto.request.PostParticipateRequest;
import com.noto.back.repository.ProjectParticipateRepository;
import com.noto.back.repository.ProjectRepository;
import com.noto.back.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ProjectParticipateService {
    private final ProjectParticipateRepository projectParticipateRepository;
    private final UserRepository userRepository;
    private final ProjectRepository projectRepository;

    public void addParticipate(Long userId, Long projectId) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        Project project = projectRepository.findById(projectId).orElseThrow(() -> new RuntimeException("Project not found"));

        ProjectParticipate projectParticipate = addProjectParticipate(userId, projectId, user, project);

        // 데이터베이스에 저장
        projectParticipateRepository.save(projectParticipate);
    }

    public ProjectParticipate addProjectParticipate(Long userId, Long projectId, User user, Project project) {
        ProjectParticipateId participateId = new ProjectParticipateId();
        participateId.setUserId(userId);
        participateId.setProjectId(projectId);

        ProjectParticipate projectParticipate = new ProjectParticipate();
        projectParticipate.setId(participateId);
        projectParticipate.setUser(user);
        projectParticipate.setProject(project);

        return projectParticipate;
    }
}
