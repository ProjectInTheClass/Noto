package com.noto.back.service;

import com.noto.back.domain.User;
import com.noto.back.dto.response.UserResponse;
import com.noto.back.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@RequiredArgsConstructor
@Service
public class UserService {
    private final UserRepository userRepository;

    public UserResponse getUserInfoById(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User with ID " + userId + " not found"));

        return UserResponse.builder()
                .name(user.getName())
                .email(user.getEmail())
                .lastLogin(user.getLastLogin() != null ? user.getLastLogin().toLocalDate() : null)
                .createdDate(user.getCreatedDate() != null ? user.getCreatedDate().toLocalDate() : null)
                .build();
    }
}
