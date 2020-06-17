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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TokenController {

  @Value("${tabwriter.apple.music.private.key}")
  private String privateKey;

  @Value("${tabwriter.apple.music.key.identifier}")
  private String keyIdentifier;

  @Value("${tabwriter.apple.music.team.id}")
  private String teamId;

  @GetMapping("token")
  public String getDeveloperToken() throws NoSuchAlgorithmException, InvalidKeySpecException {
    Instant now = Instant.now();

    KeyFactory kf = KeyFactory.getInstance("EC");
    byte[] bytes = Base64.getDecoder().decode(privateKey);
    PrivateKey privateKey = kf.generatePrivate(new PKCS8EncodedKeySpec(bytes));

    return Jwts.builder()
      .setHeaderParam("kid", keyIdentifier)
      .setIssuer(teamId)
      .setIssuedAt(Date.from(now))
      .setExpiration(Date.from(now.atOffset(UTC).plusMonths(3).toInstant()))
      .signWith(privateKey, SignatureAlgorithm.ES256)
      .compact();
  }
}
