package com.noto.back.repository;

import com.noto.back.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    @Override
    Optional<User> findById(Long aLong);

    @Query("SELECT pp.user " +
            "FROM ProjectParticipate pp " +
            "WHERE pp.project.id = :projectId " +
            "AND pp.user.name = :userName")
    User findUserByProjectIdAndUserName(@Param("projectId") Long projectId,
                                        @Param("userName") String userName);
}
