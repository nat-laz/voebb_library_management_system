package org.example.service.product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class LanguageService {

    public void addLanguages(Connection connection, int productId, Scanner scanner) throws SQLException {
        System.out.println("Enter the languages for the product (comma-separated, e.g., English,French): ");
        String[] languages = scanner.nextLine().split(",");

        for (String language : languages) {
            int languageId = getLanguageId(connection, language.trim());
            if (languageId == -1) {
                System.out.println("The language \"" + language.trim() + "\" is not supported. Skipping.");
                continue;
            }

            System.out.println("Select the language type(s) for \"" + language.trim() + "\" (comma-separated):");
            System.out.println("[1] Original");
            System.out.println("[2] Translation");
            System.out.println("[3] Subtitles");
            System.out.println("[4] Dubbing");

            String[] typeSelections = scanner.nextLine().split(",");
            for (String typeSelection : typeSelections) {
                int languageTypeId = getLanguageTypeId(typeSelection.trim());
                if (languageTypeId == -1) {
                    System.out.println("Invalid language type selected: " + typeSelection.trim());
                    continue;
                }

                insertLanguageRelation(connection, productId, languageId, languageTypeId);
            }
        }

        System.out.println("Languages and types added successfully!");
    }

    public int getLanguageId(Connection connection, String languageName) throws SQLException {
        String query = "SELECT language_id FROM language WHERE language_name = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, languageName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("language_id");
            }
        }
        return -1;
    }

    public int getLanguageTypeId(String type) {
        switch (type.toLowerCase()) {
            case "1":
            case "original":
                return 1;
            case "2":
            case "translation":
                return 2;
            case "3":
            case "subtitles":
                return 3;
            case "4":
            case "dubbing":
                return 4;
            default:
                return -1;
        }
    }

    private void insertLanguageRelation(Connection connection, int productId, int languageId, int languageTypeId) throws SQLException {
        String query = "INSERT INTO language_relation (product_id, language_id, language_type_id) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, languageId);
            stmt.setInt(3, languageTypeId);
            stmt.executeUpdate();
        }
    }
}
