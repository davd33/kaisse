(in-package :db)

(defparameter all-tables '(user cuser))

;;; --- MANAGE CONNECTION

(defvar *connection* nil)
(defun connect (db-name username password)
  (when (null *connection*)
    (setf *connection*
          (mito:connect-toplevel :postgres
                                 :database-name db-name
                                 :username username
                                 :password password))))

;;; --- CREATE/DROP TABLES

(defun reset-db-tables ()
  (mapcar #'mito:recreate-table all-tables))

;;; --- DEFINE TABLES

(mito:deftable user ()
  ((name :col-type (:varchar 64))
   (password :col-type (:varchar 128))
   (email :col-type (or (:varchar 128)
                        :null))))

(mito:deftable cuser ()
  ((cuser :col-type user)))

;;; --- QUERIES
