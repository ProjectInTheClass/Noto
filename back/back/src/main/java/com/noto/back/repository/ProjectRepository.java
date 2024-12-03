package com.noto.back.repository;

import com.noto.back.domain.Project;
import com.noto.back.domain.Schedule;
import com.noto.back.dto.response.ProjectProgressResponse;
import com.noto.back.dto.response.ProjectResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProjectRepository extends JpaRepository<Project, Long> {
        @Query("""
                SELECT 
                    p.name,
                    p.progress,
                    DATEDIFF(CURRENT_DATE(), p.endDate),
                    (SELECT GROUP_CONCAT(u.name) FROM User u
                    JOIN ProjectParticipate pp ON pp.id.userId = u.id
                    WHERE pp.id.projectId = p.id),
                    p.startDate,
                    p.endDate
                FROM Project p
                WHERE p.id IN (
                    SELECT pp.id.projectId
                    FROM ProjectParticipate pp
                    WHERE pp.id.userId = :userId
                )
            """)
        List<Object[]> findProjectProgressByUserId(Long userId);

        @Query("""
            SELECT
                p.name, 
                p.startDate, 
                p.endDate, 
                GROUP_CONCAT(u.name) AS userNames, 
                p.description, 
                p.url, 
                p.image,
                p.id
            FROM Project p
            LEFT JOIN ProjectParticipate pp ON pp.id.projectId = p.id
            LEFT JOIN User u ON pp.id.userId = u.id
            WHERE p.id = :projectId
            GROUP BY p.id
        """)
        List<Object[]> getProjectInfo(Long projectId);

        @Query("SELECT s FROM Schedule s " +
                "WHERE YEAR(s.startDate) = YEAR(CURRENT_DATE()) " +
                "AND MONTH(s.startDate) = MONTH(CURRENT_DATE()) " +
                "AND s.project.id = :projectId")
        List<Schedule> findSchedulesByCurrentMonthAndProjectId(Long projectId);


        @Query("SELECT pp.project.name FROM ProjectParticipate pp WHERE pp.user.id = :userId")
        List<String> findProjectNamesByUserId(@Param("userId") Long userId);

        @Query( """ 
                SELECT GROUP_CONCAT(u.name) FROM User u
                JOIN ProjectParticipate pp ON pp.id.userId = u.id
                WHERE pp.id.projectId = :projectId
                """)
        String getParticipantsName(@Param("projectId") Long projectId);

}
