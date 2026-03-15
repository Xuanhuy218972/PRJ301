package com.sportfield.utils;

import java.util.List;
import java.util.regex.Pattern;

/**
 * Utility class for sanitizing user input to prevent prompt injection attacks.
 * Requirements: 7.3
 */
public final class InputSanitizer {

    private static final List<Pattern> INJECTION_PATTERNS = List.of(
        Pattern.compile("ignore previous instructions", Pattern.CASE_INSENSITIVE),
        Pattern.compile("ignore all instructions", Pattern.CASE_INSENSITIVE),
        Pattern.compile("system:", Pattern.CASE_INSENSITIVE),
        Pattern.compile("###"),
        Pattern.compile("you are now", Pattern.CASE_INSENSITIVE),
        Pattern.compile("act as", Pattern.CASE_INSENSITIVE),
        Pattern.compile("disregard", Pattern.CASE_INSENSITIVE),
        Pattern.compile("forget everything", Pattern.CASE_INSENSITIVE)
    );

    private InputSanitizer() {
        // utility class
    }

    /**
     * Sanitizes the given input by removing known prompt-injection patterns
     * and trimming whitespace.
     *
     * @param input the raw user input
     * @return sanitized string, or empty string if input is null
     */
    public static String sanitize(String input) {
        if (input == null) {
            return "";
        }

        String result = input;
        for (Pattern pattern : INJECTION_PATTERNS) {
            result = pattern.matcher(result).replaceAll("");
        }

        return result.trim();
    }
}
