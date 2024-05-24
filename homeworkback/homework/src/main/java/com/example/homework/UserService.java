package com.example.homework;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User findByEmail(String email){
        return userRepository.findByEmail(email);
    }

    public User saveUser(User user){return userRepository.save(user);}



    public User findById(Long userid){
        return userRepository.findById(userid).orElse(null);
    }

    public UserDTO findUserInfoById(int userid) {
        Object[] result = (Object[]) userRepository.findUserInfoById(userid);
        UserDTO userDTO = new UserDTO();
        userDTO.setUserid(((Number) result[0]).longValue());
        userDTO.setEmail((String) result[1]);
        userDTO.setName((String) result[2]);
        userDTO.setSurname((String) result[3]);
        userDTO.setBirthdate((String) result[4]);
        return userDTO;
    }
}
