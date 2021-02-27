package uk.me.davidgrew.tokengenerator;

import java.time.Instant;

@FunctionalInterface
public interface Clock {

    Instant now();
}
