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

(defun new-model (column-types elements)
  (let ((model (make-instance 'gtk-list-store
                              :column-types column-types)))

    (loop :for (name price) :in elements
          :do (gtk-list-store-set model
                                  (gtk-list-store-append model)
                                  name
                                  price))
    model))

(defun append-new-renderer (view column-name type column-id)
  (let* ((renderer (gtk-cell-renderer-text-new))
         (column (gtk-tree-view-column-new-with-attributes column-name
                                                           renderer
                                                           type
                                                           column-id)))
    (gtk-tree-view-append-column view column)))

(defun new-view (column-types column-description column-elements on-change)
  (let* ((model (new-model column-types column-elements))
         (view (make-instance 'gtk-tree-view
                              :model model))
         (select (gtk-tree-view-get-selection view)))

    (loop :for i :from 0 :below (length column-types)
          :do (destructuring-bind (name type) (nth i column-description)
                (append-new-renderer view name type i)))

    (setf (gtk-tree-selection-mode select) :single)
    (g-signal-connect select "changed"
                      (lambda (selection)
                        (funcall on-change view selection)))

    view))

(defun kaisse ()
  "Kaisse, gtk GUI."
  (format t "Starting program.~%")
  (let ((root (gtk-box-new :vertical 6)))
    (gtk-progn "Kaisse" root
      (let* (;; welcome message
             (welcome (gtk-label-new "Welcome to Kaisse"))
             (view (new-view '("gchararray" "guint")
                             '(("Product Name" "text")
                               ("Price" "text"))
                             '(("banana" 2)
                               ("orange" 1))
                             (lambda (view selection)
                               (let* ((model (gtk-tree-view-get-model view))
                                      (iter (gtk-tree-selection-get-selected selection))
                                      (name (gtk-tree-model-get-value model iter 0)))
                                 (format t "You selected ~A.~%" name))))))


        ;; add to root
        (gtk-box-pack-end root view)
        (gtk-box-pack-end root welcome)))))
