
import java.awt.Color;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

public class Listener extends MouseAdapter{
    JButton button;
    JLabel fileName,message;
    JPanel messagePanel;
    JScrollPane scrollPane;

    Listener(JButton button,JLabel fileName, JLabel message, JPanel messagePanel, JScrollPane scrollPane){
        this.button = button;
        this.fileName = fileName;
        this.message = message;
        this.messagePanel = messagePanel;
        this.scrollPane = scrollPane;
    }

    @Override
    public void mouseClicked(MouseEvent e){
        JFileChooser chooser = new JFileChooser();
        JFileChooser chooser2 = new JFileChooser();
        chooser.setDialogTitle("Load which input file");
        chooser2.setDialogTitle("Where to save the output files?");
        chooser2.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        int result = chooser.showOpenDialog(null);
        int result2 = chooser2.showOpenDialog(null);
        if (result == JFileChooser.APPROVE_OPTION && result2 == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            File output = chooser2.getSelectedFile();
            fileName.setText(" File chosen : " + file.getAbsolutePath());
            fileName.setAlignmentX(JComponent.CENTER_ALIGNMENT);

            /*
             * To re-center the label once the File has been chosen.
             * Otherwise, the entire program will un-align.
             */
            try {

                ProcessBuilder builder = new ProcessBuilder("cmd.exe", "/c", "cd \"C:\\Extra_D\\Ali_kolya\\Ali Year 3\\Projects & Assignments\\Term 2\\Language and Compilers\\Project\\Code\\Language-Compiler\\src\\Compilers\" && compiler.exe "+ "\""+output.getAbsolutePath()+"\"").redirectInput(new File( file.getAbsolutePath() ));
                //I needed to redirect the process builder because the input file could be in a different directory
                builder.redirectErrorStream(true);
                Process proc = builder.start();
                BufferedReader stdInput = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                BufferedReader stdError = new BufferedReader(new InputStreamReader(proc.getErrorStream()));

                // read the output from the command
                System.out.println("Here is the standard output of the command:\n");
                String s;
                int i=0;
                message.setText("<html>");
                while ((s = stdInput.readLine()) != null) {

                    message.setText(message.getText() + "<br>" + s);
                    System.out.println("LINE " + i + " : " + s);
                    i++;

                }

                // read any errors from the attempted command
                i=0;
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

    void setBorderColor(){
        if(!message.getText().toLowerCase().contains("parsing complete")){
            message.setForeground(Color.RED);
            scrollPane.setBorder(BorderFactory.createLineBorder(Color.RED));
        }else{
            message.setForeground(Color.decode("#339966"));
            scrollPane.setBorder(BorderFactory.createLineBorder(Color.GREEN));
        }
    }

    @Override
    public void mouseEntered(MouseEvent e){
        button.setBackground(Color.decode("#8F92D9"));
        button.setForeground(Color.decode("#FFFFFF"));
    }

    @Override
    public void mouseExited(MouseEvent e){
        button.setBackground(Color.decode("#D7AE8F"));
        button.setForeground(Color.decode("#000000"));
    }
}