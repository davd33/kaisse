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

(defun append-to-list-model (model lst)
  (loop :for row :in lst
        :do (apply #'gtk-list-store-set
                   model
                   (gtk-list-store-append model)
                   row)))

(defun new-model (column-types elements)
  (let ((model (make-instance 'gtk-list-store
                              :column-types column-types)))

    (append-to-list-model model elements)

    model))

(defun append-new-renderer (view column-name type column-id)
  (let* ((renderer (gtk-cell-renderer-text-new))
         (column (gtk-tree-view-column-new-with-attributes column-name
                                                           renderer
                                                           type
                                                           column-id)))
    (gtk-tree-view-append-column view column)))

(defun new-list-view (column-types column-description on-change)
  (let* ((model (new-model column-types nil))
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

(defun mktext-col (name)
  `(,name "text"))

(defun configure-admin (password &optional email)
  (let ((admin (make-instance 'db:user
                              :name "admin"
                              :password password
                              :email email)))
    (mito:insert-dao admin)))

(defun first-run-p ()
  "Whether the program is run for the first time."
  (= 0 (mito:count-dao 'db:user)))

(defun start-gui ()
  "Kaisse, gtk GUI."
  (format t "Starting program.~%")
  (let ((root (gtk-box-new :vertical 6)))
    (gtk-progn "Kaisse" root
      (let* ((welcome-message (gtk-label-new "Welcome to Kaisse!")))

        ;; add to root
        (when (first-run-p)
          (gtk-box-pack-end root welcome-message))))))
