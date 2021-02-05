(in-package #:kaisse-clim)

(defgeneric display (frame pane))

(defclass abstract-simple-gadget (clim:basic-gadget) ())

(defclass generic-text-gadget (abstract-simple-gadget)
  ((color :initform clim:+darkred+ :accessor gadget-color)
   (text :initform "" :accessor gadget-text :initarg :text)))

;;; APPLICATION FRAME

(define-application-frame kaisse ()
  ((welcome-message :initform "Welcome to kaisse" :reader welcome-message))
  (:pane :application :scroll-bars t :display-function #'display)
  (:geometry :width 800 :height 800))

(defmethod display ((frame kaisse) pane)
  (clim:with-output-as-gadget (pane)
    (clim:make-pane 'generic-text-gadget :text (welcome-message frame))))

;;; GADGET FRAME

(define-application-frame gadget-frame ()
  ((gtype :initarg :gadget-type :initform 'generic-text-gadget :reader gadget-type))
  (:pane (clim:make-pane (gadget-type clim:*application-frame*))))

(defmethod clim:handle-repaint ((gadget generic-text-gadget) region)
  (declare (ignore region))
  (clim:draw-text* gadget (gadget-text gadget) 0 0
                   :ink (gadget-color gadget)))

;;; RUN A FRAME

(defun run (frame-type &rest args)
  (let ((frame (apply #'clim:make-application-frame frame-type args)))
    (clim:run-frame-top-level frame)))
