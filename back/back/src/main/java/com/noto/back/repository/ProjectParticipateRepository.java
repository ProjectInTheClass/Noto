package com.noto.back.repository;

import com.noto.back.domain.ProjectParticipate;
import com.noto.back.domain.embid.ProjectParticipateId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProjectParticipateRepository extends JpaRepository<ProjectParticipate, ProjectParticipateId> {

}
