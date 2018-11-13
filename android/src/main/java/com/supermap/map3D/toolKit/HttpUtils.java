package com.supermap.map3D.toolKit;

import android.os.Handler;
import android.os.Message;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;

import java.net.URL;


public class HttpUtils {

	private static Handler mHandler = new Handler();

	// httpClient Get
	public static String connServerResult(String strUrl) {
		// �����������URL��ַ
		// ��������ת����String
		HttpGet httpRequest = new HttpGet(strUrl);

		String strResult = null;
		HttpClient httpClient =null;
		try {

			httpClient = new DefaultHttpClient();

			HttpResponse httpResponse = httpClient.execute(httpRequest);
			int code = httpResponse.getStatusLine().getStatusCode();
			if (code == HttpStatus.SC_OK) {
				strResult = EntityUtils.toString(httpResponse.getEntity());

			}

		} catch (Exception e) {

		}
		finally {
			httpClient.getConnectionManager().shutdown();
		}

		return strResult;
	}

	public static void getHttpResponse(final String allConfigUrl) {

		new Thread(new Runnable() {

			public void run() {
				BufferedReader in = null;
				StringBuffer result = null;
				HttpURLConnection connection = null;
				try {

					URL url = new URL(allConfigUrl);
					connection = (HttpURLConnection) url.openConnection();
					connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
					connection.setRequestProperty("Charset", "utf-8");
					connection.setConnectTimeout(5*1000);
					int code=connection.getResponseCode();
					//Log.v("lzw", "connection.getResponseCode()="+connection.getResponseCode());
					if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
						result = new StringBuffer();
						// ��ȡURL����Ӧ
						in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
						String line;
						while ((line = in.readLine()) != null) {
							result.append(line);
						}
						Message msg_navigation = mHandler.obtainMessage();
						msg_navigation.what = 0;
						msg_navigation.obj = result.toString();
						mHandler.sendMessage(msg_navigation);
					}

				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					try {
						if (connection != null) {
							connection.disconnect();
							connection = null;
						}
						if (in != null) {
							in.close();
							in = null;
						}
					} catch (Exception e2) {
						e2.printStackTrace();
					}
				}

			}

		}).start();

	}


	public static void doHttpUtilsCallBaockListener(final HttpUtilsCallbackListener listener) {
		mHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
				switch (msg.what) {
				case 0:
					String str = (String) msg.obj;
					listener.success(str);
					break;

				default:

					break;
				}
			}
		};
	}

	public interface HttpUtilsCallbackListener {
		void success(String str);
	}
	
}
