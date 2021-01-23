;;;; package.lisp

(defpackage #:macro-utils
  (:use #:cl #:alexandria))

(defpackage #:alists
  (:use #:cl #:alexandria)
  (:export #:aconses
           #:deep-acons
           #:merge-acons))

(defpackage #:hm
  (:use #:cl)
  (:shadow #:get
           #:reduce
           #:first)
  (:export #:put
           #:get
           #:one
           #:reduce
           #:print-elt
           #:print-all))

(defpackage #:mop
  (:use #:cl #:alexandria)
  (:export #:make-mapper
           #:find-class-slots
           #:class-slots
           #:defprintobj
           #:with-computed-slot
           #:with-mapped-slot
           #:with-renamed-slot))

(defpackage #:jsons
  (:use #:cl)
  (:export #:get-in
           #:add-value
           #:type-compatible-p))

(defpackage #:resources
  (:use #:cl)
  (:export #:*profile*
           #:*system*
           #:resource))

(defpackage #:api
  (:use #:cl #:snooze #:jsons #:alexandria #:resources)
  (:export #:start
           #:stop))

(defpackage #:db
  (:use #:cl)
  (:export #:connect
           ;; the user db table and class
           #:user))

(defpackage #:models
  (:use #:cl))

(defpackage #:kaisse
  (:use #:cl #:alexandria
        #:gtk #:gdk #:gdk-pixbuf #:gobject
        #:glib #:gio #:pango #:cairo)
  (:export #:start-gui))

(defpackage #:html
  (:use #:cl #:spinneret #:alexandria #:models)
  (:export #:secret-login))

(defpackage #:web-site
  (:use #:cl
        #:snooze
        #:jsons
        #:alexandria
        #:models)
  (:export #:home))
