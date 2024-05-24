package com.example.homework;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long>{
    User findByEmail(String email);

    @Query(value = "SELECT userid, email, name, surname, birthdate FROM userinfo_view WHERE userid = :userid", nativeQuery = true)
    Object findUserInfoById(@Param("userid") int userid);  // Changed return type from List<User> to User

}
