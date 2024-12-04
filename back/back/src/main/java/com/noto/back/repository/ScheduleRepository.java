package com.noto.back.repository;

import com.noto.back.domain.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    @Query("""
        SELECT s 
        FROM Schedule s 
        JOIN ScheduleParticipate sp ON s.id = sp.id.scheduleId
        WHERE sp.id.userId = :userId
          AND s.startDate <= :currentDate
          AND s.endDate >= :currentDate
    """)
    List<Schedule> findSchedulesByUserIdAndDate(
            @Param("userId") Long userId,
            @Param("currentDate") LocalDate currentDate
    );

    @Query("SELECT s FROM Schedule s " +
            "WHERE s.project.id = :projectId ")
    List<Schedule> findSchedulesOfTheProject(Long projectId);

    @Query("""
        SELECT s.name, s.startDate, s.endDate, s.description, s.tag, s.url, 
               GROUP_CONCAT(u.name), s.id AS participantNames
        FROM Schedule s
        LEFT JOIN ScheduleParticipate sp ON sp.schedule.id = s.id
        LEFT JOIN User u ON sp.user.id = u.id
        WHERE s.id = :scheduleId
        GROUP BY s.id
    """)
    List<Object[]> getScheduleInfo(@Param("scheduleId") Long scheduleId);

    @Query("SELECT s FROM Schedule s WHERE s.project.id = :projectId")
    List<Schedule> findByProjectId(@Param("projectId") Long projectId);
}