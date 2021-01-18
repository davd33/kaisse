(in-package :db)

(defparameter all-tables '())

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

(defun create-table (table-type)
  "Creates the table of given type."
  (restart-case
      (when (not (mito.db:table-exists-p *connection*
                                         (mito.class:table-name (find-class table-type))))
        (format t "~&CREATE TABLE: ~A" table-type)
        (mapc #'mito:execute-sql (mito:table-definition table-type))
        (mito:ensure-table-exists table-type)
        t)
    (skip () nil)))

(defun create-tables ()
  (mapcar #'create-table all-tables))

(defun reset-db-tables ()
  (mapcar #'mito:recreate-table all-tables))

;;; --- DEFINE TABLES

;;(mito:deftable user ())

;;; --- QUERIES
