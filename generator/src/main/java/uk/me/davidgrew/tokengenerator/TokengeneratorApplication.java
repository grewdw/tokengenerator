package uk.me.davidgrew.tokengenerator;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.time.Instant;

@SpringBootApplication
public class TokengeneratorApplication {

	@Bean
	public Clock getClock() {
		return Instant::now;
	}

	public static void main(String[] args) {
		SpringApplication.run(TokengeneratorApplication.class, args);
	}
}
