# Duplicate-File-Scanner-in-Lisp
The Duplicate File Scanner is a simple tool written in Common Lisp that allows users to scan a directory for duplicate files. It recursively traverses a given directory, computes hash values (MD5 by default), and identifies files with identical contents.

# Requirements
To run this tool, you need:

Common Lisp: 
You need a working Lisp environment, such as SBCL (Steel Bank Common Lisp).

Quicklisp: A package manager for Common Lisp to install libraries like ironclad (for hashing).

# Installing Dependencies
Install SBCL: If you don’t have it already, download and install SBCL from sbcl.org.

Install Quicklisp: Follow the instructions from Quicklisp's website quicklisp.org/beta/.


# Setup
Clone or download this repository.
Open a Lisp REPL like sbcl.

Load the project:
(load "path-to-your-file/duplicate-file-scanner.lisp")

To test the tool, I provided a folder with test files containing duplicate content and when prompted, point the scanner to the folder path on your system.


# Usage
When running the program, you will be prompted to enter the directory you want to scan for duplicates.
Watch out to add an "/" or "\" at the end of your path.
The tool will display any duplicate files it finds.
After scanning a directory, you can choose to scan another directory or exit the program.


Example run:

Enter the directory path to scan for duplicates:
> /path/to/directory/

Traversal complete. Processing for duplicates...
Duplicate detected
Paths: (/path/to/directory/file1.txt /path/to/directory/file2.txt)

Would you like to scan another directory? (yes/no):
> no


# License
This project is open-source and licensed under the GNU GPLv3 License.
