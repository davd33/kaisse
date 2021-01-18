;;;; kaisse.asd

(asdf:defsystem #:kaisse
  :description "Enkaisse, consolide."
  :author "David Rueda <davd33@gmail.com>"
  :license  "GPLv3"
  :version "0.0.1"
  :serial t
  :depends-on (;; HTML / HTTP Routes
               #:spinneret
               #:hunchentoot
               #:snooze
               ;; #:clack
               ;; GTK 3
               #:cl-cffi-gtk
               ;; URI deserialize
               ;; #:quri
               ;; Make HTTP requests
               ;; #:dexador
               ;; CL jQuery for HTML strings
               ;; #:lquery
               ;; Basics
               #:cl-ppcre               ; Regex
               #:cl-json
               #:fset                   ; Functional data structures
               #:str
               #:trivia                 ; Pattern matching
               #:alexandria
               ;; Database
               #:mito
               #:sxql
               ;; Async
               #:lparallel
               ;; Programs options
               #:unix-opts
               ;; OOP extensions
               #:closer-mop
               ;; JWT Generation
               ;; #:cljwt-custom
               ;;#:ironclad               ; Crypto functions
               ;;#:cl-base64              ; (Part of CL)
               ;;#:flexi-stream           ; Bivalent streams
               )
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "macro-utils")
                 (:file "alists")
                 (:file "hm")
                 (:file "mop")
                 (:file "jsons")
                 (:file "resources")
                 (:file "api")
                 (:file "db")
                 (:file "models")
                 (:file "html")
                 (:file "web-site"))))
  :in-order-to ((test-op (test-op "kaisse/tests"))))

(asdf:defsystem "kaisse/tests"
  :author "David Rueda"
  :licence "GPLv3"
  :depends-on ("kaisse"
               "rove")
  :description "Test system for kaisse"
  :components ((:module "tests"
                ;; :components
                ;; ((:file "make-shopping-item-manager"))
                        ))
  :perform (test-op (op c) (symbol-call :rove :run c)))
