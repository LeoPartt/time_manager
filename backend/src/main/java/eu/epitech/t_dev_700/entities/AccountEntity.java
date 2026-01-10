package eu.epitech.t_dev_700.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;
import java.util.Objects;

@Getter
@Setter
@Entity
@Table(
        name = "account",
        uniqueConstraints = @UniqueConstraint(name = "ux_account_username", columnNames = {"username"}),
        indexes = {
                @Index(name = "idx_account_username", columnList = "username")
        }
)
public class AccountEntity implements UserDetails {

    public static final byte FLAG_ADMIN = 0x01;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 255)
    @Column(name = "username", nullable = false)
    private String username;

    @NotBlank
    @JsonIgnore
    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "flags", nullable = false)
    private byte flags = 0;

    @OneToOne(mappedBy = "account")
    @JsonIgnore
    private UserEntity user;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AccountEntity that)) return false;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() { return Objects.hashCode(id); }

    @Override
    public String toString() {
        return "Account{id=" + id + ", username='" + username + "'}";
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of();
    }

    @Override
    public boolean isAccountNonExpired() {
        return UserDetails.super.isAccountNonExpired();
    }

    @Override
    public boolean isAccountNonLocked() {
        return UserDetails.super.isAccountNonLocked();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return UserDetails.super.isCredentialsNonExpired();
    }

    @Override
    public boolean isEnabled() {
        return UserDetails.super.isEnabled();
    }

    public boolean hasFlag(byte flag) {
        return (flags & flag) == flag;
    }

    public boolean isAdmin() {
        return this.hasFlag(FLAG_ADMIN);
    }
}
