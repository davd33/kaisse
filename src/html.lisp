(in-package :html)

;;; --- UTILS

(defmacro css (&body styles)
  "Takes 1..n CSS instructions as 2-elements lists, then returns a css formatted string.
   A CSS instruction list looks like this: (:font-size <string>)"
  `(str:concat
     ,@(loop for style in styles
          collect `(format nil "~a: ~a;~%" ,(string (first style)) ,(second style)))))

(defmacro with-page ((&key title image-path) &body body)
  `(spinneret:with-html
     (:doctype)
     (:html
      (:head
       (:link :href "/css/main.css" :rel "stylesheet" :type "text/css")
       (:title ,title)
       (when ,image-path
         (:style "html {"
                 (css (:background (str:concat "url(" ,image-path ")")))
                 "background-size: cover;"
                 "background-repeat: no-repeat;"
                 "}")))
      (:body
       (:div.container ,@body)))))

(deftag repeat (template attrs &key for)
  "This is a tag that repeats a given template using the key
for a translation split into a list of several strings.
  - for: lang-binding-form: 2 elements list with var name and translation key
  - template: a single form (one list of potentially embedded tags)"
  `(reduce #'(lambda (acc elt)
               (append
                acc
                (let ((,(caadr for) elt))
                  ,@template)))
           ,@(cdadr for)
           :initial-value `(progn)))

;;; --- TEMPLATES

(defparameter *page-title* "Kaisse")

(defun secret-login (login-error)
  "There is a common password for all optimums.
One solely password for each instance of the website."
  (with-page (:title *page-title* :image-path nil)
    (:div
     :id "login"
     (:div
      :class "login-form"
      (:p
       :class (if login-error "error-msg" "info-msg")
       (or login-error "Please give the password:"))
      (:form
       :method "POST"
       (:input
        :type "password"
        :name "password"
        :placeholder "...here")
       (:input
        :type "submit"
        :value "Go"))))))
