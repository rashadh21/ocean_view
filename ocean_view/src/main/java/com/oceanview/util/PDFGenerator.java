package com.oceanview.util;

import com.oceanview.model.Bill;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;

public class PDFGenerator {

    public static byte[] generateBillPDF(Bill bill) {
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 20);
                contentStream.beginText();
                contentStream.newLineAtOffset(50, 750);
                contentStream.showText("Ocean View Resort - Invoice");
                contentStream.endText();

                contentStream.setFont(PDType1Font.HELVETICA, 12);
                contentStream.beginText();
                contentStream.setLeading(14.5f);
                contentStream.newLineAtOffset(50, 700);
                
                contentStream.showText("Bill ID: " + bill.getBillId());
                contentStream.newLine();
                contentStream.showText("Date: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(bill.getBillDate()));
                contentStream.newLine();
                contentStream.newLine();
                
                contentStream.showText("Room Charges: $" + bill.getRoomCharges());
                contentStream.newLine();
                contentStream.showText("Tax (12%): $" + bill.getTaxAmount());
                contentStream.newLine();
                contentStream.showText("Service Charges (10%): $" + bill.getServiceCharges());
                contentStream.newLine();
                contentStream.showText("Assuming Discount: $" + bill.getDiscount());
                contentStream.newLine();
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 14);
                contentStream.showText("Total Amount: $" + bill.getTotalAmount());
                
                contentStream.endText();
            }

            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            document.save(byteArrayOutputStream);
            return byteArrayOutputStream.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
