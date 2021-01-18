(in-package #:kaisse)

(defmacro gtk-progn (title root &body body)
  (let ((window (gensym "window")))
    `(within-main-loop
       (let ((,window (make-instance 'gtk-window
                                     :type :toplevel
                                     :title ,title
                                     :default-width 250
                                     :default-height 75
                                     :border-width 12)))

         (g-signal-connect ,window "destroy"
                           (lambda (widget)
                             (declare (ignore widget))
                             (leave-gtk-main)))

         (g-signal-connect ,window "delete-event"
                           (lambda (widget event)
                             (declare (ignore widget event))
                             (format t "Delete Event Occured~%")
                             +gdk-event-propagate+))

         ,@body

         (gtk-container-add ,window ,root)
         (gtk-widget-show-all ,window)))))

(defun image-label-box (filename text)
  (let ((box (make-instance 'gtk-box
                            :orientation :horizontal
                            :border-width 3))
        (label (make-instance 'gtk-label
                              :label text))
        (image (gtk-image-new-from-file filename)))
    (gtk-box-pack-start box image
                        :expand nil
                        :fill nil
                        :padding 3)
    (gtk-box-pack-start box label
                        :expand nil
                        :fill nil
                        :padding 3)
    box))

(defun kaisse ()
  "Kaisse, gtk GUI."
  (format t "Starting program.~%")
  (let ((root (gtk-box-new :vertical 6)))
    (gtk-progn "Kaisse" root
      (let* (;; welcome message
             (welcome (gtk-label-new "Welcome to Kaisse"))
             ;; products model
             (products-model (make-instance 'gtk-list-store
                                            :column-types '("gchararray" "guint")))
             ;; product list view
             (products-view (make-instance 'gtk-tree-view
                                           :model products-model)))

        ;; add products into model
        (gtk-list-store-set products-model (gtk-list-store-append products-model)
                            "Klaus-Dieter Mustermann" 51)

        ;; add to root
        (gtk-box-pack-start root welcome)))))
