package uk.me.davidgrew.tokengenerator;

import static java.time.ZoneOffset.UTC;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TokenController {

  @GetMapping("token")
  public String getDeveloperToken() throws NoSuchAlgorithmException, InvalidKeySpecException {
    Instant now = Instant.now();

    KeyFactory kf = KeyFactory.getInstance("EC");
    byte[] bytes = Base64.getDecoder()
      .decode(
        "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgrwZ1eEhjYOfmLDn6"
          + "vnLM9MLGdJtU9viH8BTlE0yUH0CgCgYIKoZIzj0DAQehRANCAATFxDIwSEOHBKBD"
          + "C4+EwIX4TuH5DBAfj6YH8ddjR4IKlbeun8qfPcPRmgubX5FQSAOWLrAOaDNdMY7E"
          + "ALcgPK5a");
    PrivateKey privateKey = kf.generatePrivate(new PKCS8EncodedKeySpec(bytes));

    return Jwts.builder()
      .setHeaderParam("kid", "Z5G4U2Q6S6")
      .setIssuer("E3XM73DHEY")
      .setIssuedAt(Date.from(now))
      .setExpiration(Date.from(now.atOffset(UTC).plusMonths(3).toInstant()))
      .signWith(privateKey, SignatureAlgorithm.ES256)
      .compact();
  }
}
