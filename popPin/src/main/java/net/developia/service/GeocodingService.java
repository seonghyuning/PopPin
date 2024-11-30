package net.developia.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GeocodingService {

    private static final String KAKAO_API_KEY = "9e94f03ff5e465e19873d38a2c64901a";

    public double[] getLatLngFromAddress(String address) {
        double[] latLng = null;

        try {
            // 주소를 URL 인코딩
            String encodedAddress = URLEncoder.encode(address, "UTF-8");
            String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + encodedAddress;

            // API 요청
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_API_KEY);

            // 응답 코드 확인
            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                throw new IOException("HTTP request failed with response code: " + responseCode);
            }

            // 응답 읽기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // JSON 파싱
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(response.toString());
            JsonNode documents = rootNode.path("documents");

            if (documents.isArray() && documents.size() > 0) {
                JsonNode firstResult = documents.get(0);
                double latitude = firstResult.path("y").asDouble();
                double longitude = firstResult.path("x").asDouble();
                latLng = new double[] { latitude, longitude };
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return latLng; // 결과가 없으면 null 반환
    }
}
