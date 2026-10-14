package com.kedu.commons;

import java.io.InputStream;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailUtil {

	// 메일 보내기: 받는 사람, 제목, 내용
	public static void send(String to, String subject, String text) throws Exception {

		// 1) mail.properties 에서 계정 정보 읽기
		Properties conf = new Properties();
		InputStream in = MailUtil.class.getResourceAsStream("/mail.properties");
		if (in == null) {
			throw new Exception("mail.properties 파일이 없습니다.");
		}
		conf.load(in);
		in.close();
		final String user = conf.getProperty("mail.user");
		final String pw = conf.getProperty("mail.password");

		// 2) 구글 메일 서버 정보
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");

		// 3) 구글에 로그인할 정보
		Session session = Session.getInstance(props, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, pw);
			}
		});

		// 4) 메일 만들기
		MimeMessage msg = new MimeMessage(session);
		msg.setFrom(new InternetAddress(user, "짠내맵", "UTF-8"));
		msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
		msg.setSubject(subject, "UTF-8");
		msg.setText(text, "UTF-8");

		// 5) 보내기
		Transport.send(msg);
	}

	// 테스트용 (확인이 끝나면 이 main 은 지워도 됩니다)
	public static void main(String[] args) throws Exception {
		send("jjannaemap.team@gmail.com", "[짠내맵] 테스트", "메일 발송 테스트입니다.");
		System.out.println("발송 완료");
	}
}