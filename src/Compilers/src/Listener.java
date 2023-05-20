import java.awt.Color;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;

import java.io.FileWriter;

public class Listener extends MouseAdapter {
    JButton button;
    JLabel fileName, message;
    JPanel messagePanel;
    JScrollPane scrollPane;
    JTextField inputField;

    Listener(JButton button, JLabel fileName, JLabel message, JPanel messagePanel, JScrollPane scrollPane, JTextField inputField) {
        this.button = button;
        this.fileName = fileName;
        this.message = message;
        this.messagePanel = messagePanel;
        this.scrollPane = scrollPane;
        this.inputField = inputField;
    }

    @Override
    public void mouseClicked(MouseEvent e) {
        String inputFile = inputField.getText();
        if (!inputFile.isEmpty()) {
            try {
                FileWriter writer = new FileWriter("Input.txt");
                writer.write(inputFile);
                writer.close();
//                System.out.println("Text saved to file: " + filename);
            } catch (IOException ee) {
                System.out.println("An error occurred while saving the text to file: " + ee.getMessage());
            }
            fileName.setText(" File chosen: " + inputFile);
            fileName.setAlignmentX(JComponent.CENTER_ALIGNMENT);

            try {
                File output = new File("C:\\Extra_D\\Ali_kolya\\Ali Year 3\\Projects & Assignments\\Term 2\\Language and Compilers\\Project\\Code\\Language-Compiler\\src\\Outputs");

                ProcessBuilder builder = new ProcessBuilder("cmd.exe", "/c",
                        "cd \"C:\\Extra_D\\Ali_kolya\\Ali Year 3\\Projects & Assignments\\Term 2\\Language and Compilers\\Project\\Code\\Language-Compiler\\src\" && compiler.exe \"C:\\Extra_D\\Ali_kolya\\Ali Year 3\\Projects & Assignments\\Term 2\\Language and Compilers\\Project\\Code\\Language-Compiler\\src\" "
                                + "\"" + output.getAbsolutePath() + "\"").redirectInput(new File("Input.txt"));
                builder.redirectErrorStream(true);
                Process proc = builder.start();
                BufferedReader stdInput = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                BufferedReader stdError = new BufferedReader(new InputStreamReader(proc.getErrorStream()));

                System.out.println("Here is the standard output of the command:\n");
                String s;
                int i = 0;
                message.setText("<html>");
                while ((s = stdInput.readLine()) != null) {
                    message.setText(message.getText() + "<br>" + s);
                    System.out.println("LINE " + i + " : " + s);
                    i++;
                }

                i = 0;
                System.out.println("Here is the standard error of the command (if any):\n");
                while ((s = stdError.readLine()) != null) {
                    message.setText(message.getText() + "<br>" + s);
                    System.out.println("LINE " + i + " : " + s);
                    i++;
                }

                message.setText(message.getText() + "</html>");
                setBorderColor();
                stdInput.close();
                stdError.close();

            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    void setBorderColor() {
        if (!message.getText().toLowerCase().contains("parsing complete")) {
            message.setForeground(Color.RED);
            scrollPane.setBorder(BorderFactory.createLineBorder(Color.RED));
        } else {
            message.setForeground(Color.decode("#339966"));
            scrollPane.setBorder(BorderFactory.createLineBorder(Color.GREEN));
        }
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        button.setBackground(Color.decode("#FFFF00"));
        button.setForeground(Color.decode("#000000"));
    }

    @Override
    public void mouseExited(MouseEvent e) {
        button.setBackground(Color.decode("#000080"));
        button.setForeground(Color.decode("#FFFFFF"));
    }

    public void keyPressed(KeyEvent e) {
        if (e.getKeyCode() == KeyEvent.VK_ENTER) {
            inputField.setText(inputField.getText() + "\n");
//            inputField.append("\n");
        }
    }

}
