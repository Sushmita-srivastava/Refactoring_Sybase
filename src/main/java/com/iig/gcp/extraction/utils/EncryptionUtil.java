package com.iig.gcp.extraction.utils;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Scanner;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.iig.gcp.constants.SybaseConstants;

@Component
public class EncryptionUtil {
	

	private static String master_key_path;
	@Value("${master.key.path}")
	public void setMasterKeyPath(String value) {
		this.master_key_path=value;
	}
	
	public static SecretKey decodeKeyFromString(String keyStr) {
		/* Decodes a Base64 encoded String into a byte array */
		String keyString = keyStr.trim();
		byte[] decodedKey = Base64.getDecoder().decode(keyString);

		/* Constructs a secret key from the given byte array */
		SecretKey secretKey = new SecretKeySpec(decodedKey, 0, decodedKey.length, "AES");

		return secretKey;
	}
	
	public static String readFile(String pathname) throws IOException {
		File file = new File(pathname);
		StringBuilder fileContents = new StringBuilder((int) file.length());
		Scanner scanner = new Scanner(new BufferedReader(new FileReader(file)));
		String lineSeparator = System.getProperty("line.separator");

		try {
			if (scanner.hasNextLine()) {
				fileContents.append(scanner.nextLine());
			}
			while (scanner.hasNextLine()) {
				fileContents.append(lineSeparator + scanner.nextLine());
			}
			return fileContents.toString();
		} finally {
			scanner.close();
		}
	}
	
	
	
	
	public static  String decryptText(byte[] byteCipherText, SecretKey secKey) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {

		// AES defaults to AES/ECB/PKCS5Padding in Java 7

		Cipher aesCipher = Cipher.getInstance("AES");

		aesCipher.init(Cipher.DECRYPT_MODE, secKey);

		byte[] bytePlainText = aesCipher.doFinal(byteCipherText);
		
		

		return new String(bytePlainText);

	}
	
	public static byte[] encryptText(String plainText, String key) throws Exception {

		
		// AES defaults to AES/ECB/PKCS5Padding in Java 7
		System.out.println("key is "+key);
		SecretKey secKey=decodeKeyFromString(key);

		Cipher aesCipher = Cipher.getInstance("AES");

		aesCipher.init(Cipher.ENCRYPT_MODE, secKey);

		byte[] byteCipherText = aesCipher.doFinal(plainText.getBytes());

		
		
		return byteCipherText;

	}
	
	public static String decyptPassword(byte[] encrypted_key, byte[] encrypted_password) throws Exception {
		
		String content = readFile(master_key_path);
		SecretKey secKey = decodeKeyFromString(content);
		String decrypted_key=decryptText(encrypted_key,secKey);
		SecretKey secKey2 = decodeKeyFromString(decrypted_key);
		String password=decryptText(encrypted_password,secKey2);
		return password;
		
	}


}