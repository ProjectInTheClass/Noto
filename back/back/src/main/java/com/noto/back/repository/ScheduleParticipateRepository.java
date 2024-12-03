package com.noto.back.repository;

import com.noto.back.domain.ScheduleParticipate;
import com.noto.back.domain.embid.ScheduleParticipateId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

public interface ScheduleParticipateRepository extends JpaRepository<ScheduleParticipate, ScheduleParticipateId> {
    @Modifying
    @Transactional
    @Query("DELETE FROM ScheduleParticipate sp WHERE sp.schedule.id = :scheduleId")
    void deleteByScheduleId(@Param("scheduleId") Long scheduleId);
}
