import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.border.EmptyBorder;

class WindowFrame extends JFrame {

    JPanel panel, messagePanel;
    JScrollPane scrollPane;
    JLabel heading;
    JTextField inputField;
    JButton compileButton;
    JLabel outputLabel, errorLabel, symbolTableLabel;

    WindowFrame() {
        setSize(500, 500);
        init();
        createGUI();
        setVisible(true);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
    }

    void init() {
        inputField = new JTextField();
        compileButton = new JButton("Compile");
        panel = new JPanel();
        messagePanel = new JPanel();
        outputLabel = new JLabel();
        errorLabel = new JLabel();
        symbolTableLabel = new JLabel();
        heading = new JLabel();
        scrollPane = new JScrollPane(messagePanel);
    }

    void createGUI() {

        panel.setBackground(Color.decode("#000033"));
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBorder(new EmptyBorder(30, 30, 60, 30));

        // ZAYA
        // YAZE
        // HAZY
        heading.setText("HAZY Compiler");
        heading.setFont(new java.awt.Font("Courier", java.awt.Font.BOLD, 20));
        heading.setAlignmentX(JComponent.CENTER_ALIGNMENT);
        heading.setForeground(Color.decode("#FFFFFF"));

        inputField.setAlignmentX(JComponent.CENTER_ALIGNMENT);
        inputField.setBackground(Color.decode("#D0D0D0"));
        inputField.setForeground(Color.decode("#000000"));
//        inputField.setLineWrap(true);

        compileButton.setMargin(new Insets(10, 10, 10, 5));
        compileButton.setBackground(Color.decode("#000080"));
        compileButton.setForeground(Color.decode("#FFFFFF"));
        compileButton.setContentAreaFilled(false);
        compileButton.setBorderPainted(false);
        compileButton.setOpaque(true);
        compileButton.setAlignmentX(JComponent.CENTER_ALIGNMENT);

        outputLabel.setText("Output:");
        outputLabel.setForeground(Color.decode("#FFFFFF"));

        errorLabel.setText("Error:");
        errorLabel.setForeground(Color.decode("#FFFFFF"));

        symbolTableLabel.setText("Symbol Table:");
        symbolTableLabel.setForeground(Color.decode("#FFFFFF"));

        messagePanel.setLayout(new FlowLayout());
        messagePanel.setBackground(Color.decode("#000033"));
        messagePanel.add(outputLabel);
        messagePanel.add(errorLabel);
        messagePanel.add(symbolTableLabel);

        panel.add(heading);
        panel.add(Box.createVerticalStrut(20));
        panel.add(inputField);
        panel.add(Box.createVerticalStrut(20));
        panel.add(compileButton);
        panel.add(Box.createVerticalStrut(20));
        panel.add(scrollPane);
        panel.add(Box.createVerticalStrut(20));
        add(panel);

        JLabel message = new JLabel();
        JLabel filename = new JLabel();
        Listener listener = new Listener(compileButton, filename, message, messagePanel, scrollPane, inputField);

// Set the listener to the compileButton
        compileButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                // Call the appropriate method from the Listener instance
                listener.mouseClicked(null);
            }
        });
    }
}

public class SSMain {
    public static void main(String[] args) {
        new WindowFrame();
    }
}