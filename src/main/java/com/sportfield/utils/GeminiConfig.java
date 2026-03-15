package com.sportfield.utils;

/**
 * Configuration for Google Gemini API.
 * Replace GEMINI_API_KEY with your actual API key from https://aistudio.google.com/app/apikey
 */
public class GeminiConfig {

    // ===== GEMINI API KEY =====
    public static final String GEMINI_API_KEY = "YOUR_GEMINI_API_KEY_HERE";
    // ==========================

    public static final String GEMINI_MODEL = "gemini-2.0-flash";
    public static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/"
            + GEMINI_MODEL + ":generateContent?key=" + GEMINI_API_KEY;
}
