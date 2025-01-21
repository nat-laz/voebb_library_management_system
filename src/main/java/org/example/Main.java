package org.example;


import io.github.cdimascio.dotenv.Dotenv;
import org.example.service.product.ProductService;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main {
    public static Connection getConnection() throws SQLException {

        Dotenv dotenv = Dotenv.load();


        String host = dotenv.get("DB_HOST");
        String port = dotenv.get("DB_PORT");
        String dbName = dotenv.get("DB_NAME");
        String user = dotenv.get("DB_USER");
        String password = dotenv.get("DB_PASSWORD");

        String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;

        return DriverManager.getConnection(url, user, password);
    }

    public static void main(String[] args) {

        try {

            Connection connection = getConnection();
            System.out.println("Connected to the database!");

            ProductService productService = new ProductService();
            productService.addProduct(connection);

            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}