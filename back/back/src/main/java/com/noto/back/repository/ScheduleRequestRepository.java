package com.noto.back.repository;

import com.noto.back.domain.ScheduleRequest;
import com.noto.back.domain.embid.ScheduleRequestId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScheduleRequestRepository extends JpaRepository<ScheduleRequest, ScheduleRequestId> {
}
