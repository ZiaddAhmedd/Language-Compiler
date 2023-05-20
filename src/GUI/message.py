from tkinter import *
from tkinter import filedialog,messagebox
import subprocess
import re
path=''

# adding Line Numbers Functionality
def get_line_numbers():
    output = ''
    if show_line_number.get():
        row, col = textarea.index("end").split('.')
        for i in range(1, int(row)):
            output += str(i) + '\n'
    return output


def on_content_changed(event=None):
    update_line_numbers()
    # update_cursor()


def update_line_numbers(event=None):
    line_numbers = get_line_numbers()
    line_number_bar.config(state='normal')
    line_number_bar.delete('1.0', 'end')
    line_number_bar.insert('1.0', line_numbers)
    line_number_bar.config(state='disabled')

def font_inc(event=None):
    global font_size
    font_size+=1
    textarea.config(font=('arial',font_size,'bold'))

def font_dec(event=None):
    global font_size
    font_size-=1
    textarea.config(font=('arial',font_size,'bold'))



def run_code():
    if path=='':
        messagebox.showerror('Error','Please save the file before running')
    else:
        filepath = '"C:\\Extra_D\\Ali_kolya\\Ali Year 3\\Projects & Assignments\\Term 2\\Language and Compilers\\Project\\Code\\Language-Compiler\\src"'
        command=f'{filepath}\\compiler.exe {filepath}'
        # print(r {path})
        input_file=open(path.replace('/','\\'),'r')
        # run_file=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True, stdin=input_file)
        run_file=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True, stdin=input_file)
        output,error=run_file.communicate()
        outputarea.delete(1.0,END)

        output_file = open('./Outputs/Quadruples.txt', 'r')
        output = output_file.read()
        
        
        # line number : 3, syntax error
        # number = matches[-1]
        # print(number)
        # print(error)
        error2 = error.decode('utf-8')
        number = error2.split(',')[0].split(' ')[-1] if error2.startswith('line number') else None
        number = int(number) - 1 if number else None
        if (number):
            outputarea.insert(1.0, f'line {number}: Error')
            highlight_line(textarea, number)
        else:
            textarea.tag_remove("highlight", "1.0", "end")
            outputarea.insert(1.0, error)
        outputarea.insert(1.0,output)
        # outputarea.insert(1.0,error)



def highlight_line(text_widget, line_no):
    # Remove any existing highlighting
    text_widget.tag_remove("highlight", "1.0", "end")

    # Add the "highlight" tag to the specified line
    start = f"{line_no}.0"
    end = f"{line_no + 1}.0"
    text_widget.tag_add("highlight", start, end)

    # Configure the "highlight" tag to use a yellow background
    text_widget.tag_configure("highlight", background="red")

def saveas(event=None):
    global path
    path=filedialog.asksaveasfilename(filetypes=[('Python Files','*.py')],defaultextension=('.py'))
    if path!='':
        file=open(path,'w')
        file.write(textarea.get(1.0,END))
        file.close()

def openfile(event=None):
    global path
    path=filedialog.askopenfilename(filetypes=[('Python Files','*.py')],defaultextension=('.py'))
    print(path)
    if path != '':
        file=open(path,'r')
        data=file.read()
        textarea.delete(1.0,END)
        textarea.insert(1.0,data)
        file.close()

def save(event=None):
    if path=='':
        saveas()
    else:
        file=open(path,'w')
        file.write(textarea.get(1.0,END))
        file.close()

def new(event=None):
    global path
    path=''
    textarea.delete(1.0,END)
    outputarea.delete(1.0,END)

def iexit(event=None):
    result=messagebox.askyesno('Confirm','Do you want to exit?')
    if result:
        root.destroy()
    else:
        pass

def theme():
    if check.get()=='light':
        textarea.config(bg='white',fg='black')
        outputarea.config(bg='white',fg='black')

    if check.get()=='dark':
        textarea.config(bg='gray20', fg='white')
        outputarea.config(bg='gray20', fg='white')


def clear():
    textarea.delete(1.0,END)
    outputarea.delete(1.0,END)

font_size=18

root=Tk()
root.geometry('1270x670+0+0')
root.title('HAZY Compiler')

check=StringVar()
check.set('light')
myMenu=Menu()
filemenu=Menu(myMenu,tearoff=False)
filemenu.add_command(label='New File',accelerator='Ctrl+N',command=new)
filemenu.add_command(label='Open File',accelerator='Ctrl+O',command=openfile)
filemenu.add_command(label='Save',accelerator='Ctrl+S',command=save)
filemenu.add_command(label='Save as',accelerator='Ctrl+A',command=saveas)
filemenu.add_command(label='Exit',accelerator='Ctrl+Q',command=iexit)
myMenu.add_cascade(label='File',menu=filemenu)

thememenu=Menu(myMenu,tearoff=False)
thememenu.add_radiobutton(label='Light',variable=check,value='light',command=theme)
thememenu.add_radiobutton(label='Dark',variable=check,value='dark',command=theme)

myMenu.add_cascade(label='Themes',menu=thememenu)

myMenu.add_command(label='Clear',command=clear)

myMenu.add_command(label='Compile',command=run_code)

editFrame=Frame(root,bg='white')
editFrame.place(x=60,y=0,height=500,relwidth=0.95)

scrollbar=Scrollbar(editFrame,orient=VERTICAL)
scrollbar.pack(side=RIGHT,fill=Y)
textarea=Text(editFrame,font=('arial',14,'bold'),yscrollcommand=scrollbar.set)
textarea.pack(fill=BOTH)
scrollbar.config(command=textarea.yview)

outputFrame=LabelFrame(root,text='Output',font=('arial',12,'bold'))
outputFrame.place(x=60,y=500,relwidth=0.95,height=170)

scrollbar1=Scrollbar(outputFrame,orient=VERTICAL)
scrollbar1.pack(side=RIGHT,fill=Y)
outputarea=Text(outputFrame,font=('arial',font_size,'bold'),yscrollcommand=scrollbar1.set)
outputarea.pack(fill=BOTH)
scrollbar1.config(command=textarea.yview)


show_line_number = IntVar()
show_line_number.set(1)
# line_frame = LabelFrame(root,text='Output',font=('arial',12,'bold'))
# line_frame.place(x=40,y=500,relwidth=0.97,height=170)
line_number_bar = Text(root, width=4, padx=3, takefocus=0, fg='white', border=0, background='#282828', state='disabled',
                       wrap='none',font=('arial',14,'bold'))
line_number_bar.pack(side='left', fill='y')



root.config(menu=myMenu)


root.bind('<Control-n>',new)
root.bind('<Control-o>',openfile)
root.bind('<Control-s>',save)
root.bind('<Control-a>',saveas)
root.bind('<Control-q>',iexit)
root.bind('<Control-p>',font_inc)
root.bind('<Control-m>',font_dec)
textarea.bind('<Any-KeyPress>', on_content_changed)
textarea.tag_configure('active_line', background='ivory2')
textarea.focus_set()
root.mainloop()