package com.iig.gcp;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

	public static final String SECRET = "SecretKeyToGenJWTs";
	
	public static class MyUser{
		private String name;
		private String project;
		private String jwt;
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getProject() {
			return project;
		}
		public void setProject(String project) {
			this.project = project;
		}
		public String getJwt() {
			return jwt;
		}
		public void setJwt(String jwt) {
			this.jwt = jwt;
		}
	}

    @Override
    public Authentication authenticate(Authentication authentication)
            throws AuthenticationException {
        String name = authentication.getName().split(":")[0];
        String project= authentication.getName().split(":")[1];
        Object credentials = authentication.getCredentials();
        if (!(credentials instanceof String)) {
            return null;
        }
        String password = credentials.toString();

        String token = credentials.toString();
		
		DecodedJWT decodedToken = JWT.decode(token);
        JWTVerifier verifier = selectVerifier(decodedToken);
        DecodedJWT decodedJWT = verifier.verify(token);

        if (decodedJWT.getSubject()== null) {
            throw new BadCredentialsException("Authentication failed for " + name);
        }

        List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
        grantedAuthorities.add(new SimpleGrantedAuthority("ADMIN"));
        MyUser m = new MyUser();
        m.setName(name);
        m.setJwt(password);
        m.setProject(project);
        Authentication auth = new
                UsernamePasswordAuthenticationToken(m, password, grantedAuthorities);
        return auth;
    }

    
    private JWTVerifier selectVerifier(DecodedJWT decodedToken) {
        String algorithm = decodedToken.getAlgorithm();
        switch (algorithm) {
            case "HS512":
            	Algorithm algorithm512 = Algorithm.HMAC512(SECRET.getBytes());
            	return JWT
                .require(algorithm512)
                .build();
                 
            default:
                throw new IllegalStateException("Cannot verify against algorithm: " + algorithm);
        }
    }
    
    
    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }

}