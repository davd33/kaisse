(in-package #:kaisse-clim)

(defgeneric display (frame pane))

(defclass abstract-simple-gadget (clim:basic-gadget) ())

(defclass generic-text-gadget (abstract-text-gadget)
  ((color :initform clim:+darkred+ :accessor gadget-color)
   (text :initform "" :accessor gadget-text)))

(define-application-frame kaisse ()
  ((welcome-message :initform "Welcome to kaisse"))
  (:pane :application
   :scroll-bars t
   :display-function #'display))

(defmethod display ((frame kaisse) pane)
  (clim:with-output-as-gadget (pane)
    (clim:make-pane 'generic-simple-gadget)))

(define-application-frame gadget-frame ()
  ((gtype :initarg :gadget-type :initform 'generic-simple-gadget :reader gadget-type))
  (:pane (clim:make-pane (gadget-type clim:*application-frame*))))

(defun run (frame-type &rest args)
  (let ((frame (apply #'clim:make-application-frame frame-type args)))
    (clim:run-frame-top-level frame)))
