import tkinter as tk
from tkinter import scrolledtext, filedialog
import subprocess
from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import HtmlFormatter
from tkinter import ttk

class EditorWindow(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack(expand=True, fill="both")    # set expand and fill options
        self.create_widgets()

    def create_widgets(self):
      # create a text box for editing code and pack it into the window leaving 20 pixels on the left side
      self.code_editor = scrolledtext.ScrolledText(
        self, wrap=tk.WORD, bg="#0078d7", fg="white", font=("Consolas", 12))
      self.code_editor.pack(expand=True, fill="both", padx=40, pady=(10, 0))
      


      # Create a themed scrollbar and attach it to the text box
      scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, style="Custom.Vertical.TScrollbar")
      scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
      self.code_editor.config(yscrollcommand=scrollbar.set)
      scrollbar.config(command=self.code_editor.yview)

      # create a button to compile the code and pack it into the window
      self.compile_button = tk.Button(self, text="Compile", command=self.compile_code, bg="green", fg="white", font=("Consolas", 12))
      self.compile_button.pack(side=tk.TOP, anchor="ne", padx=10, pady=10)

    def compile_code(self):
        # get the code from the text box
        code = self.code_editor.get("1.0", "end-1c")

        # save the code to a file
        file_path = filedialog.asksaveasfilename(defaultextension=".py")
        if file_path:
            with open(file_path, "w") as f:
                f.write(code)

        # compile the code using subprocess
        subprocess.call(["compiler.exe", file_path])


# create the main window and run the event loop
root = tk.Tk()
root.title("Python Editor")
root.geometry("600x600")
app = EditorWindow(master=root)
app.mainloop()
