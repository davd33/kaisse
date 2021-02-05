(in-package #:kaisse-clim)

(defvar *kaisse-app-frame* nil
  "Main frame of kaisse.")

(defgeneric display (frame pane))

(defclass abstract-simple-gadget (clim:basic-gadget) ())

(defclass generic-text-gadget (abstract-simple-gadget)
  ((color :initform clim:+darkred+ :accessor gadget-color)
   (text :initform "" :accessor gadget-text :initarg :text)))

;;; APPLICATION FRAME

(define-application-frame kaisse ()
  ((welcome-message :initform "Welcome to kaisse" :reader welcome-message))
  (:panes (app :application :display-function #'display))
  (:geometry :width 400 :height 200)
  (:layouts (default (vertically () app))))

(defmethod display ((frame kaisse) pane)
  (clim:with-output-as-gadget (pane)
    (let ((w (bounding-rectangle-width pane))
          (h (bounding-rectangle-height pane)))
      (clim:make-pane 'generic-text-gadget
                      :width w
                      :height h
                      :text (welcome-message frame)))))

;;; GADGET FRAME

(defmethod clim:handle-repaint ((gadget generic-text-gadget) region)
  (declare (ignore region))
  (let ((w (bounding-rectangle-width gadget))
        (h (bounding-rectangle-height gadget)))
    (clim:draw-text* gadget (gadget-text gadget)
                     (floor w 2) (floor h 2)
                     :align-x :center
                     :align-y :center
                     :ink (gadget-color gadget))))

;;; RUN A FRAME

(defun run (frame-type &rest args)
  (let ((frame (apply #'clim:make-application-frame frame-type args)))
    (setf *kaisse-app-frame* frame)
    (clim:run-frame-top-level frame)))
