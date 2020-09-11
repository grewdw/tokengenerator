package uk.me.davidgrew.tokengenerator;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.http.*;

import java.time.Instant;
import java.time.ZoneOffset;
import java.util.*;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class TokenTest {

    @Value("${tabwriter.apple.music.private.key}")
    private String privateKey;

    @Value("${tabwriter.apple.music.key.identifier}")
    private String keyIdentifier;

    @Value("${tabwriter.apple.music.team.id}")
    private String teamId;

    @Value("${tabwriter.apple.music.token.expiry}")
    private int tokenExpiry;

    @Value("${tabwriter.http.auth-token-header-name}")
    private String principalRequestHeader;

    @Value("${tabwriter.http.auth-token}")
    private String principalRequestValue;

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private TokenController controller;

    @Test
    public void tokenReturned() throws Exception {
        List<String> tokenElements = Arrays.stream(controller.getDeveloperToken().split("\\."))
                .limit(2)
                .map(s -> new String(Base64.getDecoder().decode(s)))
                .collect(Collectors.toList());

        ObjectMapper mapper = new ObjectMapper();
        Map<String, String> headers = mapper.readValue(tokenElements.get(0), new TypeReference<HashMap<String, String>>() {
        });
        Map<String, String> payload = mapper.readValue(tokenElements.get(1), new TypeReference<HashMap<String, String>>() {
        });

        assertThat(headers.get("alg")).isEqualTo("ES256");
        assertThat(headers.get("kid")).isEqualTo(keyIdentifier);
        assertThat(payload.get("iss")).isEqualTo(teamId);
        assertThat(payload.get("iat")).isEqualTo(Long.toString(Config.now.getEpochSecond()));
        assertThat(payload.get("exp")).isEqualTo(Long.toString(Config.now.atOffset(ZoneOffset.UTC).plusDays(tokenExpiry).toInstant().getEpochSecond()));
    }

    @Test
    public void apiKeyRequired() {
        ResponseEntity<String> failureResponse = restTemplate.getForEntity(String.format("http://localhost:%d/api/token", port), String.class, Collections.emptyMap());
        assertThat(failureResponse.getStatusCode()).isEqualTo(HttpStatus.FORBIDDEN);

        HttpHeaders headers = new HttpHeaders();
        headers.set(principalRequestHeader, "APIKey " + principalRequestValue);
        HttpEntity<Object> request = new HttpEntity<>(null, headers);

        ResponseEntity<String> successResponse = restTemplate.exchange(String.format("http://localhost:%d/api/token", port), HttpMethod.GET, request, String.class);
        assertThat(successResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @TestConfiguration
    static class Config {

        static Instant now = Instant.parse("2019-06-01T10:00:00Z");

        @Bean
        @Primary
        public Clock getTestClock() {
            return () -> now;
        }
    }
}
