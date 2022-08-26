package com.owl.member.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Service;

import com.owl.member.dto.Member;

@Service
public class KaKaoService {
	public String getAuthorizationUrl() {
		StringBuilder builder = new StringBuilder() 
										.append("https://kauth.kakao.com/oauth/authorize?")
										.append("client_id=5d151c02cc241d9ba7a8373a8051d79d")
										.append("&redirect_uri=http://localhost:8090/Project_OWL/kakaoLogin.do")
										.append("&response_type=code");
		
		return builder.toString();
	}

	public Member getMemberInfo (String code) {
		String token = getAccessToken(code);
	    Member member = new Member();
	    member.setSignFrom("kakao");
	    
	    String reqURL = "https://kapi.kakao.com/v2/user/me";
	    try {
	        URL url = new URL(reqURL);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("POST");
	        
	        // 요청에 필요한 Header에 포함될 내용
	        conn.setRequestProperty("Authorization", "Bearer " + token);

	        String line = "";
	        String result = "";
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        while ((line = br.readLine()) != null) {
	            result += line;
	        }

	        JSONObject element = new JSONObject(result);
			String nickname = (String) ((JSONObject) element.get("properties")).get("nickname");
			String email = (String) ((JSONObject) element.get("kakao_account")).get("email");
			
			member.setName(nickname);
			member.setEmail(email);
	    } catch (IOException | JSONException e) {
	        e.printStackTrace();
	    }
	    
	    return member;
	}
	
	private String getAccessToken(String code)  {
		String access_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token";
		System.out.println("in getAccessToken");
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			// POST 요청을 위해 기본값이 false인 setDoOutput을 true로
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);

			// POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			
			// https://kauth.kakao.com/oauth/authorize?client_id=5d151c02cc241d9ba7a8373a8051d79d&redirect_uri=http://localhost:8090/OWL/kakaoLogin.do&response_type=code
			sb.append("grant_type=authorization_code");
			sb.append("&client_id=5d151c02cc241d9ba7a8373a8051d79d");
			sb.append("&redirect_uri=http://localhost:8090/OWL/kakaoLogin.do");
			sb.append("&code=" + code);
			bw.write(sb.toString());
			bw.flush();

			// 결과 코드가 200이라면 성공
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);

			// 요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line = "";
			String result = "";

			while ((line = br.readLine()) != null) {
				result += line;
			}

			JSONObject element = new JSONObject(result);
			System.out.println(element.get("access_token"));

			access_Token = (String)element.get("access_token");

			System.out.println("access_token : " + access_Token);

			br.close();
			bw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return access_Token;
	}
}
