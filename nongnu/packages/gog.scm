;;; Copyright © 2019 Alex Griffin <a@ajgrf.com>
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-module (nongnu packages gog)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:))

(define-public lgogdownloader
  (package
    (name "lgogdownloader")
    (version "3.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Sude-/lgogdownloader.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0a3rrkgqwdqxx3ghzw182jx88gzzw6ldp3jasmgnr4l7gpxkmwws"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f                       ; no tests
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'patch-find-jsoncpp
           (lambda* _
             (substitute* "cmake/FindJsoncpp.cmake"
               (("features.h") "allocator.h"))
             #t)))))
    (inputs
     `(("boost" ,boost)
       ("curl" ,curl)
       ("htmlcxx" ,htmlcxx)
       ("jsoncpp" ,jsoncpp)
       ("liboauth" ,liboauth)
       ("rhash" ,rhash)
       ("tinyxml2" ,tinyxml2)
       ("zlib" ,zlib)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "https://sites.google.com/site/gogdownloader/")
    (synopsis "Downloader for GOG.com files")
    (description "LGOGDownloader is a client for the GOG.com download API,
allowing simple downloads and updates of games and other files from GOG.com.")
    (license license:wtfpl2)))
