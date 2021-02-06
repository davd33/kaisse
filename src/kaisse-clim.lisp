(in-package #:kaisse-clim)

(defvar *kaisse-app-frame* nil
  "Main frame of kaisse.")

(defun lang (id-kw)
  (case id-kw
    (:welcome-message "Welcome to kaisse")
    (:no-user-yet "You need to set kaisse up")))

(defun count-pixels (string &optional (char-pixel-lenght 16))
  "Return the total pixel width for given STRING."
  (* char-pixel-lenght (length string)))

(defgeneric display-pane-with-view (frame pane view)
  (:documentation "Display a specific view on PANE."))

;;; GADGET CLASSES

(defclass abstract-simple-gadget (clim:basic-gadget) ())

(defclass generic-text-gadget (abstract-simple-gadget)
  ((color :initform clim:+darkred+ :accessor gadget-color)
   (text :initform "" :accessor gadget-text :initarg :text)))

(defclass generic-list-gadget (clim:basic-gadget) ())

;;; VIEWS

(defclass abstract-kaisse-view (clim:view) ())

(defclass welcome-view (abstract-kaisse-view)
  ((%message :initarg :message :reader welcome-view-message)))

(defclass create-admin-view (abstract-kaisse-view) ())

;;; APPLICATION FRAME

(defparameter *default-view* (make-instance 'welcome-view :message (lang :welcome-message)))

(define-application-frame kaisse-frame ()
  ()
  (:panes (app :application
               :default-view *default-view*
               :display-function #'display-main-pane))
  (:geometry :width 1000 :height 800)
  (:layouts (default (vertically () app))))

(defun display-main-pane (frame pane)
  "Call the view to be displayed."
  (display-pane-with-view frame pane (stream-default-view pane)))

(defmethod display-pane-with-view ((frame kaisse-frame) pane (view welcome-view))
  (clim:with-output-as-gadget (pane)
    (let ((w (bounding-rectangle-width pane))
          (h (bounding-rectangle-height pane)))
      (make-pane 'clim::raised-pane :border-width 1 :background +Gray83+
                                    :width w :height h
                                    :contents
                                    (list (vertically ()
                                            (clim:make-pane 'generic-text-gadget
                                                            :width w :height 20
                                                            :text (welcome-view-message view))
                                            (clim:make-pane 'push-button
                                                            :label "Ok")))))))

;;; GADGETS

(defmethod clim:handle-repaint ((gadget generic-list-gadget) region)
  (declare (ignore region))
  (clim:draw-circle* gadget 0 0 20))

(defmethod clim:handle-repaint ((gadget generic-text-gadget) region)
  (declare (ignore region))
  (let ((w (bounding-rectangle-width gadget))
        (h (bounding-rectangle-height gadget)))
    (clim:draw-text* gadget (gadget-text gadget)
                     (floor w 2) (floor h 2)
                     :align-x :center
                     :align-y :center
                     :ink (gadget-color gadget))))

;; (defmethod clim:handle-event ((gadget generic-text-gadget)
;;                               (event clim:pointer-button-press-event))
;;   (clim:repaint-sheet gadget clim:+everywhere+))

;;; RUN A FRAME

(defun run (frame-type &rest args)
  (let ((frame (apply #'clim:make-application-frame frame-type args)))
    (setf *kaisse-app-frame* frame)
    (clim:run-frame-top-level frame)))
