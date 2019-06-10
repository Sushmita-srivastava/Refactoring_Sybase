package com.iig.gcp.extraction.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class Test {

	public static void main(String[] args) throws FileNotFoundException, IOException {

		try (InputStream in = new FileInputStream("C:/Users/rylanpatrick_m/Downloads/test.psv")) {
			String str = null;
			CSV csv = new CSV(true, '|', in);
			List<String> fieldNames = null;
			if (csv.hasNext())
				fieldNames = new ArrayList<>(csv.next());
			List<Map<String, String>> list = new ArrayList<>();
			int counter = 1;
			while (csv.hasNext()) {
				List<String> x = csv.next();
				while (x.size() <= 9) {
					x.add("");
				}
				Map<String, String> obj = new LinkedHashMap<>();
				for (int i = 0; i < fieldNames.size(); i++) {
					obj.put(fieldNames.get(i).toLowerCase() + counter, x.get(i));
				}
				list.add(obj);
				counter++;
			}
			ObjectMapper mapper = new ObjectMapper();
			mapper.enable(SerializationFeature.INDENT_OUTPUT);
			str = mapper.writeValueAsString(list);
			str = "{\"header\":{},\"body\":{\"data\":" + str + "}}";
			JSONObject jsonObject = new JSONObject(str);
			JSONObject getObject = jsonObject.getJSONObject("body");
			JSONArray getArray = getObject.getJSONArray("data");
			JSONObject json = new JSONObject();
			String schema, table, view, col, where, type, incr, val, err;
			for (int i = 0; i < getArray.length(); i++) {
				JSONObject objectInArray = getArray.getJSONObject(i);
				schema = objectInArray.getString("schema_name"+(i+1));
				table = objectInArray.getString("table_name"+(i+1));
				view = objectInArray.getString("is_view"+(i+1));
				col = objectInArray.getString("columns_name"+(i+1));
				where = objectInArray.getString("where_clause"+(i+1));
				type = objectInArray.getString("fetch_type"+(i+1));
				incr = objectInArray.getString("incr_col"+(i+1));
				val = objectInArray.getString("validation_flag"+(i+1));
				err = objectInArray.getString("error_message"+(i+1));
				//str = "{\"header\":{},\"body\":{\"data\":{" + "\"schema_name"+i+"\":\""+schema+"\"" + "}}";
				json.put("schema_name"+(i+1), schema);
				json.put("table_name"+(i+1), table);
				json.put("is_view"+(i+1), view);
				json.put("columns_name"+(i+1), col);
				json.put("where_clause"+(i+1), where);
				json.put("fetch_type"+(i+1), type);
				json.put("incr_col"+(i+1), incr);
				json.put("validation_flag"+(i+1), val);
				json.put("error_message"+(i+1), err);
			}
			json.put("project", "TERADATA_MIGRATION");
			json.put("user", "43908412");
			json.put("counter", counter-1);
			json.put("feed_id", "268");
			json.put("connection_id", "123");
			str = "{\"header\":{},\"body\":{\"data\":" + json + "}}";
			System.out.println(str);
		}
	}
}
