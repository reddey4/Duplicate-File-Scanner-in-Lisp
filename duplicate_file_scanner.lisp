
(ql:quickload :ironclad)

(defun traverse-directory (path)
  "Recursively collects all files from the given directory."
  (mapcan (lambda (entry)
            (let ((full-path (merge-pathnames entry path)))
              (cond
                ;; If it's a file, return its full path in a list
                ((pathname-name (pathname full-path))
                 (list full-path))
                ;; If it's a directory, recurse into it
                ((eq nil (pathname-name (pathname full-path)))
                 (traverse-directory full-path))
                (t
                 (format t "~%Skipping unknown entry or error:~%~a~%" full-path)
                 nil))))
          ;; List all entries in the current directory
          (directory (merge-pathnames "*.*" path))))

(defun hash-file-content (file-path)
  (with-open-file (stream file-path :direction :input :element-type '(unsigned-byte 8))
    (let ((content (make-array (file-length stream) :element-type '(unsigned-byte 8))))
      (read-sequence content stream)
      (ironclad:digest-sequence 'ironclad:md5 content))))

(defun print-hash-table-contents (hash-table)
  "Print all key-value pairs in the given hash table."
  (maphash (lambda (key value)
             (format t "~%Key: ~A~%Value: ~A~%" key value))
           hash-table))

(defun find-duplicate-files (paths)
  "Find duplicate files in the given list of PATHS.
   Returns a list of duplicates where each entry is a list of paths with identical hashes."
  (let ((hash-table (make-hash-table :test 'equalp))
        (duplicates '()))
    ;; Traverse the provided paths
    (dolist (path paths)
      (let ((hash (hash-file-content path)))
        (if (gethash hash hash-table)
            ;; If the hash already exists, add the path to the list
            (setf (gethash hash hash-table)
                  (append (list path) (gethash hash hash-table)))
            ;; Otherwise, initialize the hash entry
            (setf (gethash hash hash-table) (list path)))))

    ;; Collect duplicates
    (maphash (lambda (hash file-paths)
               (declare (ignore hash))
               (when (> (length file-paths) 1)
                 (format t "~%Duplicate detected ~%Paths: ~A~%" file-paths)
                 (push file-paths duplicates)))
             hash-table)
    ;; Return the list of duplicates
    duplicates))

(defun get-user-path ()
  "Prompt the user for a directory path and validate it."
  (format t "Enter the directory path to scan for duplicates: ")
  (terpri)
  (let ((input (string-trim '(#\" #\') (read-line)))) ;; Remove quotes from input
    (let ((path (pathname input))) ;; Convert input to pathname
      (if (and (probe-file path) (directory (merge-pathnames "*.*" path)))
          path
          (progn
            (format t "Invalid path. Please try again.~%")
            (get-user-path))))))



(defun duplicate-file-scanner ()
  "Main function for the Duplicate File Scanner."
  (loop
     ;; Prompt and process the user's input
     (let* ((path (get-user-path))
            (files (traverse-directory path)))
       (format t "~%Traversal complete. Processing for duplicates...~%")
       (find-duplicate-files files))

     ;; Ask if the user wants to scan another directory
     (format t "~%Would you like to scan another directory? (yes/no): ")
     (terpri)
     (let ((response (string-downcase (string-trim '(#\" #\') (read-line)))))
       (unless (or (string= response "yes") (string= response "y"))
         (return-from duplicate-file-scanner)))))

(duplicate-file-scanner)
