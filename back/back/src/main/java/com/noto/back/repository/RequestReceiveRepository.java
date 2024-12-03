package com.noto.back.repository;

import com.noto.back.domain.RequestReceive;
import com.noto.back.domain.embid.RequestReceiveId;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RequestReceiveRepository extends JpaRepository<RequestReceive, RequestReceiveId> {

    // userId와 readOrNot가 false인 레코드 수를 반환하는 쿼리
    @Query("SELECT COUNT(r) FROM RequestReceive r WHERE r.id.userId = :userId AND r.readOrNot = false")
    Long countByUserIdAndReadOrNotFalse(Long userId);

    @Modifying
    @Transactional
    @Query("UPDATE RequestReceive rr SET rr.readOrNot = true WHERE rr.id.requestId = :requestId AND rr.id.userId = :userId")
    Integer updateReadOrNot(@Param("requestId") Long requestId, @Param("userId") Long userId);

    @Query("Select r From RequestReceive r where r.id.userId = :userId And r.id.requestId = :requestId")
    RequestReceive findByIds(@Param("userId") Long userId, @Param("requestId") Long requestId);

    @Query("""
        SELECT r.status, r.comment, u.name 
        FROM RequestReceive r 
        LEFT JOIN User u ON u.id = r.id.userId
        WHERE r.id.requestId = :requestId
    """)
    List<Object[]> findByRequestId(@Param("requestId") Long requestId);

}