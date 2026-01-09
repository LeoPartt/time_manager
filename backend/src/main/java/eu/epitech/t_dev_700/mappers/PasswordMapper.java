package eu.epitech.t_dev_700.mappers;

import org.mapstruct.Mapper;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

@Mapper(componentModel = "spring")
public abstract class PasswordMapper {

    protected PasswordEncoder encoder;

    // ✅ no-arg constructor required by MapStruct subclassing
    protected PasswordMapper() {}

    // ✅ Spring injects after instantiation
    @Autowired
    public void setEncoder(PasswordEncoder encoder) {
        this.encoder = encoder;
    }

    @Named("encodePassword")
    public String encodePassword(String raw) {
        if (raw == null) return null;
        if (raw.isBlank()) return raw;
        return encoder.encode(raw);
    }
}
