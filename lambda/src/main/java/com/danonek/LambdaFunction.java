package com.danonek;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.HashMap;
import java.util.Map;

public class LambdaFunction implements RequestHandler<Object, Map<String, Object>> {
    @Override
    public Map<String, Object> handleRequest(Object input, Context context) {
        // Create the response body as a JSON string
        String responseBody = "{\"message\": \"Hello World!\"}";

        // Create the response object
        Map<String, Object> response = new HashMap<>();
        response.put("statusCode", 200);
        response.put("body", responseBody); // Response body with Hello World
        response.put("headers", getHeaders()); // Headers including CORS

        return response;
    }

    // Helper method to add headers including CORS
    private Map<String, String> getHeaders() {
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json"); // Specify content type as JSON
        headers.put("Access-Control-Allow-Origin", "*"); // Allow all origins (CORS)
        headers.put("Access-Control-Allow-Methods", "GET, OPTIONS"); // Allowed methods
        headers.put("Access-Control-Allow-Headers", "Content-Type"); // Allowed headers
        return headers;
    }
}
