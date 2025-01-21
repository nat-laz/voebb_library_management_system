package org.example.service.product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Scanner;

public class ProductService {

    private final LanguageService languageService;

    public ProductService() {
        this.languageService = new LanguageService();
    }

    public void addProduct(Connection connection) {
        try (Scanner scanner = new Scanner(System.in)) {

            System.out.print("Enter product title: ");
            String title = scanner.nextLine();

            int year = -1;
            int currentYear = Calendar.getInstance().get(Calendar.YEAR);
            while (year < 0 || year > currentYear) {
                System.out.print("Enter product year (valid): ");
                year = scanner.nextInt();
                scanner.nextLine();
                if (year < 0 || year > currentYear) {
                    System.out.println("Invalid year! Please enter a value between 0 and " + currentYear + ".");
                }
            }

            System.out.println("Select media format:");
            System.out.println("[1] Book");
            System.out.println("[2] E-Book");
            System.out.println("[3] Video");
            System.out.println("[4] DVD Film");
            System.out.println("[5] Board Game");
            int mediaFormatId = scanner.nextInt();
            scanner.nextLine();

            if (mediaFormatId < 1 || mediaFormatId > 5) {
                System.out.println("Invalid media format selected. Please choose a valid option.");
                return;
            }

            String emediaLink = null;
            // ask for link just for:  e-book  or video
            if (mediaFormatId == 2 || mediaFormatId == 3) {
                while (emediaLink == null || emediaLink.isBlank()) {
                    System.out.print("Enter E-Media link (mandatory for E-Book and Video): ");
                    emediaLink = scanner.nextLine();
                    if (emediaLink.isBlank()) {
                        System.out.println("E-Media link cannot be empty for E-Book or Video!");
                    }
                }
            }

            System.out.print("Enter age restriction (or leave blank): ");
            String ageRestrictionInput = scanner.nextLine();
            Integer ageRestriction = ageRestrictionInput.isBlank() ? null : Integer.parseInt(ageRestrictionInput);

            System.out.print("Enter product note (or leave blank): ");
            String note = scanner.nextLine();

            String insertProductQuery = "INSERT INTO product (product_title, product_year, media_format_id, " +
                    "product_link_to_emedia, product_age_restriction, product_note) " +
                    "VALUES (?, ?, ?, ?, ?, ?) RETURNING product_id";

            int productId = -1;
            try (PreparedStatement stmt = connection.prepareStatement(insertProductQuery)) {
                stmt.setString(1, title);
                stmt.setInt(2, year);
                stmt.setInt(3, mediaFormatId);
                stmt.setString(4, emediaLink); // remain NULL for
                if (ageRestriction != null) {
                    stmt.setInt(5, ageRestriction);
                } else {
                    stmt.setNull(5, java.sql.Types.INTEGER);
                }
                stmt.setString(6, note);

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    productId = rs.getInt("product_id");
                    System.out.println("Product added successfully with ID: " + productId);
                }
            }

            switch (mediaFormatId) {
                case 1: // Book
                case 2: // E-Book
                    addBookDetails(connection, productId, scanner);
                    break;

                case 3: // Video
                    addVideoDetails(connection, productId, scanner);
                    break;

                case 4: // DVD Film
                case 5: // Board Game
                    System.out.println("No additional details required for this media type.");
                    break;

                default:
                    System.out.println("Invalid media format selected.");
            }


            languageService.addLanguages(connection, productId, scanner);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private void addBookDetails(Connection connection, int productId, Scanner scanner) throws SQLException {
        System.out.print("Enter book ISBN: ");
        String isbn = scanner.nextLine();

        System.out.print("Enter number of pages: ");
        int pages = scanner.nextInt();

        scanner.nextLine(); // Consume newline
        System.out.print("Enter book edition: ");
        String edition = scanner.nextLine();

        String insertBookQuery = "INSERT INTO book (product_id, book_isbn, book_pages, book_edition) " +
                "VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(insertBookQuery)) {
            stmt.setInt(1, productId);
            stmt.setString(2, isbn);
            stmt.setInt(3, pages);
            stmt.setString(4, edition);

            stmt.executeUpdate();
            System.out.println("Book details added successfully!");
        }
    }

    private void addVideoDetails(Connection connection, int productId, Scanner scanner) throws SQLException {
        System.out.print("Enter video duration in minutes: ");
        int duration = scanner.nextInt();

        String insertVideoQuery = "INSERT INTO video (product_id, video_duration_in_minutes) VALUES (?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(insertVideoQuery)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, duration);

            stmt.executeUpdate();
            System.out.println("Video details added successfully!");
        }
    }
}
