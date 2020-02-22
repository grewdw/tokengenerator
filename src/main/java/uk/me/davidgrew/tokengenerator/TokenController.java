package uk.me.davidgrew.tokengenerator;

import static java.time.ZoneOffset.UTC;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.sql.Date;
import java.time.Instant;
import java.util.Base64;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TokenController {

  @GetMapping("developertoken")
  public String getDeveloperToken() throws NoSuchAlgorithmException, InvalidKeySpecException {
    Instant now = Instant.now();

    KeyFactory kf = KeyFactory.getInstance("EC");
    byte[] bytes = Base64.getDecoder().decode("MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgNkRKfBsoCDC5zc8d"
      + "+pfXt7O0EAeFRfxltINa60KgrWqgCgYIKoZIzj0DAQehRANCAATWUurrA29LTzTd"
      + "pXo8CcA+s+QySgJAf4RbkUSVeiFqRIzlXNiDPcWl30peHMKHrTFulb0VHLFhJNKw"
      + "leZvVtkk");
    PrivateKey privateKey = kf.generatePrivate(new PKCS8EncodedKeySpec(bytes));

    return Jwts.builder()
      .setHeaderParam("kid", "2APMB8T2LZ")
      .setIssuer("E3XM73DHEY")
      .setIssuedAt(Date.from(now))
      .setExpiration(Date.from(now.atOffset(UTC).plusMonths(6).toInstant()))
      .signWith(privateKey, SignatureAlgorithm.ES256)
      .compact();
  }
}
