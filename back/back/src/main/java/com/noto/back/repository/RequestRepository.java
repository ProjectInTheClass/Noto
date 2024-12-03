package com.noto.back.repository;

import com.noto.back.domain.Request;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface RequestRepository extends JpaRepository<Request, Long> {

    @Query("""
       SELECT
                   p.name,
                   p.startDate,
                   p.endDate,
                   r.title,
                   r.content,
                   s.name AS senderName,
                   GROUP_CONCAT(u.name) AS receiverNames,
                   sch.name AS scheduleName,
                   r.id
               FROM Request r
               LEFT JOIN r.project p
               LEFT JOIN r.sender s
               LEFT JOIN RequestReceive rr ON rr.id.requestId = r.id
               LEFT JOIN User u ON rr.id.userId = u.id
               LEFT JOIN ScheduleRequest sr ON sr.id.requestId = r.id
               LEFT JOIN Schedule sch ON sr.id.scheduleId = sch.id
               WHERE r.id = :requestId
               GROUP BY r.id, sch.name
    """)
    List<Object[]> getRequestInfo(@Param("requestId") Long requestId);

    @Query("SELECT r.request.title, r.request.sender.name " +
            "FROM RequestReceive r " +
            "WHERE r.receiver.id = :receiverId")
    List<Object[]> findRequestInfoByReceiverId(@Param("receiverId") Long receiverId);
}
